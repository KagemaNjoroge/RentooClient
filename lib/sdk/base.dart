import 'package:file_selector/file_selector.dart';

abstract class BaseApi {
  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> post(String url, {Map<String, dynamic>? body});
  Future<Map<String, dynamic>> put(String url, {Map<String, dynamic>? body});
  Future<Map<String, dynamic>> delete(String url,
      {Map<String, dynamic>? queryParameters});
  Future<Map<String, dynamic>> patch(String url, {Map<String, dynamic>? body});
  dynamic handleError(dynamic e);

  Future<Map<String, dynamic>> uploadFile(String url, XFile file, String field);
  Future<Map<String, dynamic>> getItem(String url,
      {Map<String, dynamic>? queryParameters});
}
