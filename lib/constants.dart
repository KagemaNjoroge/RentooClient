import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color.fromARGB(96, 134, 120, 127);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;
final List<Map<String, dynamic>> purposes = [
  {
    "name": "Residential",
    "value": "RESIDENTIAL",
  },
  {
    "name": "Commercial",
    "value": "COMMERCIAL",
  },
  {
    "name": "Other",
    "value": "OTHER",
  },
];

const String applicationName = "RentooPMS";
const String applicationLegalese =
    "Brought to you by the good folks at TomorrowAI";
const String applicationVersion = "0.1.0";



// endpoints
const companyUrl = "http://localhost:8000/company/";
