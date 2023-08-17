class Product {
  final int id;
  final String title, description;
  final List<String> images;
  final double rating, price;

  Product({
    required this.id,
    required this.images,
    this.rating = 0.0,
    required this.title,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      images: (json['images'] as List<dynamic>)
          .map<String>((e) => e.toString())
          .toList(),
      title: json['title'],
      price: json['price'],
      description: json['description'],
      rating: json['rating'],
    );
  }
}
