class Tenant {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? photo;
  String? website;
  List<dynamic>? houses;
  // default type is individual
  String? type = "Individual";

  Tenant({
    this.createdAt,
    this.email,
    this.firstName,
    this.houses,
    this.id,
    this.lastName,
    this.phoneNumber,
    this.photo,
    this.updatedAt,
    this.website,
    this.type,
  });
  Tenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houses = json['houses'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    photo = json['photo'];
    website = json['website'];
    phoneNumber = json['phone_number'];
    type = json['tenant_type'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "houses": houses,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "photo": photo,
      "website": website,
      "phone_number": phoneNumber,
      "tenant_type": type,
    };
  }
}
