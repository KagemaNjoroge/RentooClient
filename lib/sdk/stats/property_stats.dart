import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';

import '../../models/stats/property_stats.dart';
import '../base.dart';

class PropertyStatsAPI implements BaseApi {
  final Dio _dio = Dio();

  @override
  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        var stats = PropertyStats.fromJson(response.data);
        return {
          "status": "success",
          "stats": stats,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to load stats",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
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
    throw UnimplementedError();
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
      String url, XFile file, String field) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getItem(String url,
      {Map<String, dynamic>? queryParameters}) {
    // TODO: implement getItem
    throw UnimplementedError();
  }
}
