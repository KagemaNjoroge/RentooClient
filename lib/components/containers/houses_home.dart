import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/house.dart';
import '../../sdk/property.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import 'house_details.dart';

class AddHouseBottomSheet extends StatefulWidget {
  const AddHouseBottomSheet({super.key});

  @override
  State<AddHouseBottomSheet> createState() => _AddHouseBottomSheetState();
}

class _AddHouseBottomSheetState extends State<AddHouseBottomSheet> {
  final PropertyAPI _propertyAPI = PropertyAPI();
  final HousesAPI _housesAPI = HousesAPI();
  // controller for the add house modal house number, property, rent, purpose, description,
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // keys
  final _formKey = GlobalKey<FormState>();
  // state
  bool _isLoading = false;
  int _property = 0;
  @override
  Widget build(BuildContext context) {
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
              child: Column(
                children: [
                  const Text("At which property is the house located in?*"),
                  FutureBuilder(
                    future: _propertyAPI.get(propertyUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        List property = snapshot.data!['property'];
                        List<DropdownMenuItem> items = [];
                        for (var t in property) {
                          items.add(DropdownMenuItem(
                            value: t.id,
                            child: Text("${t.name}"),
                          ));
                        }

                        return DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return "You must select a property";
                            }
                            return null;
                          },
                          icon: const Icon(Icons.apartment),
                          items: items,
                          onChanged: (val) {
                            _property = val as int;
                          },
                          hint: const Text("Property"),
                        );
                      }

                      return const CircularProgressIndicator.adaptive();
                    },
                  )
                ],
              ),
            ),
            const Gap(),
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
            const Gap(),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // save house
                      House house = House(
                        houseNumber: _houseNumberController.text,
                        description: _descriptionController.text,
                        property: _property,
                        rent: double.parse(_rentController.text),
                        purpose: _purposeController.text,
                        isOccupied: false,
                        photos: [],
                        numberOfBedrooms: 1,
                        numberOfRooms: 1,
                      );
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        var response = await _housesAPI.post(housesUrl,
                            body: house.toJson());
                        if (response['status'] == 'success') {
                          showSnackBar(context, Colors.green,
                              "House saved successfully", 300);
                          Navigator.pop(context);
                          setState(() {
                            _houseNumberController.clear();
                            _rentController.clear();
                            _descriptionController.clear();
                            _purposeController.clear();
                            _property = 0;
                          });
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
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator.adaptive(),
                        )
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

class HousesHome extends StatefulWidget {
  const HousesHome({super.key});

  @override
  State<HousesHome> createState() => _HousesHomeState();
}

class _HousesHomeState extends State<HousesHome> {
  final HousesAPI _housesAPI = HousesAPI();

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
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showBottomSheet(
                        context: context,
                        builder: (context) => const AddHouseBottomSheet(),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add House"),
                  ),
                  const HorizontalGap(),
                  IconButton(
                    tooltip: "Download as Excel",
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                  ),
                  const HorizontalGap(),
                  IconButton(
                    tooltip: "Download as PDF",
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                  )
                ],
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
                                Icon(
                                  Icons.warning,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "No houses found",
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
                                  builder: (context) =>
                                      const AddHouseBottomSheet(),
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
                                  DataCell(
                                    TextButton(
                                      child: Text(e.houseNumber.toString()),
                                      onPressed: () {
                                        showBottomSheet(
                                            context: context,
                                            builder: (_) {
                                              return HouseDetails(
                                                  houseId: e.id);
                                            });
                                      },
                                    ),
                                  ),
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
