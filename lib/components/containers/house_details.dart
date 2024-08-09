import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/house.dart';
import '../../models/photo.dart';
import '../../models/temporary_file.dart';
import '../../providers/destination_provider.dart';
import '../../sdk/photos.dart';
import '../../sdk/property.dart';
import '../../sdk/temporary_file.dart';
import '../../utils/snack.dart';
import '../common/gap.dart';
import '../common/progress_indicator.dart';
import '../image_slider.dart';

class HouseDetails extends StatefulWidget {
  int houseId;
  HouseDetails({super.key, required this.houseId});

  @override
  State<HouseDetails> createState() => _HouseDetailsState();
}

class _HouseDetailsState extends State<HouseDetails> {
  House _house = House();

  final HousesAPI _housesAPI = HousesAPI();
  final PhotosAPI _photosAPI = PhotosAPI();

  final List<String> _imagePaths = [];

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("House Details"),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showBottomSheet(
                          context: context,
                          builder: (_) {
                            return EditHouseDetailsBottomSheet(house: _house);
                          });
                    },
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: "Edit House Details",
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
              )
            ],
          ),
          const Divider(),
          const Gap(),
          Expanded(
            child: FutureBuilder(
              future: _housesAPI.getItem("$housesUrl${widget.houseId}/"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    !snapshot.hasError &&
                    snapshot.hasData) {
                  House house = snapshot.data!['house'];
                  _house = house;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "House Number: ",
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(house.houseNumber ?? '_'),
                          ],
                        ),
                        const Gap(),
                        FutureBuilder(
                          future: _fetctImageUrls(house.photos ?? []),
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
                        Text("${house.description}")
                      ],
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return const Center(
                  child: CustomProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditHouseDetailsBottomSheet extends StatefulWidget {
  House house;
  EditHouseDetailsBottomSheet({super.key, required this.house});

  @override
  State<EditHouseDetailsBottomSheet> createState() =>
      _EditHouseDetailsBottomSheetState();
}

class _EditHouseDetailsBottomSheetState
    extends State<EditHouseDetailsBottomSheet> {
  String _purpose = "";

  // controllers & keys
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _logoController = TextEditingController();
  var _photos = [];
  var _property = 0;
  bool _isOccupied = false;
  int _numberOfRooms = 0;
  int _numberOfBedrooms = 0;
  final TemporaryFileAPI _temporaryFileAPI = TemporaryFileAPI();
  //final TemporaryFile _temporaryFile = TemporaryFile();

  XFile? _image;

  Future<void> selectImage() async {
    const XTypeGroup typeGroup =
        XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
    final List<XFile> files = await openFiles(acceptedTypeGroups: [typeGroup]);
    if (files.isNotEmpty) {
      _logoController.text = files.first.path;
      _image = files.first;
    }
  }

  final List<String> _selectedImagePaths = [
    "http://localhost:8000/media/house_photos/user_avatar.png",
    "http://localhost:8000/media/house_photos/user_avatar.png",
    "http://localhost:8000/media/house_photos/user_avatar.png",
    "http://localhost:8000/media/house_photos/user_avatar.png",
    "http://localhost:8000/media/house_photos/user_avatar.png"
  ];

  @override
  void initState() {
    var house = widget.house;
    _rentController.text = house.rent.toString();
    _houseNumberController.text = house.houseNumber.toString();
    _descriptionController.text = house.description.toString();
    _purpose = house.purpose ?? '';
    _photos = house.photos ?? [];
    _property = house.property ?? 0;
    _isOccupied = house.isOccupied ?? false;
    _numberOfBedrooms = house.numberOfBedrooms ?? 0;
    _numberOfRooms = house.numberOfRooms ?? 0;

    super.initState();
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Edit House Details"),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
                tooltip: "Close",
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "House Number is required";
                          }
                          return null;
                        },
                        controller: _houseNumberController,
                        decoration:
                            const InputDecoration(hintText: "House Number*"),
                      ),
                      const Gap(),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Rent is required";
                          }
                          return null;
                        },
                        controller: _rentController,
                        decoration: const InputDecoration(hintText: "Rent*"),
                      ),
                      const Gap(),
                      TextFormField(
                        controller: _descriptionController,
                        decoration:
                            const InputDecoration(hintText: "Extra info"),
                      ),
                      const Gap(),
                      ElevatedButton.icon(
                        onPressed: () {
                          House house = widget.house;
                          if (_key.currentState!.validate()) {
                            var url = "$housesUrl${house.id}/";
                            if (_descriptionController.text.isEmpty) {
                              _descriptionController.text =
                                  house.description ?? '';
                            }
                            House updatedHouse = House(
                              description: _descriptionController.text,
                              houseNumber: _houseNumberController.text,
                              purpose: _purpose,
                              rent: double.parse(_rentController.text),
                              photos: _photos,
                              property: _property,
                              isOccupied: _isOccupied,
                              numberOfBedrooms: _numberOfBedrooms,
                              numberOfRooms: _numberOfRooms,
                            );
                            print("URL: $url");
                            print("Updated House: ${updatedHouse.toJson()}");
                          }
                        },
                        icon: const Icon(Icons.done),
                        label: const Text("Save"),
                      )
                    ],
                  ),
                ),
              ),
              const HorizontalGap(),
              // image selection
              Expanded(
                child: Column(
                  children: [
                    ImageSlider(imagePaths: _selectedImagePaths),
                    const Gap(),
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "http://localhost:8000/media/house_photos/user_avatar.png"),
                        ),
                        const HorizontalGap(),
                        ElevatedButton.icon(
                          label: const Text("Select Image"),
                          onPressed: () async {
                            try {
                              await selectImage();
                              // upload temporary file -> add the image path to _selectedImages list
                              if (_image != null) {
                                var response = await _temporaryFileAPI
                                    .uploadFile(tempUrl, _image!, "file");
                                if (response['status'] == "success") {
                                  TemporaryFile file = response['file'];
                                  setState(() {
                                    _selectedImagePaths.add(file.url!);
                                  });
                                } else {
                                  showSnackBar(context, Colors.red,
                                      "An error occurred", 300);
                                }
                              }
                            } catch (e) {
                              //pass
                              showSnackBar(context, Colors.red,
                                  "An error occurred: $e", 500);
                            }
                          },
                          icon: const Icon(Icons.add_photo_alternate_rounded),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
