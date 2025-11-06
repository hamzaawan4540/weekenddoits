class Activity {
  final String id;
  final String title;
  final String imageUrl;
  final String duration;
  final String description;
  final int price;

  const Activity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() => {
        "title": title,
        "imageUrl": imageUrl,
        "duration": duration,
        "description": description,
        "price": price,
      };

  factory Activity.fromMap(String id, Map<String, dynamic> map) => Activity(
        id: id,
        title: map["title"] ?? "",
        imageUrl: map["imageUrl"] ?? "",
        duration: map["duration"] ?? "",
        description: map["description"] ?? "",
        price: (map["price"] ?? 0) is int
            ? map["price"]
            : int.tryParse(map["price"].toString()) ?? 0,
      );
}
