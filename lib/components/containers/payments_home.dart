import 'package:flutter/material.dart';
import 'package:rentoo_pms/models/payment.dart';
import 'package:rentoo_pms/sdk/payment.dart';

import '../../constants.dart';
import '../../sdk/leases.dart';

class PaymentsHome extends StatefulWidget {
  const PaymentsHome({super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

var lease = 0;

class _PaymentsHomeState extends State<PaymentsHome> {
  final LeasesAPI _leasesAPI = LeasesAPI();
  final PaymentAPI _paymentAPI = PaymentAPI();
  Widget addPaymentModal() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Add payment",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          // lease selector
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _leasesAPI.get(leasesUrl),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    if (snapshot.data!['status'] == "success") {
                      var leases = snapshot.data!['leases'];
                      List<DropdownMenuItem> leaseItems = [];
                      for (var lease in leases) {
                        leaseItems.add(DropdownMenuItem(
                          value: lease.id,
                          child: Text(lease.id.toString()),
                        ));
                      }
                      return DropdownButtonFormField(
                        icon: const Icon(Icons.arrow_downward),
                        items: leaseItems,
                        onChanged: (value) {
                          setState(() {
                            lease = value as int;
                          });
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Amount",
                  hintText: "Enter amount",
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("Cancel"),
                  icon: const Icon(Icons.close),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("Add"),
                  icon: const Icon(Icons.done),
                )
              ],
            ),
          )
        ],
      ),
    );
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
                        return addPaymentModal();
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
                  List<Widget> paymentTiles = [];
                  for (var u in payments) {
                    paymentTiles.add(ListTile(
                      title: Text("${u.id}"),
                      subtitle: Text("${u.createdAt}"),
                    ));
                  }
                  return Column(
                    children: paymentTiles,
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
