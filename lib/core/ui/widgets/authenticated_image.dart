import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../classes/cashe_helper.dart';

/// Widget to display images from authenticated endpoints
/// Uses Dio to fetch image with Bearer token
class AuthenticatedImage extends fw.StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final fw.BoxFit fit;
  final fw.Widget? placeholder;
  final fw.Widget? errorWidget;

  const AuthenticatedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = fw.BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  fw.State<AuthenticatedImage> createState() => _AuthenticatedImageState();
}

class _AuthenticatedImageState extends fw.State<AuthenticatedImage> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {

      final dio = Dio();
      final token = CacheHelper.token;

      final response = await dio.get(
        widget.imageUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (mounted) {
        setState(() {
          _imageBytes = Uint8List.fromList(response.data);
          _isLoading = false;
          _hasError = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return widget.placeholder ??
          fw.Container(
            width: widget.width,
            height: widget.height,
            decoration: fw.BoxDecoration(
              color: theme.colorScheme.muted,
              borderRadius: fw.BorderRadius.circular(8),
            ),
            child: fw.Center(
              child: fw.SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
    }

    if (_hasError || _imageBytes == null) {
      return widget.errorWidget ??
          fw.Container(
            width: widget.width,
            height: widget.height,
            decoration: fw.BoxDecoration(
              color: theme.colorScheme.muted,
              borderRadius: fw.BorderRadius.circular(8),
            ),
            child: fw.Icon(
              Icons.image_not_supported,
              color: theme.colorScheme.mutedForeground,
              size: 30,
            ),
          );
    }

    return fw.Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      errorBuilder: (context, error, stackTrace) {
        return widget.errorWidget ??
            fw.Container(
              width: widget.width,
              height: widget.height,
              decoration: fw.BoxDecoration(
                color: theme.colorScheme.muted,
                borderRadius: fw.BorderRadius.circular(8),
              ),
              child: fw.Icon(
                Icons.image_not_supported,
                color: theme.colorScheme.mutedForeground,
                size: 30,
              ),
            );
      },
    );
  }
}
