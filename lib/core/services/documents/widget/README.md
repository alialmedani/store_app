# ImageUploadWidget - ويدجت رفع الصور

## الوصف
ويدجت متكامل لرفع الصور يوفر واجهة مستخدم جميلة ووظائف متقدمة لإدارة الصور في تطبيق jasim_housing. تم تطوير الويدجت ليكون **stateless** ويعتمد على **DocumentCubit** و **DocumentState** لإدارة الحالة.

## المميزات
- **تصميم stateless**: لا يحتوي على حالة داخلية، يعتمد على DocumentCubit
- **إدارة حالة reactive**: يستخدم BlocBuilder و BlocListener للتفاعل مع تغييرات الحالة
- تصميم يشبه الصورة المرفقة مع أيقونات PDF و IMG
- خيارات رفع متعددة: من المعرض أو التقاط صورة جديدة
- عرض الصور المحددة في شبكة منظمة
- إمكانية حذف الصور
- زر حفظ اختياري مع مؤشر تحميل
- دعم رفع صور متعددة
- رسائل نجاح وخطأ تلقائية
- تحديث تلقائي لمعاملات DocumentCubit

## الاستخدام

### المتطلبات الأساسية
```dart
// يجب أن يكون الويدجت داخل BlocProvider<DocumentCubit>
BlocProvider(
  create: (context) => DocumentCubit(),
  child: YourScreen(),
)
```

### 1. رفع مستند للمستخدم الحالي (مع زر الحفظ)
```dart
const ImageUploadWidget(
  masterType: 'profile_document',
  showSaveButton: true,
  title: 'رفع صورة شخصية',
  helperText: 'يرجى رفع صورة واضحة للهوية',
  maxImages: 1,
  // onImagesSelected اختياري الآن - يتم إدارة الحالة بواسطة DocumentCubit
)
```

### 2. رفع عدة مستندات
```dart
const ImageUploadWidget(
  entityType: 1,
  masterId: 'complaint_123',
  masterType: 'complaint_documents',
  title: 'رفع مستندات الشكوى',
  helperText: 'يمكنك رفع حتى 5 صور',
  maxImages: 5,
)
```

### 3. رفع مستند واحد
```dart
const ImageUploadWidget(
  entityType: 2,
  masterId: 'service_456',
  masterType: 'service_attachment',
  title: 'رفع مرفق الخدمة',
  maxImages: 1,
)
```

### 4. مراقبة حالة الرفع
```dart
BlocListener<DocumentCubit, DocumentState>(
  listener: (context, state) {
    if (state is DocumentUploadSuccess) {
      // تم الرفع بنجاح
    } else if (state is DocumentUploadError) {
      // حدث خطأ
    }
  },
  child: const ImageUploadWidget(...),
)
```

### 5. الوصول إلى الصور المحددة
```dart
BlocBuilder<DocumentCubit, DocumentState>(
  builder: (context, state) {
    final cubit = context.read<DocumentCubit>();
    final selectedImages = cubit.selectedImages;
    
    return Column(
      children: [
        ImageUploadWidget(...),
        Text('عدد الصور: ${selectedImages.length}'),
      ],
    );
  },
)
```

## المعاملات

### المعاملات الأساسية
- `entityType`: نوع الكيان (int?)
- `masterId`: معرف الكيان الرئيسي (String?)
- `masterType`: نوع الكيان الرئيسي (String?)

### المعاملات الاختيارية
- `onImagesSelected`: دالة تُستدعى عند اختيار الصور (Function(List<File>)?) - **اختياري الآن**
- `showSaveButton`: إظهار زر الحفظ (bool) - افتراضي: false
- `maxImages`: الحد الأقصى للصور (int) - افتراضي: 5
- `title`: العنوان فوق منطقة الرفع (String?)
- `helperText`: النص المساعد (String?)

## حالات DocumentState

### حالات الصور
- `DocumentInitial`: الحالة الأولية
- `DocumentImagesChanged`: تغيير في الصور المحددة
- `DocumentUploading`: جاري رفع الصور
- `DocumentUploadSuccess`: تم الرفع بنجاح
- `DocumentUploadError`: حدث خطأ في الرفع

## دوال DocumentCubit

### إدارة الصور
- `addImage(File image)`: إضافة صورة
- `removeImage(int index)`: حذف صورة بالموضع
- `clearImages()`: مسح جميع الصور
- `setImages(List<File> images)`: تعيين قائمة صور
- `setUploadParameters()`: تعيين معاملات الرفع

### دوال الرفع
- `uploadCurrentUserDocument()`: رفع مستندات المستخدم الحالي
- `uploadManyDocument()`: رفع عدة مستندات
- `uploadDocument()`: رفع مستند واحد

## منطق اختيار الدالة

يقوم الويدجت تلقائياً بتعيين معاملات الرفع، واختيار الدالة المناسبة يعتمد على الاستخدام:

1. **uploadManyDocument**: للرفع المباشر عند توفر جميع المعاملات
2. **uploadDocument**: للرفع المباشر لصورة واحدة
3. **uploadCurrentUserDocument**: عند استخدام زر الحفظ

## زر الحفظ

يظهر زر الحفظ فقط عندما:
- `showSaveButton = true`
- توجد صور محددة
- يستخدم دالة `uploadCurrentUserDocument`
- يُظهر مؤشر تحميل أثناء الرفع

## التصميم والمميزات الجديدة

### التصميم الأساسي
- حدود منقطة بلون primary
- خلفية بلون primary25
- أيقونات PDF و IMG ملونة
- نص "قم برفع الملف" و "(أقصى حجم 2MB)"
- زر "رفع الملف" بتصميم مطابق

### المميزات الجديدة
- **رسائل تلقائية**: رسائل نجاح وخطأ عبر SnackBar
- **مؤشرات تحميل**: أثناء عمليات الرفع
- **تحديث reactive**: الواجهة تتحدث تلقائياً مع تغيير الحالة
- **إدارة حالة محسنة**: لا يوجد state داخلي في الويدجت

## المتطلبات

- `flutter_bloc` للإدارة الحالة
- `dotted_border` للحدود المنقطة
- `image_picker` لاختيار الصور
- `flutter_svg` للأيقونات

## مثال كامل

انظر إلى `image_upload_example.dart` لمثال شامل يوضح جميع حالات الاستخدام والمميزات الجديدة.
- `flutter_svg` للأيقونات

## ملاحظات
- يتم تحديث معاملات DocumentCubit تلقائياً عند اختيار الصور
- يمكن حذف الصور بالضغط على أيقونة X
- يظهر زر "إضافة صورة أخرى" عند وجود صور ولم يتم الوصول للحد الأقصى
