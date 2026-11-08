import 'package:flutter/widgets.dart' as fw;
import 'package:store/core/ui/kit/app_kit.dart';
import 'authenticated_image.dart';

/// Opens [imageUrl] full screen with pinch-to-zoom. Tap anywhere or the
/// close button to dismiss.
Future<void> showImageViewer(fw.BuildContext context, String imageUrl) {
  return fw.Navigator.of(context).push(
    fw.PageRouteBuilder(
      opaque: false,
      barrierColor: const fw.Color(0xEB05060F),
      transitionDuration: const Duration(milliseconds: 180),
      reverseTransitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (ctx, _, __) => _ImageViewer(imageUrl: imageUrl),
      transitionsBuilder: (ctx, anim, _, child) =>
          fw.FadeTransition(opacity: anim, child: child),
    ),
  );
}

class _ImageViewer extends fw.StatelessWidget {
  final String imageUrl;
  const _ImageViewer({required this.imageUrl});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.GestureDetector(
      behavior: fw.HitTestBehavior.opaque,
      onTap: () => fw.Navigator.of(context).pop(),
      child: fw.Stack(
        children: [
          fw.Positioned.fill(
            child: fw.InteractiveViewer(
              minScale: 1,
              maxScale: 5,
              child: fw.Center(
                child: AuthenticatedImage(
                  imageUrl: imageUrl,
                  fit: fw.BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  errorWidget: const fw.Icon(
                    Icons.broken_image_outlined,
                    size: 64,
                    color: fw.Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          fw.SafeArea(
            child: fw.Align(
              alignment: fw.AlignmentDirectional.topEnd,
              child: fw.Padding(
                padding: const fw.EdgeInsets.all(16),
                child: fw.GestureDetector(
                  onTap: () => fw.Navigator.of(context).pop(),
                  child: fw.Container(
                    width: 44,
                    height: 44,
                    decoration: fw.BoxDecoration(
                      color: const fw.Color(0xFFFFFFFF).withValues(alpha: 0.16),
                      borderRadius: fw.BorderRadius.circular(14),
                    ),
                    child: const fw.Icon(
                      Icons.close_rounded,
                      color: fw.Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
