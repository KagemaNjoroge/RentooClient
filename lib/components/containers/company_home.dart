import 'package:flutter/material.dart';
import 'package:rentoo_pms/sdk/company.dart';

import '../../constants.dart';
import '../../models/company.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  // controllers and keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _enabled = false;

  // controllers & keys
  final GlobalKey<FormState> _addformKey = GlobalKey();
  // name, phone, email, website
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final Widget _gap = const SizedBox(height: 10);
  Widget _addCompanyDetailsModal() {
    return Form(
      key: _addformKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.business),
              labelText: "Company name",
              hintText: "Enter company name",
            ),
          ),
          _gap,
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: "Phone number",
              hintText: "Enter phone number",
            ),
          ),
          _gap,
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.email),
              labelText: "Email",
              hintText: "Enter email",
            ),
          ),
          _gap,
          TextFormField(
            controller: _websiteController,
            decoration: const InputDecoration(
              icon: Icon(Icons.web),
              labelText: "Website",
              hintText: "Enter website",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CompanyAPI().get(companyUrl),
      initialData: const {
        "id": 0,
        "name": "",
        "logo": "",
        "email": "",
        "phone": "",
        "website": ""
      },
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          if (snapshot.data!['companies'].isEmpty) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Company details not found"),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Add company details"),
                        content: _addCompanyDetailsModal(),
                        actions: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            label: const Text("Cancel"),
                            icon: const Icon(Icons.close),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              if (_addformKey.currentState!.validate()) {
                                // TODO: Add company
                              }
                            },
                            label: const Text("Save"),
                            icon: const Icon(Icons.done),
                          )
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Configure company"),
                )
              ],
            ));
          } else {
            Company comp = snapshot.data!['companies'].first;

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comp.name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _enabled = true;
                              });
                            },
                            label: const Text("Edit"),
                            icon: const Icon(Icons.edit),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          _enabled
                              ? ElevatedButton.icon(
                                  onPressed: () {},
                                  label: const Text("Save"),
                                  icon: const Icon(Icons.done),
                                )
                              : const SizedBox()
                        ],
                      )
                    ],
                  ),
                ),
                Card(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: comp.name,
                          enabled: _enabled,
                          decoration: const InputDecoration(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        }
        if (snapshot.hasError) {
          return const Text("An error occurred");
        }

        return const Text("An unknown error occurred");
      },
    );
  }
}
