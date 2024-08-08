import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/maintainer.dart';
import '../../models/maintenance_request.dart';
import '../../providers/destination_provider.dart';
import '../../sdk/maintainer.dart';
import '../../sdk/maintenance_request.dart';
import '../../sdk/property.dart';
import '../../utils/dates_parser.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import 'dashboard.dart';

class MaintenanceHome extends StatefulWidget {
  const MaintenanceHome({super.key});

  @override
  State<MaintenanceHome> createState() => _MaintenanceHomeState();
}

class _MaintenanceHomeState extends State<MaintenanceHome> {
  final List<Widget> _destinations = [
    const MaintenancesView(),
    const MaintainersHome()
  ];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DestinationProvider(),
      builder: (context, child) {
        return _destinations[
            Provider.of<DestinationProvider>(context).destination];
      },
    );
  }
}

class MaintainersHome extends StatefulWidget {
  const MaintainersHome({super.key});

  @override
  State<MaintainersHome> createState() => _MaintainersHomeState();
}

class _MaintainersHomeState extends State<MaintainersHome> {
  final MaintainerAPI _maintainerAPI = MaintainerAPI();
  // controllers & keys
  final TextEditingController _nameController = TextEditingController();
  String _selectedMaintainerType = "Individual";
  final GlobalKey<FormState> _key = GlobalKey();

  //final List<XFile> _selectedLogos = [];

  Widget _addMaintainerBottomSheet() {
    List<DropdownMenuItem> items = [];
    for (var x in maintainerTypes) {
      items.add(DropdownMenuItem(
        value: x['value'],
        child: Text("${x['name']}"),
      ));
    }
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
        key: _key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add maintainer",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "Maitainers name is required";
                }
                return null;
              },
              controller: _nameController,
              decoration: const InputDecoration(
                  hintText: "Name*", icon: Icon(Icons.person_2_outlined)),
            ),
            const Gap(),
            DropdownButtonFormField(
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return "Required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Maintainer type*",
                  icon: Icon(Icons.type_specimen),
                ),
                items: items,
                onChanged: (val) {
                  _selectedMaintainerType = val as String;
                }),
            const Gap(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                ),
                const HorizontalGap(),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      Maintainer maintainer = Maintainer(
                          name: _nameController.text,
                          maintainerType: _selectedMaintainerType);
                      try {
                        var response = await _maintainerAPI.post(maintainersUrl,
                            body: maintainer.toJson());
                        if (response['status'] == "success") {
                          Navigator.pop(context);
                          setState(() {});
                          showSnackBar(
                              context, kPrimaryColor, "Maintainer added!", 200);
                        } else {
                          showSnackBar(
                              context, Colors.red, "An error occurred", 200);
                        }
                      } catch (e) {
                        showSnackBar(context, Colors.red, e.toString(), 400);
                      }
                    }
                  },
                  label: const Text("Save"),
                  icon: const Icon(Icons.done),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _parseMaintainerType(String type) {
    if (type == "Individual") {
      return const Icon(Icons.person);
    }
    return const Icon(Icons.business_center);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Provider.of<DestinationProvider>(context, listen: false)
                            .changeDestination(0);
                      },
                      child: const Icon(Icons.arrow_back)),
                  const HorizontalGap(),
                  const Text(
                    "Maintainers",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showBottomSheet(
                          context: context,
                          builder: (_) {
                            return _addMaintainerBottomSheet();
                          });
                    },
                    label: const Text("Add maintainer"),
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
              )
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: _maintainerAPI.get(maintainersUrl),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("An error occurred");
                }
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasError) {
                  if (snapshot.data!['status'] == "success") {
                    List<Maintainer> maintainers =
                        snapshot.data!['maintainers'];
                    if (maintainers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("No maintainers found"),
                            const Gap(),
                            ElevatedButton.icon(
                              onPressed: () {
                                showBottomSheet(
                                    context: context,
                                    builder: (_) {
                                      return _addMaintainerBottomSheet();
                                    });
                              },
                              label: const Text("Add maintainer"),
                              icon: const Icon(Icons.person_add_alt_1_outlined),
                            )
                          ],
                        ),
                      );
                    } else {
                      List<DataRow> items = [];
                      for (var x in maintainers) {
                        items.add(
                          DataRow(
                            cells: [
                              DataCell(
                                Text("${x.id}"),
                              ),
                              DataCell(
                                Text("${x.name}"),
                              ),
                              DataCell(
                                _parseMaintainerType(
                                    x.maintainerType ?? "Individual"),
                              )
                            ],
                          ),
                        );
                      }

                      return DataTable(columns: const [
                        DataColumn(
                          label: Text("ID"),
                        ),
                        DataColumn(
                          label: Text("Name"),
                        ),
                        DataColumn(label: Text("Type"))
                      ], rows: items);
                    }
                  } else {
                    return const Text("An error occurred");
                  }
                }

                return const CircularProgressIndicator.adaptive();
              },
            ),
          )
        ],
      ),
    );
  }
}

