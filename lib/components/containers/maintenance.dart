import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/maintenance.dart';
import '../../sdk/maintenance_request.dart';
import '../../sdk/property.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import 'dashboard.dart';

class MaintenanceHome extends StatefulWidget {
  const MaintenanceHome({super.key});

  @override
  State<MaintenanceHome> createState() => _MaintenanceHomeState();
}

class _MaintenanceHomeState extends State<MaintenanceHome> {
  final MaintenanceRequestAPI _maintenanceRequestAPI = MaintenanceRequestAPI();
  final HousesAPI _housesAPI = HousesAPI();
  // state
  bool _isLoading = false;
  int _houseId = 0;
  // controllers and keys
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Maintenance",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    label: const Text("New maintenance request"),
                    onPressed: () {
                      showBottomSheet(
                          context: context,
                          builder: (_) {
                            return _newRequestSheet();
                          });
                    },
                    icon: const Icon(Icons.add),
                  ),
                  const HorizontalGap(),
                  ElevatedButton.icon(
                    label: const Text("Maintainers"),
                    onPressed: () {},
                    icon: const Icon(Icons.people_alt_outlined),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _maintenanceRequestAPI.get(maintenanceRequestsUrl),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  !snapshot.hasError) {
                List<Maintenance> maintenances =
                    snapshot.data!['maintenance'] ?? [];
                if (maintenances.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Gap(),
                                const Text(
                                  "No maintenance requests found. Maintenance requests are made by tenants who have issues in their residences. You can also create one for them.",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showBottomSheet(
                                        context: context,
                                        builder: (_) {
                                          return _newRequestSheet();
                                        });
                                  },
                                  label: const Text("New maintenance request"),
                                  icon: const Icon(Icons.add),
                                ),
                                const Gap()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  List<DataRow> items = [];
                  int pending = 0;
                  int inprogress = 0;
                  int complete = 0;
                  int scheduled = 0;
                  for (var x in maintenances) {
                    if (x.status.toString() == "Complete") {
                      complete++;
                    }
                    if (x.status.toString() == "In Progress") {
                      inprogress++;
                    }
                    if (x.status.toString() == "Pending") {
                      pending++;
                    }
                    if (x.status.toString() == "Scheduled") {
                      scheduled++;
                    }

                    items.add(DataRow(cells: [
                      DataCell(Text("${x.id}")),
                      DataCell(Text("${x.house}")),
                      DataCell(Text("${x.description}")),
                      DataCell(Text("${x.requestDate}")),
                      DataCell(Text("${x.isCompleted}"))
                    ]));
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PropertyCard(
                            title: "Requests",
                            count: items.length,
                            color: kPrimaryColor,
                            icon: Icons.summarize_outlined,
                          ),
                          const HorizontalGap(),
                          PropertyCard(
                            title: "Pending",
                            count: pending,
                            color: Colors.red,
                            icon: Icons.dangerous_outlined,
                          ),
                          const HorizontalGap(),
                          PropertyCard(
                            title: "Complete",
                            count: complete,
                            color: Colors.green,
                            icon: Icons.done,
                          ),
                          const HorizontalGap(),
                          PropertyCard(
                            title: "In progress",
                            count: inprogress,
                            color: Colors.orange,
                            icon: Icons.directions_walk_outlined,
                          ),
                          const HorizontalGap(),
                          PropertyCard(
                            title: "Scheduled",
                            count: scheduled,
                            color: Colors.purpleAccent,
                            icon: Icons.date_range,
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // search
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Maintenance Requests",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Search",
                                          icon: Icon(Icons.search),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Gap(),
                              DataTable(columns: const [
                                DataColumn(label: Text("Id")),
                                DataColumn(label: Text("House")),
                                DataColumn(label: Text("Issue")),
                                DataColumn(label: Text("Date Requested")),
                                DataColumn(label: Text("Is completed"))
                              ], rows: items),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        )
      ],
    );
  }

  Widget _newRequestSheet() {
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
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              const Text("New Maintenance Request"),
              const Gap(),
              FutureBuilder(
                future: _housesAPI.get(housesUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List houses = snapshot.data!['houses'];
                    List<DropdownMenuItem> items = [];
                    for (var t in houses) {
                      items.add(
                        DropdownMenuItem(
                          value: t.id,
                          child: Text("${t.houseNumber}"),
                        ),
                      );
                    }

                    return DropdownButtonFormField(
                      decoration: const InputDecoration(hintText: "House*"),
                      validator: (value) {
                        if (value == null) {
                          return "Please select a house";
                        }
                        return null;
                      },
                      icon: const Icon(Icons.bungalow),
                      items: items,
                      onChanged: (val) {
                        _houseId = val as int;
                      },
                      hint: const Text("House"),
                    );
                  }

                  return const CircularProgressIndicator.adaptive();
                },
              ),
              const Gap(),
              DropdownButtonFormField(
                validator: (value) {
                  if (value == null) {
                    return "Purpose is required";
                  }
                  return null;
                },
                items: maintenanceRequestStatuses
                    .map(
                      (e) => DropdownMenuItem(
                        value: e["value"],
                        child: Text(e["name"]),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  _statusController.text = value.toString();
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.category),
                  labelText: "Status",
                ),
              ),
              const Gap(),
              TextFormField(
                minLines: 3,
                maxLines: 5,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description of the problem that needs fixing*",
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: const Text("Close"),
                    icon: const Icon(Icons.close),
                  ),
                  const HorizontalGap(),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        Maintenance maintenance = Maintenance(
                          description: _descriptionController.text,
                          house: _houseId,
                          isCompleted: false,
                          status: _statusController.text,
                        );
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          var response = await _maintenanceRequestAPI.post(
                              maintenanceRequestsUrl,
                              body: maintenance.toJson());
                          if (response['status'] == "success") {
                            showSnackBar(context, Colors.green,
                                "Maintenance request added!", 250);
                            Navigator.pop(context);
                            setState(() {
                              _descriptionController.clear();
                              _statusController.clear();
                              _houseId = 0;
                              _isLoading = false;
                            });
                          }
                        } catch (e) {
                          showSnackBar(context, Colors.red, e.toString(), 400);
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                    label: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : const Text("Add"),
                    icon: const Icon(Icons.done),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
