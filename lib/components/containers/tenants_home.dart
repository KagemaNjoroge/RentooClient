import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/tenant.dart';
import '../../providers/destination_provider.dart';
import '../../sdk/tenants.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import '../common/progress_indicator.dart';
import 'tenant_details.dart';

class TenantsMainView extends StatefulWidget {
  const TenantsMainView({super.key});

  @override
  State<TenantsMainView> createState() => _TenantsMainViewState();
}

class _TenantsMainViewState extends State<TenantsMainView> {
  bool _isLoading = false;

  List<DropdownMenuItem> _tenantsTypes() {
    return tenantTypes
        .map(
          (e) => DropdownMenuItem(
            value: e['value'],
            child: Text(e['name']!),
          ),
        )
        .toList();
  }

  String tenantType = "Individual";

// controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
// keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TenantsAPI _tenantsAPI = TenantsAPI();

  Widget _addTenantModal() {
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
            DropdownButtonFormField(
              items: _tenantsTypes(),
              onChanged: (value) {
                tenantType = value.toString();
              },
              decoration: const InputDecoration(
                hintText: "Tenant Type",
              ),
            ),
            const Gap(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    controller: _firstNameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "First Name is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "First Name",
                    ),
                  ),
                ),
                const HorizontalGap(),
                Expanded(
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Last Name is required";
                      }
                      return null;
                    },
                    controller: _lastNameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Last Name",
                    ),
                  ),
                ),
              ],
            ),
            const Gap(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Phone Number"),
                  ),
                ),
                const HorizontalGap(),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email), hintText: "Email"),
                  ),
                ),
              ],
            ),
            const Gap(),
            TextFormField(
              controller: _websiteController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.language), hintText: "Website"),
            ),
            const Gap(),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Tenant tenant = Tenant(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        phoneNumber: _phoneController.text,
                        type: tenantType,
                        website: _websiteController.text,
                        houses: [],
                      );
                      // save
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        var response = await _tenantsAPI.post(
                          tenantsUrl,
                          body: tenant.toJson(),
                        );

                        if (response['status'] == "success") {
                          showSnackBar(context, Colors.green,
                              "Tenant added successfully", 300);
                          // clear fields
                          _firstNameController.clear();
                          _lastNameController.clear();
                          _emailController.clear();
                          _phoneController.clear();
                          _websiteController.clear();

                          Navigator.pop(context);
                        } else {
                          showSnackBar(
                              context, Colors.red, "An error occurred", 300);
                        }
                      } catch (e) {
                        showSnackBar(context, Colors.red, e.toString(), 300);
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  label: _isLoading
                      ? const CustomProgressIndicator()
                      : const Text("Save"),
                  icon: const Icon(Icons.done),
                ),
              ],
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tenants",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showBottomSheet(
                          context: context,
                          builder: (context) {
                            return _addTenantModal();
                          });
                    },
                    label: const Text("Add Tenant"),
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                  ),
                  const HorizontalGap(),
                  IconButton(
                    tooltip: "Download as Excel",
                    onPressed: () {
                      showSnackBar(context, kPrimaryColor, "To implement", 200);
                    },
                    icon: const Icon(Icons.download),
                  ),
                  const HorizontalGap(),
                  IconButton(
                    tooltip: "Download as PDF",
                    onPressed: () {
                      showSnackBar(context, kPrimaryColor, "To implement", 200);
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                  ),
                ],
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _tenantsAPI.get(tenantsUrl),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                !snapshot.hasError) {
              //TODO: Add pagination
              List<Tenant> tenants = snapshot.data!['tenants'];
              List<DataColumn> cols = [
                const DataColumn(
                  label: Text("ID"),
                ),
                const DataColumn(
                  label: Text("First Name"),
                ),
                const DataColumn(
                  label: Text("Last Name"),
                ),
                const DataColumn(
                  label: Text("Phone Number"),
                ),
                const DataColumn(
                  label: Text("Property"),
                ),
                const DataColumn(
                  label: Text("House Number"),
                )
              ];
              List<DataRow> items = [];
              for (var tenant in tenants) {
                items.add(
                  DataRow(
                    onSelectChanged: (val) {
                      if (val!) {
                        // set provider data
                        Provider.of<DestinationProvider>(context, listen: false)
                            .setData(tenant.id);
                        Provider.of<DestinationProvider>(context, listen: false)
                            .changeDestination(1);
                      }
                    },
                    cells: [
                      DataCell(
                        Text("${tenant.id}"),
                      ),
                      DataCell(
                        Text(tenant.firstName ?? ''),
                      ),
                      DataCell(
                        Text(tenant.lastName ?? ''),
                      ),
                      DataCell(
                        Text(tenant.phoneNumber ?? ''),
                      ),
                      const DataCell(
                        Text("Jamhuri Flats"),
                      ),
                      const DataCell(
                        Text("1234"),
                      )
                    ],
                  ),
                );
              }

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DataTable(
                      columns: cols,
                      rows: items,
                      showCheckboxColumn: false,
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CustomProgressIndicator(),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            );
          },
        )
      ],
    );
  }
}

class TenantsHome extends StatefulWidget {
  const TenantsHome({super.key});

  @override
  State<TenantsHome> createState() => _TenantsHomeState();
}

class _TenantsHomeState extends State<TenantsHome> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DestinationProvider(),
      builder: (context, child) {
        List<Widget> destinantions = [
          const TenantsMainView(),
          TenantDetails(
              tenantID: Provider.of<DestinationProvider>(context).data_)
        ];
        return destinantions[
            Provider.of<DestinationProvider>(context).destination];
      },
    );
  }
}