class MaintenancesView extends StatefulWidget {
  const MaintenancesView({super.key});

  @override
  State<MaintenancesView> createState() => _MaintenancesViewState();
}

class _MaintenancesViewState extends State<MaintenancesView> {
  final MaintenanceRequestAPI _maintenanceRequestAPI = MaintenanceRequestAPI();
  final HousesAPI _housesAPI = HousesAPI();
  // state
  bool _isLoading = false;
  int _houseId = 0;
  // controllers and keys
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();

  List<int> selectedIds = [];

  Widget _parseCompletionStatus(bool status) {
    if (status) {
      return const Icon(
        Icons.verified,
        color: Colors.blue,
      );
    } else {
      return const Icon(
        Icons.dangerous_outlined,
        color: Colors.red,
      );
    }
  }

  Widget _maitenanceTapped(MaintenanceRequest maintenance) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Maintenance details",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              maintenance.isCompleted ?? false
                  ? const SizedBox()
                  : Row(
                      children: [
                        ElevatedButton.icon(
                          label: const Text("Mark as completed"),
                          icon: const Icon(Icons.done),
                          onPressed: () async {
                            var url =
                                "$maintenanceRequestsUrl${maintenance.id}/";
                            try {
                              var response = await _maintenanceRequestAPI
                                  .patch(url, body: {
                                "is_completed": true,
                                "status": "Complete"
                              });
                              if (response['status'] == "success") {
                                Navigator.pop(context);
                                showSnackBar(context, kPrimaryColor,
                                    "Marked as completed", 200);
                                setState(() {});
                              } else {
                                showSnackBar(context, Colors.red,
                                    "An error occurred", 200);
                              }
                            } catch (e) {
                              showSnackBar(
                                  context, Colors.red, e.toString(), 400);
                            }
                          },
                        ),
                        const HorizontalGap(),
                        ElevatedButton.icon(
                          onPressed: () {},
                          label: const Text("Assign to a maintainer"),
                          icon: const Icon(Icons.person_2_outlined),
                        )
                      ],
                    )
            ],
          ),
          const Divider(),
          const Text("Issue"),
          TextFormField(
            initialValue: maintenance.description,
            enabled: false,
            minLines: 3,
            maxLines: 5,
          ),
          const Gap(),
          Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                size: 30,
              ),
              const HorizontalGap(),
              Text(parseDate(maintenance.requestDate ?? DateTime.now())),
              const HorizontalGap(),
              const HorizontalGap(),
              const Icon(Icons.person_outline_rounded),
              const HorizontalGap(),
              const Text("Tenant name"),
              const HorizontalGap(),
              const HorizontalGap(),
              const Text("Status"),
              const HorizontalGap(),
              _parseCompletionStatus(maintenance.isCompleted ?? false)
            ],
          ),
          const Gap(),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            label: const Text("Close"),
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }

  bool _checkIfSelected(int id) {
    for (var x in selectedIds) {
      if (x == id) {
        return true;
      }
    }
    return false;
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
                        MaintenanceRequest maintenance = MaintenanceRequest(
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
                    onPressed: () {
                      Provider.of<DestinationProvider>(context, listen: false)
                          .changeDestination(1);
                    },
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
                List<MaintenanceRequest> maintenances =
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

                    items.add(
                      DataRow(
                        selected: _checkIfSelected(x.id!),
                        onSelectChanged: (val) {
                          if (val!) {
                            setState(() {
                              selectedIds.add(x.id!);
                            });
                            showBottomSheet(
                              context: context,
                              builder: (context) {
                                return _maitenanceTapped(x);
                              },
                            );
                          } else {
                            setState(() {
                              selectedIds.remove(x.id);
                            });
                          }
                        },
                        cells: [
                          DataCell(
                            Text("${x.id}"),
                          ),
                          DataCell(
                            Text("${x.house}"),
                          ),
                          DataCell(
                            Text("${x.description}"),
                          ),
                          DataCell(
                            Text(
                              parseDate(x.requestDate ?? DateTime.now()),
                            ),
                          ),
                          DataCell(
                            _parseCompletionStatus(x.isCompleted ?? false),
                          )
                        ],
                      ),
                    );
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
}
