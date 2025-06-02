import 'package:app2/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text.dart';
import './models/product.dart';
import 'product_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  bool _isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUser') ?? '';
    setState(() {
      _userName = prefs.getString('name_$email') ?? 'User';
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      prefs.setBool('isDarkTheme', _isDarkTheme);
    });
    // Restart app to apply theme
    Navigator.pushReplacementNamed(context, '/splash');
  }

  @override
  Widget build(BuildContext context) {
    final products = Product.getProducts();
    final categories = ['Clothes', 'Shoes', 'Electronics'];

    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: 'Welcome, $_userName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ProductSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: CustomText(text: 'E-Commerce App', color: Colors.white),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              title: const CustomText(text: 'Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const CustomText(text: 'Cart'),
              onTap: () => Navigator.pushNamed(context, '/cart'),
            ),
            ListTile(
              title: const CustomText(text: 'Orders'),
              onTap: () => Navigator.pushNamed(context, '/orders'),
            ),
            ListTile(
              title: const CustomText(text: 'Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              title: const CustomText(text: 'Logout'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(height: 200, autoPlay: true),
              items: [
                'assets/promo1.jpg',
                'assets/promo2.jpg',
                'assets/promo3.jpg',
              ].map((image) => Image.asset(image, fit: BoxFit.cover)).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(text: 'Categories', fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      onTap: () {
                        Navigator.pushNamed(context, '/category', arguments: categories[index]);
                      },
                      width: 120,
                      height: 40,
                      color: Colors.black87,
                      radius: 8,
                      child: Center(child: CustomText(text: categories[index], color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomText(text: 'Featured Products', fontWeight: FontWeight.bold),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }
}