import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../sdk/tenants.dart';

class TenantSelector extends StatefulWidget {
  const TenantSelector({super.key, required Function callback});

  @override
  State<TenantSelector> createState() => _TenantSelectorState();
}

class _TenantSelectorState extends State<TenantSelector> {
  final TenantsAPI _tenantsAPI = TenantsAPI();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tenantsAPI.get(tenantsUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List tenants = snapshot.data!['tenants'];
          List<DropdownMenuItem> items = [];
          for (var t in tenants) {
            items.add(DropdownMenuItem(
              value: t.id,
              child: Text("${t.firstName} ${t.lastName}"),
            ));
          }

          return DropdownButtonFormField(
            icon: const Icon(Icons.person),
            items: items,
            onChanged: (val) {},
            hint: const Text("Tenant"),
          );
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}
