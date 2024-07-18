import 'package:dio/dio.dart';

import '../models/unit.dart';


const unitsUrl = 'http://localhost:8000/units/';
final dio = Dio();

Future<Map<String, dynamic>> fetchUnits() async {
  final response = await dio.get(unitsUrl, options: Options());

  if (response.statusCode == 200) {
    var units = [];
    for (var prop in response.data) {
      units.add(Unit.fromJson(prop));
    }

    return {
      "status": "success",
      "units": units,
    };
  } else {
    throw "An error occured";
  }
}
