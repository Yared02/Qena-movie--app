import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qena_movie/common/Color.dart';

import 'package:qena_movie/screens/Movie/MovieMain.dart';
import 'package:qena_movie/screens/userPage/UserMain.dart';
import 'package:qena_movie/screens/userPage/controller/MyController.dart';
import 'package:qena_movie/screens/userPage/login_page.dart';

class MyDrawer34 extends StatelessWidget {
  final double drawerIconSize = 24.0;
  final double drawerFontSize = 15.0;
  final MyController myController = Get.put(MyController());

  @override
  Widget build(BuildContext context) {
    myController.updateData();
    return Drawer(
      child: Container(
        color: Colors.white, // Set the desired background color here
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: CustomColors.testColor1,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 1.0],
                  colors: [
                    CustomColors.testColor1,
                    CustomColors.testColor1,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 0.0,
                    ),
                    padding: EdgeInsets.all(36.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.amber,
                        width: 2.0,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://blog.hubspot.com/hs-fs/hubfs/parts-url-hero.jpg?width=595&height=400&name=parts-url-hero.jpg',
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Qena Movie App",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Welcome ${myController.name.toString()}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // AddMovie
            ListTile(
              leading: Icon(
                Icons.people,
                size: drawerIconSize,
                color: Colors.amber,
              ),
              title: Text(
                'User Page',
                style: GoogleFonts.openSans(
                  fontSize: drawerFontSize,
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserMain(),
                  ),
                );
              },
            ),

            ListTile(
              leading: Icon(
                Icons.movie,
                size: drawerIconSize,
                color: Colors.amber,
              ),
              title: Text(
                'Movies',
                style: GoogleFonts.openSans(
                  fontSize: drawerFontSize,
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieMain(),
                  ),
                );
              },
            ),

            Divider(
              color: Colors.grey[700]!,
              height: 1,
            ),

            ListTile(
              leading: Icon(
                Icons.password_rounded,
                size: drawerIconSize,
                color: Colors.amber,
              ),
              title: Text(
                'Forgot Password Page',
                style: TextStyle(
                  fontSize: drawerFontSize,
                  color: Colors.amber,
                ),
              ),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const LoginPage(),
                //   ),
                // );
              },
            ),

            Divider(
              color: Colors.grey[700]!,
              height: 1,
            ),

            ListTile(
              leading: Icon(
                Icons.logout,
                size: drawerIconSize,
                color: Colors.amber,
              ),
              title: Text(
                'LogOut',
                style: TextStyle(
                  fontSize: drawerFontSize,
                  color: Colors.amber,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
