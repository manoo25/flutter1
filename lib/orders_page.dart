import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text.dart';
import './models/product.dart';
import './models/cart_item.dart';
import './models/order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final orders = prefs.getStringList('orders') ?? [];
    final products = Product.getProducts();
    setState(() {
      _orders = orders.map((order) {
        final parts = order.split(':');
        final id = parts[0];
        final total = double.parse(parts[2]);
        final items = parts[1].split(',').map((item) {
          final itemParts = item.split(':');
          final productId = int.parse(itemParts[0]);
          final quantity = int.parse(itemParts[1]);
          final product = products.firstWhere((p) => p.id == productId);
          return CartItem(product: product, quantity: quantity);
        }).toList();
        return Order(id: id, items: items, total: total, date: DateTime.fromMillisecondsSinceEpoch(int.parse(id)));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(text: 'Orders')),
      body: _orders.isEmpty
          ? const Center(child: CustomText(text: 'No orders yet'))
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return ExpansionTile(
                  title: CustomText(text: 'Order #${order.id}'),
                  subtitle: CustomText(
                    text: 'Date: ${order.date.day}/${order.date.month}/${order.date.year} | Total: \$${order.total.toStringAsFixed(2)}',
                  ),
                  children: order.items.map((item) {
                    return ListTile(
                      leading: Image.asset(item.product.image, width: 50, fit: BoxFit.cover),
                      title: CustomText(text: item.product.name),
                      subtitle: CustomText(text: '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}'),
                    );
                  }).toList(),
                );
              },
            ),
    );
  }
}