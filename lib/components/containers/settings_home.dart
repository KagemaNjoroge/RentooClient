import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/brightness.dart';
import '../../utils/snack.dart';

class SettingHome extends StatefulWidget {
  const SettingHome({super.key});

  @override
  State<SettingHome> createState() => _SettingHomeState();
}

class _SettingHomeState extends State<SettingHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            applicationName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const Text(
            applicationLegalese,
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 10),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  child: Icon(Icons.settings),
                )
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Notification settings"),
                SwitchListTile(
                  value: false,
                  onChanged: (val) {},
                  title: const Text("Rent Payment"),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (val) {},
                  title: const Text("Maintenance Requests"),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: (val) {},
                  title: const Text("System upgrade"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                SwitchListTile(
                  value: Provider.of<BrightnessProvider>(context).isDark,
                  onChanged: (val) {
                    Provider.of<BrightnessProvider>(context, listen: false)
                        .swithTheme();
                  },
                  title: const Text("Switch theme"),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                ListTile(
                  title: const Row(
                    children: [Text("Support"), Icon(Icons.support_agent)],
                  ),
                  subtitle: const Text(
                      "Facing an issue using $applicationName? Contact us"),
                  onTap: () {
                    showSnackBar(
                        context, Colors.green, "Add an action here", 300);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                ListTile(
                  title: const Text("Licenses"),
                  subtitle: const Text("Click here to view licenses"),
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationIcon: const FlutterLogo(),
                      applicationVersion: applicationVersion,
                      applicationName: applicationName,
                      applicationLegalese: applicationLegalese,
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                const ListTile(
                  title: Text(applicationName),
                  subtitle: Text(applicationVersion),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
