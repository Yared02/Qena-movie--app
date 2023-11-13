import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qena_movie/common/color.dart';
import 'package:qena_movie/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qena_movie/screens/userPage/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  String title = 'Maziv Engineering';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  runApp(SafeArea(
    child: GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Sans',
      ),
      debugShowCheckedModeBanner: false,
      title: title,
      home: token != null ? const HomeScreen() : const LoginPage(),
    ),
  ));
}

class MovieApp23 extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Qena Movie',
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        // brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Color(0xFF1D2027),
        primaryColor: Color(0xFF546EE5),
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.testColor1,
          elevation: 0.0,
          centerTitle: true,
        ),
        iconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headline1: GoogleFonts.poppins(
            fontSize: 20.0,
            color: Colors.amberAccent,
            fontWeight: FontWeight.w600,
          ),
          headline2: GoogleFonts.poppins(
            fontSize: 9.0,
            color: Colors.black38,
            fontWeight: FontWeight.w600,
          ),
          headline3: GoogleFonts.poppins(
            fontSize: 16.0,
            color: Colors.black38,
            fontWeight: FontWeight.w600,
          ),
          bodyText1: GoogleFonts.poppins(
            fontSize: 16.0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          bodyText2: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          subtitle1: GoogleFonts.poppins(
            fontSize: 14.0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
          subtitle2: GoogleFonts.poppins(
            fontSize: 12.0,
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}
