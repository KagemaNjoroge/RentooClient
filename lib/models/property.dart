class Property {
  int? id;
  String? name;
  String? address;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? photos;
  String? purpose;

  Property({
    this.id,
    this.name,
    this.address,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.photos,
    this.purpose,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    photos = json['photos'];
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "description": description,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "photos": photos,
      "purpose": purpose,
    };
  }
}
