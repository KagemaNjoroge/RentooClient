import 'package:flutter/material.dart';

import '../common/gap.dart';

class HouseDetails extends StatefulWidget {
  int houseId;
  HouseDetails({super.key, required this.houseId});

  @override
  State<HouseDetails> createState() => _HouseDetailsState();
}

class _HouseDetailsState extends State<HouseDetails> {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("House Details"),
          const Gap(),
          Row(
            children: [
              ElevatedButton.icon(
                label: const Text("Close"),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const HorizontalGap(),
              ElevatedButton.icon(
                label: const Text("Save"),
                icon: const Icon(Icons.done),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
