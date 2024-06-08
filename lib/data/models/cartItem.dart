class CartItem {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final int productId; // product id

  CartItem({
    required this.productId,
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({
    int? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    int? productId,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
    );
  }
}
