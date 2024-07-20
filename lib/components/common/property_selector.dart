import 'package:flutter/material.dart';
import 'package:rentoo_pms/constants.dart';

import '../../sdk/property.dart';


class PropertySelector extends StatefulWidget {
  const PropertySelector({super.key});

  @override
  State<PropertySelector> createState() => _PropertySelectorState();
}

class _PropertySelectorState extends State<PropertySelector> {
    final PropertyAPI _propertyAPI = PropertyAPI();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
            icon: const Icon(Icons.apartment),
            items: items,
            onChanged: (val) {},
            hint: const Text("Property"),
          );
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}
