import 'package:flutter/material.dart';
import 'package:rentoo_pms/components/containers/property_details.dart';

import '../../constants.dart';
import '../../models/property.dart';
import '../../sdk/property.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';

class AddPropertyBottomSheet extends StatefulWidget {
  const AddPropertyBottomSheet({super.key});

  @override
  State<AddPropertyBottomSheet> createState() => _AddPropertyBottomSheetState();
}

class _AddPropertyBottomSheetState extends State<AddPropertyBottomSheet> {
  final PropertyAPI _propertyAPI = PropertyAPI();
  // controller for the add property modal
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  // keys
  final _formKey = GlobalKey<FormState>();

  // state
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
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
            const Gap(),
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
            const Gap(),
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
            const Gap(),
            TextFormField(
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Some few details about the property",
                icon: Icon(Icons.description),
              ),
            ),
            const Gap(),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                ),
                TextButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Property property = Property(
                        name: _nameController.text,
                        address: _addressController.text,
                        description: _descriptionController.text,
                        purpose: _purposeController.text,
                      );
                      try {
                        setState(() {
                          _isLoading = true;
                        });

                        var response = await _propertyAPI.post(propertyUrl,
                            body: property.toJson());
                        if (response['status'] == 'success') {
                          showSnackBar(context, Colors.green,
                              "Property added successfully", 300);
                          Navigator.pop(context);
                        } else {
                          showSnackBar(
                              context, Colors.red, "An error occurred", 300);
                        }
                      } catch (e) {
                        showSnackBar(context, Colors.red, e.toString(), 600);
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  icon: const Icon(Icons.done),
                  label: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text("Save"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PropertyHome extends StatefulWidget {
  const PropertyHome({super.key});

  @override
  State<PropertyHome> createState() => _PropertyHomeState();
}

class _PropertyHomeState extends State<PropertyHome> {
  final PropertyAPI _propertyAPI = PropertyAPI();

  final bool _propertyExists = true;

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
                      showBottomSheet(
                        context: context,
                        builder: (context) {
                          return const AddPropertyBottomSheet();
                        },
                      );
                    },
                    label: const Text("Add Property"),
                    icon: const Icon(Icons.add),
                  ),
                  const HorizontalGap(),
                  _propertyExists
                      ? IconButton(
                          tooltip: "Download as Excel",
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                        )
                      : const SizedBox(),
                  const HorizontalGap(),
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
                        DataColumn(
                          label: Text("Name"),
                        ),
                        DataColumn(
                          label: Text("Address"),
                        ),
                      ],
                      rows: [
                        for (var property in props)
                          DataRow(
                            cells: [
                              DataCell(
                                TextButton(
                                  child: Text(property.name ?? ''),
                                  onPressed: () {
                                    showBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return PropertyDetailsBottomSheet(
                                            propertyId: property.id);
                                      },
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                Text(property.address ?? ''),
                              ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
