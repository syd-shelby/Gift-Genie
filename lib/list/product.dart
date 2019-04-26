class Product {
  final String id;
  final String category;
  final String imageURL;
  final String name;
  final String price;
  final String description;
  final String rating;
  final int type;

  const Product({
    this.id,
    this.category,
    this.imageURL,
    this.name,
    this.price,
    this.description,
    this.rating,
    this.type
  });

  Product.fromMap(Map<String, dynamic> data, String id)
      : this(
      id: id,
      category: data['Categories'],
      imageURL: data['Image Link'],
      name: data['Name'],
      price: data['Price'],
      description: data['Product Description'],
      rating: data['Rating'],
      type: 1
  );
}
