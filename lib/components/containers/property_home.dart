import 'package:flutter/material.dart';
import 'package:rentoo_pms/sdk/property.dart';

import '../../constants.dart';

class PropertyHome extends StatefulWidget {
  const PropertyHome({super.key});

  @override
  State<PropertyHome> createState() => _PropertyHomeState();
}

class _PropertyHomeState extends State<PropertyHome> {
  final PropertyAPI _propertyAPI = PropertyAPI();
  // controller for the add property modal
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  // keys
  final _formKey = GlobalKey<FormState>();
  final Widget _gap = const SizedBox(height: 20);
  final bool _propertyExists = true;

  Widget addPropertyModal() {
    // name, address, description
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Name is required";
              }
              return null;
            },
            controller: _nameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.abc_outlined),
              labelText: "Property Name",
            ),
          ),
          _gap,
          DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return "Purpose is required";
              }
              return null;
            },
            items: purposes
                .map(
                  (e) => DropdownMenuItem(
                    value: e["value"],
                    child: Text(e["name"]),
                  ),
                )
                .toList(),
            onChanged: (value) {
              _purposeController.text = value.toString();
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.category),
              labelText: "Purpose",
            ),
          ),
          _gap,
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Address is required";
              }
              return null;
            },
            controller: _addressController,
            minLines: 2,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Where is it located?",
              icon: Icon(Icons.location_on),
            ),
          ),
          _gap,
          TextFormField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: "Some few details about the property",
              icon: Icon(Icons.description),
            ),
          ),
        ],
      ),
    );
  }

  List<int> selectedProperties = [];
  bool allSelected = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      // title, add button, and data table
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Properties",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Add Property"),
                            content: addPropertyModal(),
                            actions: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                                label: const Text("Close"),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    // show snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Property added"),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                        width: 200,
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.done),
                                label: const Text("Save"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    label: const Text("Add Property"),
                    icon: const Icon(Icons.add),
                  ),
                  // excel, pdf
                  const SizedBox(width: 10),
                  _propertyExists
                      ? IconButton(
                          tooltip: "Download as Excel",
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  _propertyExists
                      ? IconButton(
                          tooltip: "Download as PDF",
                          onPressed: () {},
                          icon: const Icon(Icons.picture_as_pdf),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            child: SingleChildScrollView(
                child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Row(
                    children: [
                      Icon(Icons.dangerous),
                      SizedBox(
                        width: 5,
                      ),
                      Text("An error occurred")
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  var props = snapshot.data!['property'];

                  return DataTable(
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Address")),
                    ],
                    rows: [
                      for (var property in props)
                        DataRow(
                          cells: [
                            DataCell(TextButton(
                              child: Text(property.name ?? ''),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Attach action here"),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.green,
                                    width: 220,
                                    action: SnackBarAction(
                                      label: "Close",
                                      onPressed: () =>
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars(),
                                    ),
                                  ),
                                );
                              },
                            )),
                            DataCell(Text(property.address ?? '')),
                          ],
                        ),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasData) {
                  return Row(
                    children: [
                      const Icon(Icons.dangerous),
                      const SizedBox(
                        width: 5,
                      ),
                      const Text("No property found"),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton.icon(
                        label: const Text("Add property"),
                        icon: const Icon(Icons.add),
                        onPressed: () {},
                      )
                    ],
                  );
                }
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
              future: _propertyAPI.get(propertyUrl),
            )),
          ),
        ),
      ],
    );
  }
}
