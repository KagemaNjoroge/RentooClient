class Company {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? website;
  String? logo;
  String? language;
  String? currency;

  Company({
    this.email,
    this.id,
    this.logo,
    this.name,
    this.phone,
    this.website,
    this.language,
    this.currency,
  });

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    logo = json['logo'];
    phone = json['phone'];
    website = json['website'];
    language = json['language'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "logo": logo,
      "phone": phone,
      "website": website,
      "language": language,
      "currency": currency,
    };
  }
}
