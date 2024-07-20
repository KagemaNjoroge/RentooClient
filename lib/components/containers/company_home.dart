import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/company.dart';
import '../../sdk/company.dart';
import '../../utils/snack.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  final CompanyAPI _companyAPI = CompanyAPI();

  bool _loading = false;

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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Company name is required";
              }
              return null;
            },
            controller: _nameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.business),
              labelText: "Company name*",
              hintText: "Enter company name",
            ),
          ),
          _gap,
          TextFormField(
            controller: _phoneController,
            validator: (value) => value!.length < 10
                ? "Phone number must be at least 10 characters"
                : null,
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: "Phone number*",
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
      future: _companyAPI.get(companyUrl),
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
                                setState(() {
                                  _loading = true;
                                });
                                Company company = Company(
                                  name: _nameController.text,
                                  phone: _phoneController.text,
                                  email: _emailController.text,
                                  website: _websiteController.text,
                                );
                                var resp = await _companyAPI.post(
                                  companyUrl,
                                  body: company.toJson(),
                                );
                                if (resp['status'] == "success") {
                                  showSnackBar(context, Colors.green,
                                      "Company created successfully", 300);
                                  Navigator.pop(context);
                                } else {
                                  showSnackBar(context, Colors.red,
                                      "Failed to create company", 300);
                                }
                              }
                            },
                            label: const Text("Save"),
                            icon: _loading
                                ? const CircularProgressIndicator.adaptive()
                                : const Icon(Icons.save),
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
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // logo will be here
                Container(
                  margin: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        comp.phone ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        }

        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
            ),
            Text("An error occurred"),
          ],
        );
      },
    );
  }
}
