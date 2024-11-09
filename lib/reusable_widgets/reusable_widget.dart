import 'package:flutter/material.dart';

// Widget to display a logo image with adjustable properties
Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.contain, // Contain allows more flexibility for different image sizes
    width: 240,
    height: 240,
  );
}

// Reusable text field widget for input fields
TextField reusableTextField(
    String hintText, IconData icon, bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: hintText,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide.none, // Remove border outline
      ),
    ),
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

// Reusable button widget for sign-in or sign-up actions
Container signInSignUpButton(BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: double.infinity,
    height: 50,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        elevation: 3, // Button shadow
      ),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ),
  );
}
