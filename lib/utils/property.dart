import 'package:dio/dio.dart';

import '../models/house.dart';
import '../models/property.dart';

const propertyUrl = "http://localhost:8000/properties/";
const housesUrl = "http://localhost:8000/houses/";

final dio = Dio();

Future<Map<String, dynamic>> fetchProperty() async {
  final response = await dio.get(propertyUrl, options: Options());

  //await Future.delayed(const Duration(seconds: 5), () {});

  if (response.statusCode == 200) {
    var property = [];
    for (var prop in response.data) {
      property.add(Property.fromJson(prop));
    }

    return {
      "status": "success",
      "property": property,
    };
  } else {
    throw "An error occured";
  }
}

Future<Map<String, dynamic>> fetchHouses() async {
  final response = await dio.get(housesUrl, options: Options());
  if (response.statusCode == 200) {
    var houses = [];
    for (var prop in response.data) {
      houses.add(House.fromJson(prop));
    }

    return {
      "status": "success",
      "houses": houses,
    };
  } else {
    throw "An error occured";
  }
}

Future<Map<String, dynamic>> addProperty(Property property) async {
  final response = await dio.post(
    propertyUrl,
    data: {
      "name": property.name,
      "address": property.address,
      "description": property.description
    },
  );

  if (response.statusCode == 201) {
    return {
      "status": "success",
      "message": "Property added successfully",
    };
  } else {
    return {
      "status": "error",
      "message": "An error occurred",
    };
  }
}
