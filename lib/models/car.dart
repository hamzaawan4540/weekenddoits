class Car {
  final String id; // firestore doc id (optional when creating)
  final String name;
  final String imageUrl;
  final double pricePerDay;
  final List<String>? locations; // optional for filtering

  const Car({
    this.id = '',
    required this.name,
    required this.imageUrl,
    required this.pricePerDay,
    this.locations,
  });

  factory Car.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return Car(
      id: id,
      name: (map['name'] ?? '') as String,
      imageUrl: (map['imageUrl'] ?? '') as String,
      pricePerDay: (map['pricePerDay'] as num?)?.toDouble() ?? 0.0,
      locations: (map['locations'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'imageUrl': imageUrl,
        'pricePerDay': pricePerDay,
        if (locations != null) 'locations': locations,
      };
}
