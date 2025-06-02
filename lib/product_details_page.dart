import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text.dart';
import 'custom_button.dart';
import './models/product.dart';
// import './models/cart_item.dart';
import 'snack.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int _quantity = 1;

  Future<void> _addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getStringList('cart') ?? [];
    final newItem = '${product.id}:$_quantity';
    cartItems.add(newItem);
    await prefs.setStringList('cart', cartItems);
    Snack().success(context, '${product.name} added to cart');
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(product.image, height: 200, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 16),
            CustomText(text: product.name, fontWeight: FontWeight.bold),
            const SizedBox(height: 8),
            CustomText(text: product.description),
            const SizedBox(height: 8),
            CustomText(text: '\$${product.price.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            Row(
              children: [
                CustomText(text: 'Quantity:'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                CustomText(text: '$_quantity'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              onTap: () => _addToCart(product),
              width: double.infinity,
              height: 40,
              color: Colors.black87,
              radius: 8,
              child: const Center(
                child: CustomText(text: 'Add to Cart', color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}