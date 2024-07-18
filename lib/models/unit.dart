class Unit {
  /// Represents a housing unit - a unit can be used to
  /// group several houses together
  int? id;
  String? unitName;
  String? floor;
  int? property;
  List<dynamic>? houses;

  Unit({
    this.id,
    this.unitName,
    this.floor,
    this.property,
    this.houses,
  });

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['unit_name'];
    floor = json['floor'];
    property = json['property'];
    houses = json['houses'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "unit_name": unitName,
      "floor": floor,
      "property": property,
      "houses": houses,
    };
  }
}
