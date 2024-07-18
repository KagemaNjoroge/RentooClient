class Property {
  int? id;
  String? name;
  String? address;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? photos;

  Property({
    this.id,
    this.name,
    this.address,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.photos,
  });

  Property.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    description = json['description'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "address": address,
      "description": description,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "photos": photos
    };
  }
}
