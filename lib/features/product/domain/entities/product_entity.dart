class ProductEntity {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String category;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.category,
  });
}
