import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';

import '../models/company.dart';
import 'base.dart';

class CompanyAPI implements BaseApi {
  final Dio _dio = Dio();

  @override
  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        var companies = <Company>[];
        for (var prop in response.data) {
          companies.add(Company.fromJson(prop));
        }

        return {
          "status": "success",
          "companies": companies,
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to load companies",
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
          "company": Company.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to create company",
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
          "company": Company.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to update company",
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
          error: "Failed to delete company",
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
          "company": Company.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to patch company",
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
      String url, XFile file, String field) async {
    // Create a FormData
    FormData formData = FormData.fromMap({
      "logo": await MultipartFile.fromFile(file.path),
    });
    // send patch request, assuming the company had been created
    try {
      var response = await _dio.patch(url, data: formData);
      if (response.statusCode == 200) {
        return {
          "status": "success",
          "company": Company.fromJson(response.data),
        };
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: "Failed to upload logo",
        );
      }
    } catch (e) {
      throw handleError(e);
    }
  }
}
