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
final List<Map<String, String>> maintainerTypes = [
  {
    "name": "Individual",
    "value": "Individual",
  },
  {
    "name": "Company",
    "value": "Company",
  }
];
//endpoints
const server = "http://localhost:8000";
const companyUrl = "$server/company/";
const propertyUrl = "$server/properties/";
const housesUrl = "$server/houses/";
const tenantsUrl = "$server/tenants/";
const leasesUrl = "$server/leases/";
const notificationsUrl = "$server/notifications/";
const unitsUrl = '$server/units/';
const agentsUrl = "$server/agents/";
const usersUrl = "$server/users/";
const tempUrl = "$server/temporary-files/";
const propertyStatsUrl = "$server/stats/property-stats/";
const mpesaPaymentSettingsUrl = "$server/mpesa-payment-settings/";
const photosUrl = "$server/photos/";
const houseStatsUrl = "$server/stats/property/";
const paymentsUrl = "$server/payments/";
const paymentMethodsUrl = "$server/payment-methods/";
const maintenanceRequestsUrl = "$server/maintenance-request/";
const maintainersUrl = "$server/maintainers/";
