import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../sdk/leases.dart';
import '../common/house_selector.dart';
import '../common/tenant_selector.dart';

class LeasesHome extends StatefulWidget {
  const LeasesHome({super.key});

  @override
  State<LeasesHome> createState() => _LeasesHomeState();
}

class _LeasesHomeState extends State<LeasesHome> {
  final LeasesAPI _leasesAPI = LeasesAPI();
  Widget _gap() {
    return const SizedBox(
      height: 10,
    );
  }

  // keys
  final GlobalKey<FormState> _formKey = GlobalKey();
  // controllers
  final TextEditingController _startDateController = TextEditingController();

  bool _renewMonthly = true;

  Widget _addLeaseModal() {
    bool renew = false;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          left: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          right: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _startDateController,
              onTap: () async {
                var start = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050));
                setState(() {
                  _startDateController.text = start.toString();
                });
              },
              decoration: const InputDecoration(
                labelText: "Start Date",
              ),
            ),
            _gap(),
            _gap(),
            TenantSelector(callback: () {}),
            _gap(),
            const HouseSelector(),
            _gap(),
            SwitchListTile(
              value: renew,
              onChanged: (value) {
                renew = value;
              },
              title: const Text("Renew Monthly"),
            ),
            _gap(),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_renewMonthly) {
                        _renewMonthly = false;
                      }
                      // add lease
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lease added"),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.green,
                          width: 200,
                        ),
                      );
                    }
                  },
                  label: const Text("Save"),
                  icon: const Icon(Icons.done),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Leases",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (context) => _addLeaseModal(),
                  );
                },
                label: const Text("Add Lease"),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _leasesAPI.get(leasesUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("${snapshot.data!['leases'][index].id}"),
                            behavior: SnackBarBehavior.floating,
                            width: 300,
                            backgroundColor: Colors.green,
                            action: SnackBarAction(
                              label: "Close",
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              },
                            ),
                          ),
                        );
                      },
                      leading: const CircleAvatar(
                        child: FlutterLogo(),
                      ),
                      title: Text("${snapshot.data!['leases'][index].id}"),
                    );
                  },
                  itemCount: snapshot.data!['leases'].length ?? 0,
                ),
              );
            }
            return const Text("An error occurred");
          },
        )
      ],
    );
  }
}
