import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text.dart';
import 'custom_button.dart';
import './models/product.dart';
import './models/cart_item.dart';
// import './models/order.dart';
import 'snack.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = prefs.getStringList('cart') ?? [];
    final products = Product.getProducts();
    setState(() {
      _cartItems = cartItems.map((item) {
        final parts = item.split(':');
        final productId = int.parse(parts[0]);
        final quantity = int.parse(parts[1]);
        final product = products.firstWhere((p) => p.id == productId);
        return CartItem(product: product, quantity: quantity);
      }).toList();
    });
  }

  Future<void> _updateCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItems = _cartItems.map((item) => '${item.product.id}:${item.quantity}').toList();
    await prefs.setStringList('cart', cartItems);
  }

  Future<void> _placeOrder() async {
    if (_cartItems.isEmpty) {
      Snack().success(context, 'Cart is empty');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final orders = prefs.getStringList('orders') ?? [];
    final total = _cartItems.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    final order = '$orderId:${_cartItems.map((item) => '${item.product.id}:${item.quantity}').join(',')}:$total';
    orders.add(order);
    await prefs.setStringList('orders', orders);
    await prefs.setStringList('cart', []);
    setState(() => _cartItems = []);
    Snack().success(context, 'Order placed successfully');
  }

  @override
  Widget build(BuildContext context) {
    final total = _cartItems.fold(0.0, (sum, item) => sum + item.product.price * item.quantity);

    return Scaffold(
      appBar: AppBar(title: const CustomText(text: 'Cart')),
      body: _cartItems.isEmpty
          ? const Center(child: CustomText(text: 'Cart is empty'))
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  leading: Image.asset(item.product.image, width: 50, fit: BoxFit.cover),
                  title: CustomText(text: item.product.name),
                  subtitle: CustomText(text: '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (item.quantity > 1) {
                              item.quantity--;
                            } else {
                              _cartItems.removeAt(index);
                            }
                          });
                          _updateCart();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() => item.quantity++);
                          _updateCart();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() => _cartItems.removeAt(index));
                          _updateCart();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(text: 'Total: \$${total.toStringAsFixed(2)}',  fontWeight: FontWeight.bold),
            const SizedBox(height: 10),
            CustomButton(
              onTap: _placeOrder,
              width: double.infinity,
              height: 40,
              color: Colors.black87,
              radius: 8,
              child: const Center(
                child: CustomText(text: 'Place Order', color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}