class CareTaker {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? photo;
  String? website;
  int? property;

  CareTaker({
    this.createdAt,
    this.email,
    this.firstName,
    this.id,
    this.lastName,
    this.phoneNumber,
    this.photo,
    this.property,
    this.updatedAt,
    this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      "created_at": createdAt,
      "updated_at": updatedAt,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "photo": photo,
      "property": property,
      "website": website,
      "id": id,
      "phone_number": phoneNumber
    };
  }

  CareTaker.fromJson(Map<String, dynamic> json) {
    createdAt = DateTime.parse(json['created_at']);
    updatedAt = DateTime.parse(json['updated_at']);
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    photo = json['photo'];
    property = json['property'];
    website = json['website'];
    id = json['id'];
    phoneNumber = json['phone_number'];
  }
}
