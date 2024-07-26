import 'package:flutter/material.dart';
import 'package:rentoo_pms/components/common/gap.dart';
import 'package:rentoo_pms/components/image_slider.dart';
import 'package:rentoo_pms/constants.dart';
import 'package:rentoo_pms/models/photo.dart';
import 'package:rentoo_pms/models/property.dart';
import 'package:rentoo_pms/sdk/property.dart';

class PropertyDetailsBottomSheet extends StatefulWidget {
  int propertyId;
  PropertyDetailsBottomSheet({super.key, required this.propertyId});

  @override
  State<PropertyDetailsBottomSheet> createState() =>
      _PropertyDetailsBottomSheetState();
}

class _PropertyDetailsBottomSheetState
    extends State<PropertyDetailsBottomSheet> {
  final PropertyAPI _propertyAPI = PropertyAPI();
  final HousesAPI _housesAPI = HousesAPI();

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
      child: FutureBuilder(
        future: _propertyAPI.getItem("$propertyUrl${widget.propertyId}/"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasError) {
            Property property = snapshot.data!['property'];
            List<String> imagePaths = [];
            List<Photo> photos = [];

            for (var ph in property.photos ?? []) {
              photos.add(Photo.fromJson(ph));
            }

            for (var p in photos) {
              imagePaths.add(p.image ?? '');
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${property.name}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Text("This property is located at:"),
                Text(
                  "${property.address}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Gap(),
                    imagePaths.isNotEmpty
                        ? ImageSlider(imagePaths: imagePaths)
                        : const SizedBox(),
                    const Gap(),
                    const Text("Extra info:"),
                    Text("${property.description}"),
                    const Text("Houses in this property"),
                    FutureBuilder(
                      future: _housesAPI.get("$houseStatsUrl${property.id}/"),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text("An error occurred");
                        }
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          var houses = snapshot.data!['houses'];

                          return Text("${houses.length}");
                        }
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      },
                    )
                  ],
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
