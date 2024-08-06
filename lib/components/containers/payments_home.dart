import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../models/lease.dart';
import '../../models/payment.dart';
import '../../models/payment_method.dart';
import '../../sdk/leases.dart';
import '../../sdk/payment.dart';
import '../../sdk/payment_method.dart';
import '../../utils/dates_parser.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';

class PaymentsHome extends StatefulWidget {
  const PaymentsHome({super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
  final PaymentAPI _paymentAPI = PaymentAPI();

  Widget _parsePaymentStatus(String status) {
    var wid = const Icon(Icons.device_unknown);
    switch (status) {
      case "Complete":
        wid = const Icon(
          Icons.verified,
          color: Colors.blue,
        );
      case "Pending":
        wid = const Icon(Icons.pending);
      case "Cancelled":
        wid = const Icon(
          Icons.cancel_outlined,
          color: Colors.red,
        );
      case "In progress":
        wid = const Icon(Icons.more_horiz);

        break;
      default:
        wid = const Icon(Icons.device_unknown);
    }
    return wid;
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
                "Payments",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add payment"),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const AddPaymentBottomSheet();
                      });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: _paymentAPI.get(paymentsUrl),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError) {
                List<Payment> payments = snapshot.data!['payments'];
                if (payments.isEmpty) {
                  return const Center(
                    child: Text("No payments found"),
                  );
                } else {
                  List<DataRow> items = [];
                  for (var payment in payments) {
                    items.add(
                      DataRow(cells: [
                        DataCell(
                          Text("${payment.id ?? '_'}"),
                        ),
                        DataCell(
                          Text("${payment.lease ?? '_'}"),
                        ),
                        DataCell(
                          Text(
                            parseDate(payment.paymentDate ?? DateTime.now()),
                          ),
                        ),
                        DataCell(
                          Text("${payment.amount ?? '_'}"),
                        ),
                        DataCell(
                            _parsePaymentStatus(payment.paymentStatus ?? ''))
                      ]),
                    );
                  }
                  List<DataColumn> cols = [
                    const DataColumn(
                      label: Text("ID"),
                    ),
                    const DataColumn(
                      label: Text("Lease"),
                    ),
                    const DataColumn(
                      label: Text("Paid on"),
                    ),
                    const DataColumn(
                      label: Text("Amount"),
                    ),
                    const DataColumn(label: Text("Status"))
                  ];
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DataTable(columns: cols, rows: items),
                      ],
                    ),
                  );
                }
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

class AddPaymentBottomSheet extends StatefulWidget {
  const AddPaymentBottomSheet({super.key});

  @override
  State<AddPaymentBottomSheet> createState() => _AddPaymentBottomSheetState();
}

class _AddPaymentBottomSheetState extends State<AddPaymentBottomSheet> {
  final LeasesAPI _leasesAPI = LeasesAPI();
  final PaymentMethodAPI _paymentMethodAPI = PaymentMethodAPI();
  final PaymentAPI _paymentAPI = PaymentAPI();
  var lease = 0;
  String _method = "";
  String _paymentStatus = '';
  // controllers & keys
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // payment status dropdown items
    List<DropdownMenuItem> statusItems = [];
    for (var i in paymentStatuses) {
      statusItems.add(
        DropdownMenuItem(
          value: i['name'],
          child: Text(i['name']),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add payment",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Gap(),
            // lease selector
            Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: _leasesAPI.get(leasesUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        if (snapshot.data!['status'] == "success") {
                          List<Lease> leases = snapshot.data!['leases'];
                          List<DropdownMenuItem> leaseItems = [];
                          for (var lease in leases) {
                            leaseItems.add(
                              DropdownMenuItem(
                                value: lease.id,
                                child: Text("${lease.id}"),
                              ),
                            );
                          }
                          return DropdownButtonFormField(
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "You have to select a lease";
                              }
                              return null;
                            },
                            icon: const Icon(Icons.arrow_downward),
                            items: leaseItems,
                            onChanged: (value) {
                              lease = value as int;
                            },
                            decoration: const InputDecoration(
                              labelText: "Lease",
                              hintText: "Select lease",
                            ),
                          );
                        }
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                  const Gap(),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      try {
                        double.parse(val!);
                      } catch (e) {
                        return e.toString();
                      }
                      if (val.isEmpty) {
                        return "Amount is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      hintText: "Enter amount",
                    ),
                  ),
                  const Gap(),
                  FutureBuilder(
                      future: _paymentMethodAPI.get(paymentMethodsUrl),
                      builder: (_, snapshot) {
                        if (snapshot.hasError) {
                          return Column(
                            children: [
                              const Text("An error occurred"),
                              Text(snapshot.error.toString())
                            ],
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData &&
                            !snapshot.hasError) {
                          List<PaymentMethod> methods =
                              snapshot.data!['payment_methods'];
                          List<DropdownMenuItem> items = [];
                          for (var method in methods) {
                            items.add(
                              DropdownMenuItem(
                                value: method.name,
                                child: Text(method.name ?? ''),
                              ),
                            );
                          }
                          return DropdownButtonFormField(
                              decoration: const InputDecoration(
                                  hintText: "Payment Method"),
                              items: items,
                              onChanged: (val) {
                                _method = val as String;
                              });
                        }
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }),
                  const Gap(),
                  DropdownButtonFormField(
                      decoration:
                          const InputDecoration(hintText: "Payment Status"),
                      items: statusItems,
                      onChanged: (val) {
                        _paymentStatus = val as String;
                      })
                ],
              ),
            ),
            const Gap(),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("Cancel"),
                  icon: const Icon(Icons.close),
                ),
                const HorizontalGap(),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_key.currentState!.validate()) {
                      Payment payment = Payment(
                        paymentMethod: _method,
                        lease: lease,
                        paymentDate: DateTime.now(),
                        amount: double.parse(_amountController.text),
                        paymentStatus: _paymentStatus,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        notes: '',
                        referenceCode: '',
                      );

                      var response = await _paymentAPI.post(paymentsUrl,
                          body: payment.toJson());

                      if (response['status'] == 'success') {
                        Navigator.pop(context);
                        showSnackBar(context, Colors.green,
                            "Payment added successfully", 300);
                      } else {
                        showSnackBar(context, Colors.red,
                            "An error occurred. Please try again.", 400);
                      }
                    }
                  },
                  label: const Text("Add"),
                  icon: const Icon(Icons.done),
                )
              ],
            ),
            const Gap()
          ],
        ),
      ),
    );
  }
}
