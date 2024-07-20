import 'package:flutter/material.dart';

import '../../models/company.dart';
import '../../utils/company.dart';

class CompanyHome extends StatefulWidget {
  const CompanyHome({super.key});

  @override
  State<CompanyHome> createState() => _CompanyHomeState();
}

class _CompanyHomeState extends State<CompanyHome> {
  // controllers and keys
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCompany(),
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
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Configure company"),
                )
              ],
            ));
          } else {
            Company comp = snapshot.data!['companies'][0];

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
