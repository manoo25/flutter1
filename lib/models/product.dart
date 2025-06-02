class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
  });

  static List<Product> getProducts() {
    return [
      Product(id: 1, name: 'T-Shirt', category: 'Clothes', price: 19.99, description: 'Comfortable cotton t-shirt', image: 'assets/product1.jpg'),
      Product(id: 2, name: 'Jeans', category: 'Clothes', price: 49.99, description: 'Stylish blue jeans', image: 'assets/product2.jpg'),
      Product(id: 3, name: 'Sneakers', category: 'Shoes', price: 79.99, description: 'Trendy running shoes', image: 'assets/product3.jpg'),
      Product(id: 4, name: 'Sandals', category: 'Shoes', price: 29.99, description: 'Casual summer sandals', image: 'assets/product4.jpg'),
      Product(id: 5, name: 'Smartphone', category: 'Electronics', price: 599.99, description: 'Latest model smartphone', image: 'assets/product5.jpg'),
      Product(id: 6, name: 'Headphones', category: 'Electronics', price: 99.99, description: 'Wireless headphones', image: 'assets/product6.jpg'),
      Product(id: 7, name: 'Jacket', category: 'Clothes', price: 89.99, description: 'Warm winter jacket', image: 'assets/product7.jpg'),
      Product(id: 8, name: 'Watch', category: 'Electronics', price: 199.99, description: 'Smart watch', image: 'assets/product8.jpg'),
    ];
  }
}