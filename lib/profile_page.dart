import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text.dart';
import 'custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _address = '';
  String _dob = '';
  String _gender = '';
  String _avatarPath = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUser') ?? '';
    setState(() {
      _fullName = prefs.getString('name_$email') ?? '';
      _email = email;
      _phone = prefs.getString('phone_$email') ?? '';
      _address = prefs.getString('address_$email') ?? '';
      _dob = prefs.getString('dob_$email') ?? '';
      _gender = prefs.getString('gender_$email') ?? '';
      _avatarPath = prefs.getString('avatar_$email') ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const CustomText(text: 'Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: _avatarPath.isNotEmpty ? FileImage(File(_avatarPath)) : null,
              child: _avatarPath.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 16),
            CustomText(text: 'Full Name: $_fullName'),
            const SizedBox(height: 8),
            CustomText(text: 'Email: $_email'),
            const SizedBox(height: 8),
            CustomText(text: 'Phone: $_phone'),
            const SizedBox(height: 8),
            CustomText(text: 'Address: $_address'),
            const SizedBox(height: 8),
            CustomText(
              text: 'Date of Birth: ${_dob.isNotEmpty ? DateTime.parse(_dob).toLocal().toString().split(' ')[0] : ''}',
             
            ),
            const SizedBox(height: 8),
            CustomText(text: 'Gender: $_gender'),
            const SizedBox(height: 20),
            CustomButton(
              onTap: _logout,
              width: double.infinity,
              height: 40,
              color: Colors.black87,
              radius: 8,
              child: const Center(
                child: CustomText(text: 'Logout', color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}