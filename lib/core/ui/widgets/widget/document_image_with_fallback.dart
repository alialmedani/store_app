import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../classes/cashe_helper.dart';
import '../../../constant/app_colors/app_colors.dart';
import '../../../constant/text_styles/app_text_style.dart';
import '../../../constant/text_styles/font_size.dart';
import '../../dialogs/dialogs.dart';
import '../../../services/documents/cubit/document_cubit.dart';
import '../../../services/documents/data/service/dio_client_service.dart';
import 'file_upload_card.dart';
import 'upload_button.dart';

class DocumentImageWithFallback extends StatefulWidget {
  final String imageUrl;
  final String masterType;
  final String title;
  final Function(bool) onImageLoadStateChanged;
  final Function(bool) onImageSelected;

  final void Function(String? id)? onDocumentIdReady;

  const DocumentImageWithFallback({
    super.key,
    required this.imageUrl,
    required this.masterType,
    required this.title,
    required this.onImageLoadStateChanged,
    required this.onImageSelected,
    this.onDocumentIdReady,
  });

  @override
  State<DocumentImageWithFallback> createState() =>
      _DocumentImageWithFallbackState();
}

class _DocumentImageWithFallbackState extends State<DocumentImageWithFallback> {
  String? documentId;
  bool _showUploadOption = false;
  bool _imageLoaded = false;
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchDocumentId();
    _checkImageWithDelay();
  }

  Future<void> _fetchDocumentId() async {
    final dio = DioClient().dio;
    final authHeader = {'Authorization': 'Bearer ${CacheHelper.token}'};

    final cancelToken = CancelToken();
    try {
      final resp = await dio.get(
        widget.imageUrl,
        options: Options(
          headers: authHeader,
          responseType: ResponseType.stream,
          followRedirects: false,
          validateStatus: (_) => true,
          receiveDataWhenStatusError: true,
        ),
        cancelToken: cancelToken,
      );

      final headers = resp.headers;
      final id =
          headers.value('x-document-id') ?? headers.value('X-Document-Id');

      debugPrint('[GET stream] status=${resp.statusCode}');
      debugPrint('[GET stream] headers=${headers.map}');

      if (id != null && id.isNotEmpty && mounted) {
        setState(() => documentId = id);
        widget.onDocumentIdReady?.call(id);
      } else {
        debugPrint('[GET stream] x-document-id not found');
      }

      // ألغِ القراءة فوراً — ما نحتاج الجسم
      cancelToken.cancel('Got headers');
    } catch (e, st) {
      if (!CancelToken.isCancel(
        DioException(requestOptions: RequestOptions()),
      )) {
        debugPrint('[_fetchDocumentId] error: $e');
        debugPrint('$st');
      }
    }
  }

  void _checkImageWithDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!_imageLoaded && mounted && _selectedImage == null) {
      setState(() {
        _showUploadOption = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        children: [
          if (_selectedImage != null)
            _buildSelectedImageView(context)
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ExtendedImage.network(
                headers: {'Authorization': 'Bearer ${CacheHelper.token}'},
                widget.imageUrl,
                fit: BoxFit.cover,
                height: 220,
                width: double.infinity,
                printError: false,
                cacheMaxAge: const Duration(days: 365),
                clearMemoryCacheWhenDispose: true,
                handleLoadingProgress: true,
                loadStateChanged: (ExtendedImageState state) {
                  switch (state.extendedImageLoadState) {
                    case LoadState.loading:
                      return _buildLoadingWidget();
                    case LoadState.completed:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _imageLoaded = true;
                            _showUploadOption = false;
                          });
                          widget.onImageLoadStateChanged(true);
                        }
                      });
                      return state.completedWidget;
                    case LoadState.failed:
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _showUploadOption = true;
                          });
                          widget.onImageLoadStateChanged(false);
                        }
                      });
                      return _buildUploadFallback(context);
                  }
                },
              ),
            ),
          if (_showUploadOption && !_imageLoaded && _selectedImage == null)
            Positioned.fill(child: _buildUploadOverlay(context)),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 12),
            Text(
              "Loading...",
              style: AppTextStyle.getRegularStyle(
                color: Colors.grey.shade600,
                fontSize: AppFontSize.size_14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadFallback(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: _buildUploadContent(context),
    );
  }

  Widget _buildUploadOverlay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: _buildUploadContent(context),
    );
  }

  Widget _buildUploadContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Upload file",
          style: AppTextStyle.getBoldStyle(
            color: AppColors.primary,
            fontSize: AppFontSize.size_16,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            widget.title,
            style: AppTextStyle.getRegularStyle(
              color: Colors.grey.shade600,
              fontSize: AppFontSize.size_12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 16),
        UploadButton(onTap: () => _showUploadOptions(context)),
      ],
    );
  }

  Widget _buildSelectedImageView(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            height: 220,
            width: double.infinity,
          ),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          right: 12,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _cancelSelectedImage,
                  icon: const Icon(Icons.close, size: 18),
                  label: Text(
                    "Cancel",
                    style: AppTextStyle.getMediumStyle(
                      color: Colors.white,
                      fontSize: AppFontSize.size_14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _saveSelectedImage,
                  icon: _isUploading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.save, size: 18),
                  label: Text(
                    _isUploading ? "Uploading..." : "Save",
                    style: AppTextStyle.getMediumStyle(
                      color: Colors.white,
                      fontSize: AppFontSize.size_14,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _cancelSelectedImage() {
    setState(() {
      _selectedImage = null;
      _showUploadOption = true;
    });
    widget.onImageSelected(false);
  }

  Future<void> _saveSelectedImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final cubit = context.read<DocumentCubit>();
      cubit.uploadCurrentUserDocumentParams.photo.clear();
      cubit.uploadCurrentUserDocumentParams.photo.add(_selectedImage!);
      cubit.uploadCurrentUserDocumentParams.masterType = widget.masterType;

      await cubit.uploadCurrentUserDocument();

      if (mounted) {
        setState(() {
          _selectedImage = null;
          _isUploading = false;
          _imageLoaded = true;
          _showUploadOption = false;
        });

        widget.onImageLoadStateChanged(true);
        widget.onImageSelected(false);

        Dialogs.showSnackBar(
          message: "request_sent_successfully",
          typeSnackBar: AnimatedSnackBarType.success,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });

        Dialogs.showSnackBar(
          message: e.toString(),
          typeSnackBar: AnimatedSnackBarType.error,
        );
      }
    }
  }

  void _showUploadOptions(BuildContext context) {
    showUploadOptionsForDocumentBottomSheet(
      context,
      onImageSelected: (File selectedFile) {
        setState(() {
          _selectedImage = selectedFile;
          _showUploadOption = false;
        });
        widget.onImageSelected(true);
      },
    );
  }
}
