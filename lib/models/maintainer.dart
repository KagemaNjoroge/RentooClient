class Maintainer {
  int? id;
  String? maintainerType;
  String? name;
  String? description;
  DateTime? dateAdded;
  DateTime? dateModified;
  String? logo;

  Maintainer({
    this.dateAdded,
    this.dateModified,
    this.description,
    this.id,
    this.logo,
    this.maintainerType,
    this.name,
  });

  Maintainer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    name = json['name'];
    maintainerType = json['maintainer_type'];
    dateAdded = DateTime.parse(json['date_added']);
    dateModified = DateTime.parse(json['date_modified']);
    description = json['description'];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "logo": logo,
      "name": name,
      "maintainer_type": maintainerType,
      "date_added": dateAdded.toString(),
      "date_modified": dateModified.toString(),
      "description": description
    };
  }
}
