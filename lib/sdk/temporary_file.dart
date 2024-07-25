import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';

import '../models/temporary_file.dart';
import 'base.dart';

class TemporaryFileAPI implements BaseApi {
  final Dio _dio = Dio();

  @override
  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? body}) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> put(String url,
      {Map<String, dynamic>? body}) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> delete(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(url, queryParameters: queryParameters);
      if (response.statusCode == 204) {
        return {
          "status": "success",
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to delete file",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> patch(String url,
      {Map<String, dynamic>? body}) async {
    throw UnimplementedError();
  }

  @override
  dynamic handleError(dynamic e) {
    if (e is DioException) {
      String? message = e.message;
      if (e.response != null) {
        message = e.response?.data.toString();
      }
      return {
        "status": "error",
        "message": message,
      };
    } else {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }

  @override
  Future<Map<String, dynamic>> uploadFile(
      String url, XFile file, String field) async {
    // Create a FormData
    FormData formData = FormData.fromMap({
      field: await MultipartFile.fromFile(file.path),
    });

    try {
      var response = await _dio.post(url, data: formData);
      if (response.statusCode == 201) {
        return {
          "status": "success",
          "file": TemporaryFile.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to upload $field",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }
}
