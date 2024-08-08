import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';

import '../models/tenant.dart';
import 'base.dart';

class TenantsAPI implements BaseApi {
  final Dio _dio = Dio();
  @override
  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        var tenants = <Tenant>[];
        for (var prop in response.data) {
          tenants.add(Tenant.fromJson(prop));
        }
        return {
          "status": "success",
          "tenants": tenants,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to load tenants",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String url,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.post(url, data: body);
      if (response.statusCode == 201) {
        return {
          "status": "success",
          "tenant": Tenant.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to create tenant",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String url,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.put(url, data: body);
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "tenant": Tenant.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to update tenant",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
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
          error: "Failed to delete tenant",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> patch(String url,
      {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.patch(url, data: body);
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "tenant": Tenant.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to patch tenant",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
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
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "tenant": Tenant.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to load tenant",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }
}
