// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';

// class SaveImage {
//   static const String imgKey = 'IMAGE_KEY';

//   /// Saves an image represented as a Base64 string to shared preferences.
//   static Future<bool> saveImageToPrefs(String value) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString(imgKey, value);
//   }

//   /// Retrieves the image from shared preferences as a Base64 string.
//   static Future<String?> getImageFromPrefs() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(imgKey);
//   }

//   /// Converts a [Uint8List] to a Base64 string.
//   static String base64String(Uint8List data) {
//     return base64Encode(data);
//   }

//   /// Creates an [Image] widget from a Base64 string.
//   static Image imageFromBase64(String base64String) {
//     final bytes = base64Decode(base64String);
//     return Image.memory(Uint8List.fromList(bytes));
//   }
// }
// save_images.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; 
import 'dart:io'; 

class ImageSharedPrefs {
  static const String IMAGE_KEY = 'user_image'; 

  static Future<String> loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(IMAGE_KEY) ?? '';
  }

  static Future<void> saveImageToPrefs(String imageBase64String) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(IMAGE_KEY, imageBase64String);
  }

  static String base64String(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Image imageFrom64BaseString(String base64String) {
    return Image.memory(base64Decode(base64String));
  }
}