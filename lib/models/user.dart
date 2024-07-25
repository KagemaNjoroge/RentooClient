class User {
  int? id;
  DateTime? lastLogin;
  bool? isSuperUser;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isStaff;
  bool? isActive;
  DateTime? dateJoined;
  String? phoneNumber;
  String? profilePicture;
  String? website;
  String? bio;
  String? location;
  DateTime? birthDate = DateTime.now();
  String? idNumber;
  String? kraPin;

  User({
    this.bio,
    this.birthDate,
    this.dateJoined,
    this.email,
    this.firstName,
    this.id,
    this.idNumber,
    this.isActive,
    this.isStaff,
    this.isSuperUser,
    this.kraPin,
    this.lastLogin,
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
      "last_login": lastLogin,
      "is_superuser": isSuperUser,
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "is_staff": isStaff,
      "is_active": isActive,
      "date_joined": dateJoined,
      "phone_number": phoneNumber,
      "profile_picture": profilePicture,
      "website": website,
      "bio": bio,
      "location": location,
      "birth_date": birthDate,
      "id_number": idNumber,
      "kra_pin": kraPin
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLogin = DateTime.parse(json['last_login']);
    isSuperUser = json['is_superuser'];
    username = json['username'] ?? '';
    firstName = json['first_name'] ?? '';
    lastName = json['last_name'] ?? '';
    email = json['email'] ?? '';
    isStaff = json['is_staff'];
    isActive = json['is_active'];
    dateJoined = DateTime.parse(json['date_joined']);
    phoneNumber = json['phone_number'] ?? '';
    profilePicture = json['profile_picture'] ?? '';
    website = json['website'] ?? '';
    bio = json['bio'] ?? '';
    location = json['location'] ?? '';
    birthDate = DateTime.tryParse(json['birth_date']) ?? DateTime.now();
    idNumber = json['id_number'] ?? '';
    kraPin = json['kra_pin'] ?? '';
  }
}
