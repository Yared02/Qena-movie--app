import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController {
  var myData = <String, dynamic>{}.obs;
  String name = '';
  String role = '';
  String email = '';
  String empid = '';
  String token = '';

  Future<void> updateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String storedName = prefs.getString('name') ?? '';
    String storedRole = prefs.getString('role') ?? '';
    String storedEmail = prefs.getString('email') ?? '';
    String storedEmpid = prefs.getString('empid') ?? '';
    String storedToken = prefs.getString('token') ?? '';

    name = storedName;
    role = storedRole;
    email = storedEmail;
    empid = storedEmpid;
    token = storedToken;

    myData.value = {
      'name': name,
      'token': token,
      'role': role,
      'email': email,
      "empid": empid,
    };

    // Trigger an update to refresh the UI
    update();
  }
}
