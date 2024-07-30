class House {
  int? id;
  String? purpose;
  String? houseNumber;
  int? numberOfRooms;
  int? numberOfBedrooms;
  bool? isOccupied;
  double? rent;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? description;
  int? property;
  List<dynamic>? photos;

  House({
    this.id,
    this.purpose,
    this.houseNumber,
    this.numberOfRooms,
    this.numberOfBedrooms,
    this.isOccupied,
    this.rent,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.property,
    this.photos,
  });
  House.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    purpose = json["purpose"];
    houseNumber = json['house_number'];
    numberOfRooms = json['number_of_rooms'];
    numberOfBedrooms = json['number_of_bedrooms'];
    isOccupied = json['is_occupied'];
    rent = double.parse(json['rent']);
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    description = json['description'];
    property = json['property'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "purpose": purpose,
      "house_number": houseNumber,
      "number_of_rooms": numberOfRooms,
      "number_of_bedrooms": numberOfBedrooms,
      "is_occupied": isOccupied,
      "rent": rent,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "description": description,
      "property": property,
      "photos": photos
    };
  }
}
