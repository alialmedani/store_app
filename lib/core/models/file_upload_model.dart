class FileUploadModel {
  final String? id;
  final String? entityId;
  final int? entityType;
  final String? filePlacement;
  final String? fileName;
  final String? originalFileName;
  final String? blobName;
  final String? contentType;
  final int? size;

  FileUploadModel({
    this.id,
    this.entityId,
    this.entityType,
    this.filePlacement,
    this.fileName,
    this.originalFileName,
    this.blobName,
    this.contentType,
    this.size,
  });

  factory FileUploadModel.fromJson(Map<String, dynamic> json) {
    return FileUploadModel(
      id: json['id'],
      entityId: json['entityId'],
      entityType: json['entityType'],
      filePlacement: json['filePlacement'],
      fileName: json['fileName'],
      originalFileName: json['originalFileName'],
      blobName: json['blobName'],
      contentType: json['contentType'],
      size: json['size'],
    );
  }
}
