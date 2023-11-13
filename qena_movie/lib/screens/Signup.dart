import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:qena_movie/common/Color.dart';
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/common/theme_helper.dart';
import 'package:qena_movie/main.dart';
import 'package:qena_movie/screens/userPage/UserMain.dart';
import 'package:qena_movie/screens/userPage/login_page.dart';
import 'package:qena_movie/widgets/My_Drawer.dart';

class Signup extends StatefulWidget {
  @override
  AdduserState createState() => AdduserState();
}

class AdduserState extends State<Signup> {
  int _selectedIndex = 0;
  String? _selectedGender;

  String _oId = '';
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _oidController = TextEditingController();

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _genderController.dispose();
    _mobileController.dispose();
    _usernameController.dispose();
    _roleController.dispose();
    _oidController.dispose();
    super.dispose();
  }

  // Function to make the registration API request
  Future<void> registerUser() async {
    final url = '${BASE_URL}api/auth/register';
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start showing the progress indicator
      });

      final response = await http.post(
        Uri.parse(url),
        body: {
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'gender': _selectedGender,
          'mobile': _mobileController.text,
          'username': _usernameController.text,
          'role': "employee",
          'oid': _oidController.text,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Account created  successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        setState(() {
          // Update the page state here
          // For example, you could clear the form fields
          _firstNameController.clear();
          _lastNameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _mobileController.clear();
          _usernameController.clear();
          _oidController.clear();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      setState(() {
        _isLoading = false; // Stop showing the progress indicator
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer34(),
      appBar: AppBar(
        title: Text(
          'Sign Up Page',
          style:
              TextStyle(color: Colors.amber), // Set title text color to amber
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          color: Colors.amber,
        ),
        backgroundColor: CustomColors.testColor1,
        iconTheme: IconThemeData(color: Colors.amber),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        elevation: 10,
        backgroundColor: CustomColors.testColor1,
        child: const Icon(Icons.home_outlined,
            color: Colors.amber), // Change color to amber
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        padding: EdgeInsets.all(10),
        color: CustomColors.testColor1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _firstNameController,
                  decoration: ThemeHelper()
                      .textInputDecoration('First Name', 'First Name '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter First Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _lastNameController,
                  // decoration: InputDecoration(labelText: 'Tendername Name'),
                  decoration: ThemeHelper()
                      .textInputDecoration('LastName', 'Enter  LastName'),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Enter LastName';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: ThemeHelper()
                      .textInputDecoration('UserName', ' Enter UserName '),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter UserName';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Email', 'please Enter Email'),
                  validator: (val) {
                    if (!(val!.isEmpty) &&
                        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                            .hasMatch(val)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Password', 'Enter  Password '),
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please enter your password";
                    }
                    if (val.length <= 6) {
                      return "Password must be longer than 6 characters";
                    }
                    if (!val.contains('@')) {
                      return "Password must contain the '@' character";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  decoration: ThemeHelper()
                      .textInputDecoration('Gender', 'Enter Gender'),
                  style: TextStyle(
                    fontSize: 16, // Customize the font size
                    color: Colors.black, // Customize the text color
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a gender';
                    }
                    return null;
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'Male',
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: 'Female',
                      child: Text('Female'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _mobileController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Mobile', 'Enter Mobile'),
                  validator: (val) {
                    if (!(val!.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)) {
                      return "Enter a valid phone number";
                    }
                    if (val.length <= 10) {
                      return "Mobile must be longer than 10 no";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 420,
                  height: 43,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : registerUser,
                    child: _isLoading
                        ? CircularProgressIndicator(
                            // Show the progress indicator
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal),
                          )
                        : const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.testColor1),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
