import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:ridemate_4/screens/home_screen.dart';
import 'package:ridemate_4/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  bool _showProgress = false;
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[900],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.orangeAccent[700],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 80),
                      const Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildTextField(
                        controller: nameController,
                        hintText: 'Full Name',
                        validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: phoneController,
                        hintText: 'Phone Number',
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty ? "Phone number cannot be empty" : null,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: emailController,
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: _isPasswordObscure,
                        suffixIcon: _togglePasswordVisibility(isConfirmPassword: false),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _isConfirmPasswordObscure,
                        suffixIcon: _togglePasswordVisibility(isConfirmPassword: true),
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 20),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 14),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: validator,
    );
  }

  Widget _togglePasswordVisibility({required bool isConfirmPassword}) {
    return IconButton(
      icon: Icon(isConfirmPassword
          ? _isConfirmPasswordObscure
              ? Icons.visibility_off
              : Icons.visibility
          : _isPasswordObscure
              ? Icons.visibility_off
              : Icons.visibility),
      onPressed: () {
        setState(() {
          if (isConfirmPassword) {
            _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
          } else {
            _isPasswordObscure = !_isPasswordObscure;
          }
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Login", style: TextStyle(fontSize: 20)),
        ),
        ElevatedButton(
          onPressed: _register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("Register", style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Text(
      "RideMate",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.yellowAccent[400],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email cannot be empty";
    }
    if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$').hasMatch(value)) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  // Registration method
  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showProgress = true;
      });
      try {
        // Create user using Firebase Auth
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Store user details in Firestore
        await _postDetailsToFirestore(userCredential.user!.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } catch (e) {
        print('Error registering: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed: $e')),
        );
      } finally {
        setState(() {
          _showProgress = false;
        });
      }
    }
  }

  // Store user details to Firestore
  Future<void> _postDetailsToFirestore(String uid) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = firebaseFirestore.collection('users');

    try {
      await users.doc(uid).set({
        'name': nameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
      });
      print('User details saved to Firestore');
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }
}
