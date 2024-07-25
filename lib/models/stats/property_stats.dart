class PropertyStats {
  int propertyCount;
  int houseCount;
  int vacantHouses;
  int occupiedHouses;

  PropertyStats({
    required this.propertyCount,
    required this.houseCount,
    required this.vacantHouses,
    required this.occupiedHouses,
  });
  PropertyStats.fromJson(Map<String, dynamic> json)
      : propertyCount = json['property_count'],
        houseCount = json['house_count'],
        vacantHouses = json['vacant_houses'],
        occupiedHouses = json['occupied_houses'];
  Map<String, dynamic> toJson() => {
        'propertyCount': propertyCount,
        'houseCount': houseCount,
        'vacantHouses': vacantHouses,
        'occupiedHouses': occupiedHouses,
      };
}
