// import 'page/setting.dart';
// import 'page/tender.dart';
// import 'widget/navigation_drawer_widget.dart';
// import 'page/home.dart';
// import 'package:what/page/login.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qena_movie/common/color.dart';

import 'package:qena_movie/screens/Signup.dart';
import 'package:qena_movie/widgets/header_widget.dart';

// import 'package:beta/widget/form_widget.dart';

import 'controller/userController.dart';
import 'model/userModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final UserController userController = Get.put(UserController());
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isObs = true;
  bool isEmailEmpty = false;
  bool isPasswordEmpty = false;

  get isEmpty => null;
  bool isLoading = false;

  void submit() {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      final user = User(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      setState(() {
        isLoading = true;
      });
      userController.login(user).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      setState(() {
        isEmailEmpty = email.text.isEmpty;
        isPasswordEmpty = password.text.isEmpty;
      });
    }
  }

  final Key _formKey = GlobalKey<FormState>();
  // login() async {
  //   var response = await NetworkHandler.post("empLogin",
  //       {'email': email.text.trim(), 'password': password.text.trim()});

  //   if (response.statusCode == 200) {
  //     await SessionManager()
  //         .set('empid', response.data['user']['empid'].toString());
  //     await SessionManager()
  //         .set('email', response.data['user']['email'].toString());
  //     await SessionManager().set('token', response.data['token'].toString());
  //     Get.to(() => MainPage());
  //   } else {
  //     Fluttertoast.showToast(msg: response!.data['error']);
  //   }
  // }

  @override
  Widget textField(icon, lable, controller, isEmpty) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        labelText: lable,
        errorText: isEmpty ? "Empty Field!" : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      ),
    );
  }

  Widget submitButton(
      {required VoidCallback onPressed, bool isLoading = false}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10), // Increase the vertical padding
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!isLoading)
                Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Optional: Adjust the font size
                  ),
                ),
              if (isLoading)
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              if (isLoading)
                Positioned(
                  bottom: 10,
                  child: Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget passwordField(icon, lable, controller, obs, setState, isEmpty) {
    return TextField(
      controller: controller,
      obscureText: obs,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          suffixIcon: IconButton(
              onPressed: () {
                setState();
              },
              icon: Icon(obs ? Icons.visibility : Icons.visibility_off)),
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(gapPadding: 5),
          focusColor: Colors.amberAccent,
          labelText: lable,
          errorText: isEmpty ? "Empty Field!" : null
          // errorText: validate ? 'Value Can\'t Be Empty' : null,
          ),
    );
  }

  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.3,
              child: HeaderWidget(
                height: height * 0.3,
                showIcon: true,
                icon: Icons.lock,
              ),
              //let's create a common header widget
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(
                    20, 10, 20, 10), // This will be the login form
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Signin into your account',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            textField(Icons.email_outlined, "Email", email,
                                isEmailEmpty),
                            const SizedBox(height: 30),
                            passwordField(Icons.password_outlined, "Password",
                                password, isObs, () {
                              setState(() {
                                isObs = !isObs;
                              });
                            }, isPasswordEmpty),
                            const SizedBox(height: 15.0),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const ForgotPasswordPage()),
                                  // );
                                },
                                child: const Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            submitButton(
                              onPressed: submit,
                              isLoading: isLoading,
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                              //child: Text('Don\'t have an account? Create'),
                              child: Text.rich(TextSpan(children: [
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Create',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Signup()));
                                    },
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber),
                                ),
                              ])),
                            ),
                          ],
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
