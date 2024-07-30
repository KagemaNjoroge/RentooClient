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

final List<Map<String, dynamic>> maintenanceRequestStatuses = [
  {"name": "In Progress", "value": "In Progress"},
  {"name": "Scheduled", "value": "Scheduled"},
  {"name": "Complete", "value": "Complete"},
  {"name": "Pending", "value": "Pending"}
];

final List<Map<String, dynamic>> paymentStatuses = [
  {"name": "In Progress", "value": "In progress"},
  {"name": "Complete", "value": "Complete"},
  {"name": "Pending", "value": "Pending"},
  {"name": "Cancelled", "value": "Cancelled"}
];
const String applicationName = "RentooPMS";
const String applicationLegalese =
    "Brought to you by the good folks at TomorrowAI";
const String applicationVersion = "0.1.0";

const tenantTypes = [
  {
    "name": "Individual",
    "value": "Individual",
  },
  {
    "name": "Business",
    "value": "Business",
  },
];

//endpoints
const companyUrl = "http://localhost:8000/company/";
const propertyUrl = "http://localhost:8000/properties/";
const housesUrl = "http://localhost:8000/houses/";
const tenantsUrl = "http://localhost:8000/tenants/";
const leasesUrl = "http://localhost:8000/leases/";
const notificationsUrl = "http://localhost:8000/notifications/";
const unitsUrl = 'http://localhost:8000/units/';
const agentsUrl = "http://localhost:8000/agents/";
const usersUrl = "http://localhost:8000/users/";
const tempUrl = "http://localhost:8000/temporary-files/";
const propertyStatsUrl = "http://localhost:8000/stats/property-stats/";
const mpesaPaymentSettingsUrl = "http://localhost:8000/mpesa-payment-settings/";
const photosUrl = "http://localhost:8000/photos/";
const houseStatsUrl = "http://localhost:8000/stats/property/";
const paymentsUrl = "http://127.0.0.1:8000/payments/";
const paymentMethodsUrl = "http://127.0.0.1:8000/payment-methods/";
const maintenanceRequestsUrl = "http://localhost:8000/maintenance-request/";
