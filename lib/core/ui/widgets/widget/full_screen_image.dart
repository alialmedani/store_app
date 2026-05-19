import 'dart:io';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constant/app_colors/app_colors.dart';
import '../../../constant/text_styles/app_text_style.dart';
import '../../../constant/text_styles/font_size.dart';
import '../../dialogs/dialogs.dart';
import '../cached_image.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String title;

  const FullScreenImage({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyle.getMediumStyle(
                            color: AppColors.white,
                            fontSize: AppFontSize.size_16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        color: AppColors.white,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedImage(imageUrl: imageUrl),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _downloadImage(context),
                      icon: SvgPicture.asset("downloadIcon"),
                      label: Text(
                        "Download file",
                        style: AppTextStyle.getMediumStyle(
                          color: AppColors.red,
                          fontSize: AppFontSize.size_16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      if (context.mounted) {
        Dialogs.showSnackBar(
          message: "permission_denied",
          typeSnackBar: AnimatedSnackBarType.error,
        );
      }

      return;
    }

    try {
      final downloadsDir = Directory("/storage/emulated/0/Download");
      final savePath =
          "${downloadsDir.path}/${DateTime.now().millisecondsSinceEpoch}_$title.jpg";

      final dio = Dio();
      final response = await dio.download(
        imageUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            debugPrint(
              "Download progress: ${(received / total * 100).toStringAsFixed(0)}%",
            );
          }
        },
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          Dialogs.showSnackBar(
            message: "file_downloaded_successfully",
            typeSnackBar: AnimatedSnackBarType.success,
          );
        }
      } else {
        throw Exception('Failed to download');
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
        Dialogs.showSnackBar(
          message: "download_failed",
          typeSnackBar: AnimatedSnackBarType.error,
        );
      }
    }
  }
}
