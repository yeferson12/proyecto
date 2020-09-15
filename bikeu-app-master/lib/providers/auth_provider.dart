import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../utils/constants.dart';
import 'dart:io' as Io;

import '../models/user.dart';

final String _url1 = 'http://127.0.0.1:8000/api';

class AuthProvider extends ChangeNotifier {
  Future<void> registerUser(User user) async {
    final url = apiUrl + "/users";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "name": user.name,
          "last_name": user.lastName,
          "email": user.email,
          "password": user.password,
          "phone": user.phone
        }),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> loginUser(String email, String password) async {
    final url = apiUrl + "/login";
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw responseData['error'];
      }
      Map<String, dynamic> decodeResponse = json.decode(response.body);
      if (decodeResponse.containsKey('access_token')) {
        // _preferences.laravelToken = decodeResponse['access_token'];
        // _preferences.email = decodeResponse['user']['email'];
        // _preferences.name = decodeResponse['user']['name'];
        // _preferences.image = decodeResponse['user']['image'];
        // _preferences.userType = decodeResponse['user']['user_types_id'];
        return {"ok": true};
      } else {
        return {"ok": false, "message": decodeResponse};
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> formatoUser(String name, String dni, String email, String phone,
      PickedFile foto) async {
    final url = "$_url1/formapp";
    final bytes = Io.File(foto.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print('=======================');
    print('NOmbre: ${img64}');
    print('=======================');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "name": name,
          "dni": dni,
          "email": email,
          "phone": phone,
        }),
      );

      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
