import 'package:dio/dio.dart';

import '../models/company.dart';

const companyUrl = "http://localhost:8000/company/";
final dio = Dio();
Future<Map<String, dynamic>> fetchCompany() async {
  final response = await dio.get(companyUrl, options: Options());
  if (response.statusCode == 200) {
    var companies = [];
    for (var prop in response.data) {
      companies.add(Company.fromJson(prop));
    }

    return {
      "status": "success",
      "companies": companies,
    };
  } else {
    throw "An error occured";
  }
}
