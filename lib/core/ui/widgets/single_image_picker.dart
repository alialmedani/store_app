// import 'dart:io';
 

// import 'package:flutter/material.dart';
// import 'package:share_plus/share_plus.dart';

// import '../../constant/app_colors/app_colors.dart';

// class SingleImagePicker extends StatefulWidget {
//   const SingleImagePicker({
//     super.key,
//     required this.onChanged,
//     this.value,
//     this.title = 'قم برفع الملف',
//     this.helperText = '( أقصى حجم 2MB )',
//     this.previewHeight = 150,
//     this.placeholderIcon,
//     this.borderRadius = 12,
//     this.enabled = true,
//   });

//   /// القيمة الحالية (إن وجدت)
//   final File? value;

//   /// يُستدعى عند اختيار/حذف الصورة؛ مرِّر null للحذف
//   final ValueChanged<File?> onChanged;

//   /// عنوان أعلى منطقة الرفع
//   final String title;

//   /// نص مساعد تحت العنوان
//   final String helperText;

//   /// ارتفاع معاينة الصورة
//   final double previewHeight;

//   /// أيقونة/ودجت تُعرض كعنصر بصري داخل منطقة الرفع
//   final Widget? placeholderIcon;

//   /// نصف قطر الحواف
//   final double borderRadius;

//   /// تمكين/تعطيل عنصر الرفع
//   final bool enabled;

//   @override
//   State<SingleImagePicker> createState() => _SingleImagePickerState();
// }

// // class _SingleImagePickerState extends State<SingleImagePicker> {
// //   static final ImagePicker _picker = ImagePicker();

// //   Future<void> _pick(ImageSource source) async {
// //     final XFile? xfile = await _picker.pickImage(
// //       source: source,
// //       imageQuality: 80,
// //     );
// //     if (!mounted) return;
// //     if (xfile != null) {
// //       widget.onChanged(File(xfile.path));
// //       Navigator.of(context).maybePop();
// //     }
// //   }

// //   void _showPickerSheet() {
// //     if (!widget.enabled) return;
// //     showModalBottomSheet(
// //       context: context,
// //       barrierColor: Colors.black.withValues(alpha: 0.2),
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
// //       ),
// //       backgroundColor: Colors.white,
// //       builder: (context) {
// //         return SafeArea(
// //           child: Padding(
// //             padding: const EdgeInsets.all(24),
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Row(
// //                   children: [
// //                     const Expanded(
// //                       child: Text(
// //                         'اختر طريقة رفع الصورة',
// //                         style: TextStyle(fontWeight: FontWeight.w600),
// //                       ),
// //                     ),
// //                     IconButton(
// //                       icon: const Icon(Icons.close),
// //                       onPressed: () => Navigator.pop(context),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),
// //                 ListTile(
// //                   leading: const Icon(Icons.photo_library_outlined),
// //                   title: const Text('اختيار صورة من المعرض'),
// //                   onTap: () => _pick(ImageSource.gallery),
// //                 ),
// //                 const SizedBox(height: 8),
// //                 ListTile(
// //                   leading: const Icon(Icons.photo_camera_outlined),
// //                   title: const Text('التقاط صورة بالكاميرا'),
// //                   onTap: () => _pick(ImageSource.camera),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (widget.value != null) {
// //       return Stack(
// //         children: [
// //           ClipRRect(
// //             borderRadius: BorderRadius.circular(widget.borderRadius),
// //             child: Image.file(
// //               widget.value!,
// //               height: widget.previewHeight,
// //               width: double.infinity,
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //           PositionedDirectional(
// //             top: 8,
// //             end: 8,
// //             child: Material(
// //               color: Colors.black54,
// //               shape: const CircleBorder(),
// //               child: InkWell(
// //                 customBorder: const CircleBorder(),
// //                 onTap: widget.enabled ? () => widget.onChanged(null) : null,
// //                 child: const Padding(
// //                   padding: EdgeInsets.all(6),
// //                   child: Icon(Icons.close, size: 18, color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       );
// //     }

// //     return DottedBorder(
// //       options: CustomPathDottedBorderOptions(
// //         color: AppColors.primary,
// //         strokeWidth: 1.5,
// //         dashPattern: [6, 4],
// //         customPath: (size) => Path()
// //           ..addRRect(
// //             RRect.fromRectAndRadius(
// //               Rect.fromLTWH(0, 0, size.width, size.height),
// //               const Radius.circular(12),
// //             ),
// //           ),
// //       ),
// //       child: InkWell(
// //         borderRadius: BorderRadius.circular(widget.borderRadius),
// //         onTap: _showPickerSheet,
// //         child: Container(
// //           width: double.infinity,
// //           padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
// //           decoration: BoxDecoration(
// //             color: AppColors.primary50,
// //             borderRadius: BorderRadius.circular(widget.borderRadius),
// //           ),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               widget.placeholderIcon ??
// //                   const Icon(Icons.cloud_upload_outlined, size: 40),
// //               const SizedBox(height: 12),
// //               Text(
// //                 widget.title,
// //                 textAlign: TextAlign.center,
// //                 style: Theme.of(context).textTheme.bodyMedium,
// //               ),
// //               const SizedBox(height: 6),
// //               Text(
// //                 widget.helperText,
// //                 textAlign: TextAlign.center,
// //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
// //                   color: Theme.of(context).hintColor,
// //                 ),
// //               ),
// //               const SizedBox(height: 12),
// //               OutlinedButton.icon(
// //                 onPressed: _showPickerSheet,
// //                 icon: const Icon(Icons.upload_file, color: AppColors.primary),
// //                 label: Text(
// //                   S.of(context).Upload_file,
// //                   style: AppTextStyle.getMediumStyle(color: AppColors.black),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
