import 'dart:io';
import '../constant/end_points/api_url.dart';
import '../data_source/remote_data_source.dart';
import '../http/http_method.dart';
import '../models/file_upload_model.dart';
import '../repository/core_repository.dart';
import '../results/result.dart';

class FileUploadRepository extends CoreRepository {
  Future<Result<FileUploadModel>> uploadFile({
    required File file,
    required String entityId,
    required int entityType,
    required String filePlacement,
  }) async {
    final result = await RemoteDataSource.request<FileUploadModel>(
      withAuthentication: true,
      url: uploadFileUrl,
      method: HttpMethod.POST,
      file: file,
      fileKey: 'file',
      data: {
        'entityId': entityId,
        'entityType': entityType.toString(),
        'filePlacement': filePlacement,
      },
      converter: (json) {
        return FileUploadModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
