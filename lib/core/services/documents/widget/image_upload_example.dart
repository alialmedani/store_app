// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'image_upload_widget.dart';
// import '../cubit/document_cubit.dart';

// /// Example screen showing different use cases of ImageUploadWidget
// class ImageUploadExampleScreen extends StatelessWidget {
//   const ImageUploadExampleScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('مثال على ويدجت رفع الصور')),
//       body: BlocProvider(
//         create: (context) => DocumentCubit(),
//         child: BlocBuilder<DocumentCubit, DocumentState>(
//           builder: (context, state) {
//             final cubit = context.read<DocumentCubit>();
//             final selectedImages = cubit.selectedImages;

//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
 

//                   // Example 1: Upload current user document with save button
           
//                   const ImageUploadWidget(
//                     masterType: 'profile_document',
//                     showSaveButton: true,
//                     title: 'رفع صورة شخصية',
//                     helperText: 'يرجى رفع صورة واضحة للهوية',
//                     maxImages: 1,
//                   ),

            

//                   // Example 2: Upload many documents
            
//                   const ImageUploadWidget(
//                     entityType: 1,
//                     masterId: 'complaint_123',
//                     masterType: 'complaint_documents',
//                     title: 'رفع مستندات الشكوى',
//                     helperText: 'يمكنك رفع حتى 5 صور',
//                     maxImages: 5,
//                   ),
//                   // Example 3: Upload single document
//                   const SizedBox(height: 16),
//                   const ImageUploadWidget(
//                     entityType: 2,
//                     masterId: 'service_456',
//                     masterType: 'service_attachment',
//                     title: 'رفع مرفق الخدمة',
//                     maxImages: 1,
//                   ),

//                   const SizedBox(height: 32),

//                   // Action buttons
//                   _buildActionButtons(context, cubit),

//                   const SizedBox(height: 16),

//                   // Show selected images count
//                   if (selectedImages.isNotEmpty)
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade50,
//                         border: Border.all(color: Colors.green),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'تم اختيار ${selectedImages.length} صورة',
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ...selectedImages.asMap().entries.map(
//                             (entry) => Text(
//                               'صورة ${entry.key + 1}: ${entry.value.path.split('/').last}',
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildStateIndicator(DocumentState state, int imageCount) {
//     Widget stateWidget;
//     Color backgroundColor;
//     Color textColor;
//     IconData icon;

//     switch (state.runtimeType) {
//       case DocumentInitial:
//         icon = Icons.info_outline;
//         backgroundColor = Colors.blue.shade50;
//         textColor = Colors.blue;
//         stateWidget = Text(
//           'الحالة: جاهز لرفع الصور',
//           style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
//         );
//         break;
//       case DocumentImagesChanged:
//         icon = Icons.image;
//         backgroundColor = Colors.orange.shade50;
//         textColor = Colors.orange;
//         stateWidget = Text(
//           'الحالة: تم اختيار $imageCount صورة',
//           style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
//         );
//         break;
//       case DocumentUploading:
//         icon = Icons.cloud_upload;
//         backgroundColor = Colors.blue.shade50;
//         textColor = Colors.blue;
//         stateWidget = Row(
//           children: [
//             SizedBox(
//               width: 16,
//               height: 16,
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               'الحالة: جاري رفع الصور...',
//               style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
//             ),
//           ],
//         );
//         break;
//       case DocumentUploadSuccess:
//         icon = Icons.check_circle;
//         backgroundColor = Colors.green.shade50;
//         textColor = Colors.green;
//         stateWidget = Text(
//           'الحالة: تم رفع الصور بنجاح',
//           style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
//         );
//         break;
//       case DocumentUploadError:
//         icon = Icons.error;
//         backgroundColor = Colors.red.shade50;
//         textColor = Colors.red;
//         final errorState = state as DocumentUploadError;
//         stateWidget = Text(
//           'الحالة: خطأ - ${errorState.message}',
//           style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
//         );
//         break;
//       default:
//         icon = Icons.help_outline;
//         backgroundColor = Colors.grey.shade50;
//         textColor = Colors.grey;
//         stateWidget = Text(
//           'الحالة: غير معروف',
//           style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
//         );
//     }

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         border: Border.all(color: textColor.withValues(alpha:0.3)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: textColor),
//           const SizedBox(width: 12),
//           Expanded(child: stateWidget),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButtons(BuildContext context, DocumentCubit cubit) {
//     return Column(
//       children: [
//         const Text(
//           'إجراءات إضافية:',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: cubit.selectedImages.isNotEmpty
//                     ? () {
//                         cubit.clearImages();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('تم مسح جميع الصور'),
//                             backgroundColor: Colors.orange,
//                           ),
//                         );
//                       }
//                     : null,
//                 icon: const Icon(Icons.clear),
//                 label: const Text('مسح الكل'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: ElevatedButton.icon(
//                 onPressed: cubit.selectedImages.isNotEmpty
//                     ? () async {
//                         try {
//                           await cubit.uploadManyDocument();
//                         } catch (e) {
//                           // Error handled by BlocListener
//                         }
//                       }
//                     : null,
//                 icon: const Icon(Icons.cloud_upload),
//                 label: const Text('رفع الصور'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
