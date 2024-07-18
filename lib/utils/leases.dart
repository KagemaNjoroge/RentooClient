import 'package:dio/dio.dart';

import '../models/lease.dart';

const leasesUrl = "http://localhost:8000/leases/";

final dio = Dio();

Future<Map<String, dynamic>> fetchLeases() async {
  final response = await dio.get(leasesUrl, options: Options());

  if (response.statusCode == 200) {
    var leases = [];
    for (var prop in response.data) {
      leases.add(Lease.fromJson(prop));
    }

    return {
      "status": "success",
      "leases": leases,
    };
  } else {
    throw "An error occured";
  }
}
