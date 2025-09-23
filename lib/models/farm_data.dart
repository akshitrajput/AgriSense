class FarmData {
  final String name;
  final String? cropTypeKey;
  final double farmLength;
  final double farmBreadth;
  final int rows;
  final int plantsPerRow;

  // No 'id' parameter in the constructor
  FarmData({
    this.name = '',
    this.cropTypeKey,
    this.farmLength = 0.0,
    this.farmBreadth = 0.0,
    this.rows = 0,
    this.plantsPerRow = 0,
  });

  factory FarmData.fromMap(Map<String, dynamic> map) {
    return FarmData(
      name: map['name'] ?? '',
      cropTypeKey: map['cropTypeKey'],
      farmLength: map['farmLength'] ?? 0.0,
      farmBreadth: map['farmBreadth'] ?? 0.0,
      rows: map['rows'] ?? 0,
      plantsPerRow: map['plantsPerRow'] ?? 0,
    );
  }

  // Helper method to convert back to a map, useful for saving
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cropTypeKey': cropTypeKey,
      'farmLength': farmLength,
      'farmBreadth': farmBreadth,
      'rows': rows,
      'plantsPerRow': plantsPerRow,
    };
  }
}