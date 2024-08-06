import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/containers/communication.dart';
import '../components/containers/dashboard.dart';
import '../components/containers/help_and_support.dart';
import '../components/containers/houses_home.dart';
import '../components/containers/leases_home.dart';
import '../components/containers/maintenance.dart';
import '../components/containers/payments_home.dart';
import '../components/containers/property_home.dart';
import '../components/containers/reports.dart';
import '../components/containers/settings_home.dart';
import '../components/containers/tenants_home.dart';
import '../components/notifications.dart';
import '../constants.dart';
import '../providers/auth_provider.dart';
import '../providers/brightness.dart';
import '../utils/snack.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // state
  bool _railExpanded = false;
  bool _isLoading = false;
  List<NavigationRailDestination> destinations = [
    const NavigationRailDestination(
      icon: Icon(Icons.home),
      label: Text("Dashboard"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.apartment),
      label: Text("Property"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.bungalow),
      label: Text("Houses"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.people),
      label: Text("Tenants"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.badge),
      label: Text("Leases"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.receipt_outlined),
      label: Text("Reports"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.payment),
      label: Text("Payments"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.handyman_outlined),
      label: Text("Maintenance"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.message),
      label: Text("Communication"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text("Settings"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.help_outline_outlined),
      label: Text("Help & Support"),
    ),
  ];

  int _selectedDestination = 0;

  final List<Widget> _items = [
    const Dashboard(),
    const PropertyHome(),
    const HousesHome(),
    const TenantsHome(),
    const LeasesHome(),
    const Reports(),
    const PaymentsHome(),
    const MaintenanceHome(),
    const Communication(),
    const SettingHome(),
    const HelpAndSupportHome()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              onDestinationSelected: (value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
              destinations: destinations,
              selectedIndex: _selectedDestination,
              elevation: 3,
              extended: _railExpanded,
              trailing: IconButton(
                tooltip: "Logout",
                icon: _isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Icon(Icons.logout),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<AuthProvider>(context, listen: false)
                      .removeCredentials();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    ),
                  );
                },
              ),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _railExpanded = !_railExpanded;
                  });
                },
                icon: _railExpanded
                    ? const Icon(Icons.arrow_back)
                    : const Icon(Icons.menu),
              ),
            ),
            Expanded(
                child: Card(
              elevation: 5,
              child: _items[_selectedDestination],
            ))
          ],
        ),
        appBar: _appBar());
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 60),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Text(
                    applicationName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3, bottom: 3),
                  height: 50,
                  width: 300,
                  child: const Expanded(
                    flex: 1,
                    child: Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  tooltip: "Notifications",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          icon: const Icon(Icons.notifications),
                          title: const Text("Notifications"),
                          content: const SizedBox(
                            width: 400,
                            height: 300,
                            child: NotificationsModal(),
                          ),
                          actions: [
                            TextButton.icon(
                              label: const Text("Close"),
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.notifications),
                ),
                IconButton(
                  tooltip: "AI assistant",
                  onPressed: () {
                    showSnackBar(
                        context, Colors.green, "Attach action here", 300);
                  },
                  icon: const Icon(Icons.assistant),
                ),
                IconButton(
                  tooltip: "Theme",
                  onPressed: () {
                    Provider.of<BrightnessProvider>(context, listen: false)
                        .swithTheme();
                  },
                  icon: Provider.of<BrightnessProvider>(context).isDark
                      ? const Icon(Icons.dark_mode)
                      : const Icon(Icons.light_mode),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
