class Agent {
  int? id;
  String? name;
  String? photo;
  String? phoneNumber;
  String? email;
  String? website;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? properties;

  Agent({
    this.id,
    this.name,
    this.photo,
    this.phoneNumber,
    this.email,
    this.website,
    this.createdAt,
    this.updatedAt,
    this.properties,
  });

  Agent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    website = json['website'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    properties = json['properties'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "photo": photo,
      "phone_number": phoneNumber,
      "email": email,
      "website": website,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "properties": properties
    };
  }
}
