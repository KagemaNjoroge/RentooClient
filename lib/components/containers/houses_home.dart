import 'package:flutter/material.dart';
import 'package:rentoo_pms/components/common/gap.dart';

import '../../constants.dart';
import '../../sdk/property.dart';
import '../common/property_selector.dart';

class HousesHome extends StatefulWidget {
  const HousesHome({super.key});

  @override
  State<HousesHome> createState() => _HousesHomeState();
}

class _HousesHomeState extends State<HousesHome> {
  final HousesAPI _housesAPI = HousesAPI();
  // controller for the add house modal house number, property, rent, purpose, description,
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // keys
  final _formKey = GlobalKey<FormState>();

  final Widget _gap = const SizedBox(height: 20);
  Widget addHouseModal() {
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
            Container(
              padding: const EdgeInsets.all(8),
              child: const Column(
                children: [
                  Text("At which property is the house located in?*"),
                  PropertySelector(),
                ],
              ),
            ),
            _gap,
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "House number is required";
                }
                return null;
              },
              controller: _houseNumberController,
              decoration: const InputDecoration(
                icon: Icon(Icons.home),
                labelText: "House Number*",
              ),
            ),
            _gap,
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Rent is required";
                }
                return null;
              },
              controller: _rentController,
              decoration: const InputDecoration(
                icon: Icon(Icons.money),
                labelText: "Rent*",
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
              controller: _descriptionController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                icon: Icon(Icons.description),
                labelText: "Description",
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
                  label: const Text("Cancel"),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // save house
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("House saved"),
                          behavior: SnackBarBehavior.floating,
                          width: 200,
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.done),
                  label: const Text("Save"),
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
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // title,add
              const Text(
                "Houses",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showBottomSheet(
                    context: context,
                    builder: (context) => addHouseModal(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Add House"),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            width: double.infinity,
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: _housesAPI.get(housesUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List houses = snapshot.data!['houses'];
                    if (houses.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.warning, color: Colors.red),
                                SizedBox(width: 10),
                                Text(
                                  "No houses found",
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) => addHouseModal(),
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Add House"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return DataTable(
                        showCheckboxColumn: true,
                        onSelectAll: (value) {},
                        columns: const [
                          DataColumn(label: Text("House Number")),
                          DataColumn(label: Text("Property")),
                          DataColumn(label: Text("Rent")),
                          DataColumn(label: Text("Purpose")),
                        ],
                        rows: houses
                            .map(
                              (e) => DataRow(
                                onSelectChanged: (value) {},
                                cells: [
                                  DataCell(Text(e.houseNumber.toString())),
                                  DataCell(Text(e.property.toString())),
                                  DataCell(Text(e.rent.toString())),
                                  DataCell(Text(e.purpose.toString())),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
