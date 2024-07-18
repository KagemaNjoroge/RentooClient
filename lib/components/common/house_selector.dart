import 'package:flutter/material.dart';

import '../../utils/property.dart';

class HouseSelector extends StatefulWidget {
  const HouseSelector({super.key});

  @override
  State<HouseSelector> createState() => _HouseSelectorState();
}

class _HouseSelectorState extends State<HouseSelector> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchHouses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          List houses = snapshot.data!['houses'];
          List<DropdownMenuItem> items = [];
          for (var t in houses) {
            items.add(DropdownMenuItem(
              value: t.id,
              child: Text("${t.houseNumber}"),
            ));
          }

          return DropdownButtonFormField(
            icon: const Icon(Icons.bungalow),
            items: items,
            onChanged: (val) {},
            hint: const Text("House"),
          );
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }
}
