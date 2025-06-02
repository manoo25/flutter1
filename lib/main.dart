import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'category_products_page.dart';
import 'product_details_page.dart';
import 'cart_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing app...');
  final prefs = await SharedPreferences.getInstance();
  final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  print('Dark theme: $isDarkTheme');
  runApp(MyApp(isDarkTheme: isDarkTheme));
}

class MyApp extends StatelessWidget {
  final bool isDarkTheme;
  const MyApp({super.key, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    print('Building MaterialApp');
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) {
          print('Navigating to SplashPage');
          return const SplashPage();
        },
        '/login': (context) {
          print('Navigating to LoginPage');
          return const LoginPage();
        },
        '/signup': (context) {
          print('Navigating to SignUpPage');
          return const SignUpPage();
        },
        '/home': (context) {
          print('Navigating to HomePage');
          return const HomePage();
        },
        '/category': (context) {
          print('Navigating to CategoryProductsPage');
          return const CategoryProductsPage();
        },
        '/product': (context) {
          print('Navigating to ProductDetailsPage');
          return const ProductDetailsPage();
        },
        '/cart': (context) {
          print('Navigating to CartPage');
          return const CartPage();
        },
        '/orders': (context) {
          print('Navigating to OrdersPage');
          return const OrdersPage();
        },
        '/profile': (context) {
          print('Navigating to ProfilePage');
          return const ProfilePage();
        },
      },
      onUnknownRoute: (settings) {
        print('Unknown route: ${settings.name}');
        return MaterialPageRoute(builder: (context) => const Scaffold(body: Center(child: Text('Route not found'))));
      },
    );
  }
}