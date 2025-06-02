import 'package:flutter/material.dart';
import 'custom_text.dart';
import './models/product.dart';

class CategoryProductsPage extends StatelessWidget {
  const CategoryProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)!.settings.arguments as String;
    final products = Product.getProducts().where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: category),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/product', arguments: product);
            },
            child: Card(
              child: Column(
                children: [
                  Image.asset(product.image, height: 100, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(text: product.name, fontWeight: FontWeight.bold),
                  ),
                  CustomText(text: '\$${product.price.toStringAsFixed(2)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}