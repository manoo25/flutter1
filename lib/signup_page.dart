import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';
import 'custom_text.dart';
import 'snack.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _gender;
  XFile? _avatarImage;

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _avatarImage = pickedFile);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  Future<void> _register() async {
    try {
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      final address = _addressController.text.trim();

      if (fullName.isEmpty) throw Exception('Full name is required');
      if (email.isEmpty || !email.contains('@')) throw Exception('Please enter a valid email');
      if (phone.isEmpty || phone.length < 10) throw Exception('Please enter a valid phone number');
      if (password.length < 6) throw Exception('Password must be at least 6 characters');
      if (password != confirmPassword) throw Exception('Passwords do not match');
      if (address.isEmpty) throw Exception('Address is required');
      if (_dateOfBirth == null) throw Exception('Date of birth is required');
      if (_gender == null) throw Exception('Gender is required');
      if (_avatarImage == null) throw Exception('Please select a profile image');

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user_$email') != null) {
        throw Exception('Email already registered');
      }
      await prefs.setString('user_$email', password);
      await prefs.setString('avatar_$email', _avatarImage!.path);
      await prefs.setString('name_$email', fullName);
      await prefs.setString('phone_$email', phone);
      await prefs.setString('address_$email', address);
      await prefs.setString('dob_$email', _dateOfBirth!.toIso8601String());
      await prefs.setString('gender_$email', _gender!);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('currentUser', email);

      await Future.delayed(const Duration(seconds: 1));
      Snack().success(context, "User Created Successfully");
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _avatarImage != null
                          ? FileImage(File(_avatarImage!.path))
                          : null,
                      child: _avatarImage == null
                          ? const Icon(CupertinoIcons.person_add, size: 50, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const CustomText(text: "Tap to select avatar", color: Colors.white),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _fullNameController,
                    hint: 'Full Name',
                    type: TextInputType.name,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    hint: 'Email',
                    type: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _phoneController,
                    hint: 'Phone Number',
                    type: TextInputType.phone,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _passwordController,
                    hint: 'Password',
                    type: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hint: 'Confirm Password',
                    type: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _addressController,
                    hint: 'Address',
                    type: TextInputType.multiline,
                  
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    onTap: () => _selectDate(context),
                    width: double.infinity,
                    height: 35,
                    color: Colors.black87,
                    radius: 8,
                    child: Center(
                      child: CustomText(
                        text: _dateOfBirth == null
                            ? 'Select Date of Birth'
                            : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _gender,
                    hint: const CustomText(text: 'Select Gender', color: Colors.white),
                    isExpanded: true,
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: CustomText(text: gender, color: Colors.black),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _gender = value),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onTap: _register,
                    width: double.infinity,
                    height: 35,
                    color: Colors.black87,
                    radius: 8,
                    child: const Center(
                      child: CustomText(
                        text: "Register",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const CustomText(
                      text: "Already have an account? Login",
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const CustomText(text: "powered by rich sonic 2025", color: Colors.white),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}