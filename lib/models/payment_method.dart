class PaymentMethod {
  int? id;
  String? name;
  String? logo;
  String? description;

  PaymentMethod({
    this.description,
    this.id,
    this.logo,
    this.name,
  });
  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    description = json['description'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "logo": logo,
      "description": description,
      "name": name,
    };
  }
}
