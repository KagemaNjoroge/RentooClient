import 'package:flutter/material.dart';
import 'package:rentoo_pms/pages/login.dart';

import '../components/containers/communication.dart';
import '../components/containers/company_home.dart';
import '../components/containers/components.dart';
import '../components/containers/dashboard.dart';
import '../components/containers/houses_home.dart';
import '../components/containers/leases_home.dart';
import '../components/containers/payments_home.dart';
import '../components/containers/property_home.dart';
import '../components/containers/settings_home.dart';
import '../components/containers/tenants_home.dart';
import '../components/notifications.dart';
import '../constants.dart';
import '../utils/snack.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // state
  bool _railExpanded = false;
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
      icon: Icon(Icons.payment),
      label: Text("Payments"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.message),
      label: Text("Communication"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.business),
      label: Text("Company"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.settings),
      label: Text("Settings"),
    ),
    const NavigationRailDestination(
      icon: Icon(Icons.handyman),
      label: Text("Components"),
    ),
  ];

  int _selectedDestination = 0;

  final List<Widget> _items = [
    const Dashboard(),
    const PropertyHome(),
    const HousesHome(),
    const TenantsHome(),
    const LeasesHome(),
    const PaymentsHome(),
    const Communication(),
    const CompanyHome(),
    const SettingHome(),
    const Components()
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
                icon: const Icon(Icons.logout),
                onPressed: () {
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: IconButton(
                tooltip: "Notifications",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Notifications"),
                        content: const NotificationsModal(),
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
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: IconButton(
                tooltip: "AI assistant",
                onPressed: () {
                  showSnackBar(
                      context, Colors.green, "Attach action here", 300);
                },
                icon: const Icon(Icons.assistant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
