class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'price': price,
    'description': description,
    'category': category,
    'image': image,
    'rating': rating.toJson(),
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    description: json['description'],
    category: json['category'],
    image: json['image'],
    rating: Rating.fromJson(json['rating']),
  );
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};

  factory Rating.fromJson(Map<String, dynamic> json) =>
      Rating(rate: (json['rate'] as num).toDouble(), count: json['count']);
}
