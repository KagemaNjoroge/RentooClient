import 'package:flutter/material.dart';

import '../common/tenant_selector.dart';

class PaymentsHome extends StatefulWidget {
  const PaymentsHome({super.key});

  @override
  State<PaymentsHome> createState() => _PaymentsHomeState();
}

class _PaymentsHomeState extends State<PaymentsHome> {
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
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text("Payment settings"),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add payment"),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
        TenantSelector(
          callback: () {},
        )
      ],
    );
  }
}
