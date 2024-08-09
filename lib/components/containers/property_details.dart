import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/photo.dart';
import '../../models/property.dart';
import '../../providers/destination_provider.dart';
import '../../sdk/photos.dart';
import '../../sdk/property.dart';
import '../common/gap.dart';
import '../common/progress_indicator.dart';
import '../image_slider.dart';

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
  final PhotosAPI _photosAPI = PhotosAPI();

  final List<String> _imagePaths = [];
  //List<XFile> _selectedPhotos = [];

  Future<void> _fetctImageUrls(List<dynamic> imageIds) async {
    for (var i in imageIds) {
      var uri = "$photosUrl$i/";
      try {
        var response = await _photosAPI.getItem(uri);
        if (response['status'] == 'success') {
          Photo photo = response['photo'];
          _imagePaths.add(photo.image ?? '');
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Property Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: "Edit Property Details",
                  ),
                  const HorizontalGap(),
                  IconButton(
                    onPressed: () {
                      Provider.of<DestinationProvider>(context, listen: false)
                          .setData(0);
                      Provider.of<DestinationProvider>(context, listen: false)
                          .changeDestination(1);
                    },
                    icon: const Icon(Icons.close),
                    tooltip: "Close",
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          FutureBuilder(
            future: _propertyAPI.getItem("$propertyUrl${widget.propertyId}/"),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError) {
                Property property = snapshot.data!['property'];

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: kPrimaryColor,
                            ),
                            Text(
                              "${property.address}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const Gap(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: _fetctImageUrls(property.photos ?? []),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    !snapshot.hasError) {
                                  if (_imagePaths.isNotEmpty) {
                                    return ImageSlider(
                                      imagePaths: _imagePaths,
                                    );
                                  }
                                }
                                return const SizedBox();
                              },
                            ),
                            const Gap(),
                            const Text(
                              "Extra info:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${property.description}"),
                            const Text("Houses in this property"),
                            FutureBuilder(
                              future: _housesAPI
                                  .get("$houseStatsUrl${property.id}/"),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text("An error occurred");
                                }
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  var houses = snapshot.data!['houses'];

                                  return Text("${houses.length}");
                                }
                                return const Center(
                                  child: CustomProgressIndicator(),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(
                child: CustomProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
