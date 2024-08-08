import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/house.dart';
import '../../models/lease.dart';
import '../../sdk/leases.dart';
import '../../sdk/property.dart';
import '../../sdk/tenants.dart';
import '../../utils/dates_parser.dart';
import '../../utils/snack.dart';
import '../common/buttons/export_csv_button.dart';
import '../common/buttons/export_pdf_button.dart';
import '../common/gap.dart';

class AddLeasesBottomSheet extends StatefulWidget {
  const AddLeasesBottomSheet({super.key});

  @override
  State<AddLeasesBottomSheet> createState() => _AddLeasesBottomSheetState();
}

class _AddLeasesBottomSheetState extends State<AddLeasesBottomSheet> {
  final LeasesAPI _leasesAPI = LeasesAPI();
  final HousesAPI _housesAPI = HousesAPI();
  final TenantsAPI _tenantsAPI = TenantsAPI();
  bool _renewMonthly = true;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final List _tenants = [];
  int _houseId = 0;
  int _tenantId = 0;
  // keys
  final GlobalKey<FormState> _formKey = GlobalKey();
  // controllers
  final TextEditingController _startDateController = TextEditingController();

  // state
  bool _isLoading = false;
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
            TextFormField(
              controller: _startDateController,
              onTap: () async {
                var start = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050));

                if (start != null) {
                  _startDate = start.start.toLocal();
                  _endDate = start.start.toLocal();
                  _startDateController.text = "From: $_startDate to: $_endDate";
                }
              },
              decoration: const InputDecoration(
                labelText: "Start Date",
              ),
            ),
            const Gap(),
            const Gap(),
            FutureBuilder(
              future: _tenantsAPI.get(tenantsUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List tenants = snapshot.data!['tenants'];
                  List<DropdownMenuItem> items = [];
                  for (var t in tenants) {
                    _tenants.add(t);
                    items.add(
                      DropdownMenuItem(
                        value: t.id,
                        child: Text("${t.firstName} ${t.lastName}"),
                      ),
                    );
                  }

                  return DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return "Please select a tenant";
                      }
                      return null;
                    },
                    icon: const Icon(Icons.person),
                    items: items,
                    onChanged: (val) {
                      _tenantId = val as int;
                    },
                    hint: const Text("Tenant"),
                  );
                }

                return const CircularProgressIndicator.adaptive();
              },
            ),
            const Gap(),
            FutureBuilder(
              future: _housesAPI.get(housesUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  List<House> houses = snapshot.data!['houses'];
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
            CheckboxListTile.adaptive(
                title: const Text("Renew montly"),
                value: _renewMonthly,
                onChanged: (val) {
                  setState(() {
                    _renewMonthly = val!;
                  });
                }),
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
                      Lease lease = Lease(
                        tenant: _tenantId,
                        house: _houseId,
                        startDate: DateTime.now(),
                        endDate: DateTime.now(),
                        renewMonthly: _renewMonthly,
                        depositAmount: 0,
                        isActive: true,
                      );

                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        var response = await _leasesAPI.post(leasesUrl,
                            body: lease.toJson());

                        if (response['status'] == 'success') {
                          showSnackBar(context, Colors.green,
                              "Lease created successfully", 300);
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
                  label: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Text("Save"),
                  icon: const Icon(Icons.done),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class LeasesHome extends StatefulWidget {
  const LeasesHome({super.key});

  @override
  State<LeasesHome> createState() => _LeasesHomeState();
}

class _LeasesHomeState extends State<LeasesHome> {
  final LeasesAPI _leasesAPI = LeasesAPI();

  Widget _parseStatus(bool status) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Leases",
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
                        builder: (context) => const AddLeasesBottomSheet(),
                      );
                    },
                    label: const Text("Add Lease"),
                    icon: const Icon(Icons.add),
                  ),
                  const HorizontalGap(),
                  ExportCsvButton(),
                  const HorizontalGap(),
                  ExportPdfButton(
                    callBack: () {
                      showSnackBar(
                          context, kPrimaryColor, "Export as PDF", 200);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _leasesAPI.get(leasesUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  !snapshot.hasError) {
                List<Lease> leases = snapshot.data!['leases'];
                List<DataRow> items = [];
                for (var lease in leases) {
                  items.add(
                    DataRow(
                      cells: [
                        DataCell(
                          Text("${lease.house}"),
                        ),
                        DataCell(
                          Text(parseDate(lease.startDate ?? DateTime.now())),
                        ),
                        DataCell(
                          Text(parseDate(lease.endDate ?? DateTime.now())),
                        ),
                        const DataCell(Text("2,000")),
                        DataCell(_parseStatus(lease.isActive ?? false)),
                        DataCell(_parseStatus(lease.isPaidCompletely ?? false)),
                        DataCell(_parseStatus(lease.renewMonthly ?? false))
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: SizedBox()),
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
                      DataTable(columns: const [
                        DataColumn(
                          label: Text("House"),
                        ),
                        DataColumn(
                          label: Text("Starts"),
                        ),
                        DataColumn(
                          label: Text("Ends"),
                        ),
                        DataColumn(label: Text("Rent")),
                        DataColumn(
                          label: Text("Is Active"),
                        ),
                        DataColumn(
                          label: Text("Is Paid Completely"),
                        ),
                        DataColumn(
                          label: Text("Renew Monthly"),
                        ),
                      ], rows: items),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          ),
        )
      ],
    );
  }
}
