import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/screens/home_screen.dart';
import 'package:qena_movie/screens/userPage/userMain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../model/userModel.dart';

//'${baseUrl}read'
class UserController extends GetxController {
  Future<void> login(User user) async {
    Uri url = Uri.parse('${BASE_URL}api/auth/login');
    var response = await http.post(url, body: user.toJson());

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "success");

      // Extract the response data
      var responseData = json.decode(response.body);
      String token = responseData['token'];
      String name = responseData['firstname'];
      // String oid = responseData['oid'];

      String role = responseData['role'];
      String email = responseData['email'];
      String empid = responseData['empid'];

      // Store the data in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('name', name);
      await prefs.setString('role', role);
      await prefs.setString('email', email);
      await prefs.setString('empid', empid);
      // await prefs.setString('oid', oid);

      Get.to(() => HomeScreen());
    } else {
      Fluttertoast.showToast(msg: "error");
    }
  }
}
