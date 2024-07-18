import 'package:dio/dio.dart';

import '../models/tenant.dart';

final dio = Dio();

const tenantsUrl = "http://localhost:8000/tenants";

Future<Map<String, dynamic>> fetchTenants() async {
  var response = await dio.get(tenantsUrl);
  if (response.statusCode == 200) {
    var tenants = [];
    for (var prop in response.data) {
      tenants.add(Tenant.fromJson(prop));
    }

    return {
      "status": "success",
      "tenants": tenants,
    };
  } else {
    throw "An error occured";
  }
}
