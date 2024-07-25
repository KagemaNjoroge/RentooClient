class User {
  int? id;
  bool? isSuperUser;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isStaff;
  bool? isActive;
  String? phoneNumber;
  String? profilePicture;
  String? website;
  String? bio;
  String? location;
  String? idNumber;
  String? kraPin;

  User({
    this.bio,
    this.email,
    this.firstName,
    this.id,
    this.idNumber,
    this.isActive,
    this.isStaff,
    this.isSuperUser,
    this.kraPin,
    this.lastName,
    this.location,
    this.phoneNumber,
    this.profilePicture,
    this.username,
    this.website,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "is_superuser": isSuperUser,
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "is_staff": isStaff,
      "is_active": isActive,
      "phone_number": phoneNumber,
      "profile_picture": profilePicture,
      "website": website,
      "bio": bio,
      "location": location,
      "id_number": idNumber,
      "kra_pin": kraPin
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isSuperUser = json['is_superuser'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    phoneNumber = json['phone_number'];
    profilePicture = json['profile_picture'];
    website = json['website'];
    bio = json['bio'];
    location = json['location'];
    idNumber = json['id_number'];
    kraPin = json['kra_pin'];
  }
}
