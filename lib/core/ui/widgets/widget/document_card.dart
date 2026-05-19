import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../boilerplate/create_model/widgets/create_model.dart';
import '../../../constant/app_colors/app_colors.dart';
import '../../../constant/app_icons/app_icons.dart';
import '../../../constant/text_styles/app_text_style.dart';
import '../../../constant/text_styles/font_size.dart';
import '../../dialogs/dialogs.dart';
import '../custom_button.dart';
import '../../../services/documents/cubit/document_cubit.dart';
import 'document_image_with_fallback.dart';
import 'full_screen_image.dart';

class DocumentCard extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String masterType;

  final Function(String id) onDelete;

  const DocumentCard({
    required this.title,
    required this.imageUrl,
    required this.masterType,
    required this.onDelete,
    super.key,
  });

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  bool _showDeleteButton = false;
  String? _docIdFromChild;
  Key _imageKey = UniqueKey(); // Add unique key for forcing image refresh

  void _onImageLoadStateChanged(bool imageLoaded) {
    if (mounted) {
      setState(() {
        _showDeleteButton = imageLoaded;
      });
    }
  }

  void _onImageSelected(bool hasSelectedImage) {}

  void refreshImageState() {
    setState(() {
      _showDeleteButton = false;
      _imageKey = UniqueKey(); // Force image widget to rebuild
    });
  }

  void _onDocumentDeleted() {
    if (mounted) {
      debugPrint('[DocumentCard] Document deleted, refreshing image state');
      setState(() {
        _showDeleteButton = false;
        _imageKey = UniqueKey(); // Force image refresh after deletion
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextStyle.getMediumStyle(
              color: AppColors.grey9A,
              fontSize: AppFontSize.size_16,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showDeleteButton
                ? () => _showFullScreenImage(context)
                : null,
            child: DocumentImageWithFallback(
              key: _imageKey, // Add key to force refresh
              imageUrl: widget.imageUrl,
              masterType: widget.masterType,
              title: widget.title,
              onImageLoadStateChanged: _onImageLoadStateChanged,
              onImageSelected: _onImageSelected,
              onDocumentIdReady: (id) => _docIdFromChild = id,
            ),
          ),
          if (_showDeleteButton)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: CreateModel(
                onSuccess: (model) async {
                  await context.read<DocumentCubit>().purgeImageCache(
                    widget.imageUrl,
                  );
                  _onDocumentDeleted();
                  if (context.mounted) {
                    Dialogs.showSnackBar(
                      message:"request_sent_successfully",
                      typeSnackBar: AnimatedSnackBarType.success,
                    );
                  }
                },
                onError: (val) {
                  Dialogs.showSnackBar(
                    message: '$val',
                    typeSnackBar: AnimatedSnackBarType.error,
                  );
                },
                withValidation: false,
                useCaseCallBack: (data) {
                  return widget.onDelete(_docIdFromChild!);
                },
                child: CustomButton(
                  w: 130,
                  h: 38,
                  radius: 50,
                  icon: SvgPicture.asset(deleteIcon),
                  color: AppColors.white,
                  borderSideColor: AppColors.red,
                  textStyle: AppTextStyle.getMediumStyle(
                    color: AppColors.red,
                    fontSize: AppFontSize.size_16,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.black28,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) =>
          FullScreenImage(imageUrl: widget.imageUrl, title: widget.title),
    );
  }
}
