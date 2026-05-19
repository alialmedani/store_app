// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../generated/l10n.dart';
// import '../../constant/app_icons/app_icons.dart';
// import '../../ui/widgets/upload_document.dart';

// final ImagePicker _picker = ImagePicker();

// void showUploadOptionsBottomSheet(
//   BuildContext context,
//   Function(File) onSingleSelected,
// ) {
//   showModalBottomSheet(
//     context: context,
//     barrierColor: Colors.black.withAlpha((0.2 * 255).toInt()),
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//     ),
//     backgroundColor: Colors.white,
//     builder: (context) {
//       return Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(S.of(context).Choose_method_upload_image),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             UploadOptionButton(
//               icon: imageIcon,
//               text: S.of(context).Select_photo_gallery,
//               onTap: () async {
//                 Navigator.pop(context);
//                 await pickMultipleImages((files) {
//                   for (var f in files) {
//                     onSingleSelected(f);
//                   }
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             UploadOptionButton(
//               icon: cameraIcon,
//               text: S.of(context).Take_live_photo,
//               onTap: () async {
//                 Navigator.pop(context);
//                 await pickSingleImage(ImageSource.camera, onSingleSelected);
//               },
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// Future<void> pickSingleImage(
//   ImageSource source,
//   Function(File) onSelected,
// ) async {
//   final XFile? pickedFile = await _picker.pickImage(
//     source: source,
//     imageQuality: 80,
//   );
//   if (pickedFile != null) {
//     onSelected(File(pickedFile.path));
//   }
// }

// Future<void> pickMultipleImages(Function(List<File>) onSelected) async {
//   final List<XFile> pickedFiles = await _picker.pickMultiImage(
//     imageQuality: 80,
//   );
//   if (pickedFiles.isNotEmpty) {
//     final files = pickedFiles.map((xfile) => File(xfile.path)).toList();
//     onSelected(files);
//   }
// }
