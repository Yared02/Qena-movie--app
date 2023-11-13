import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/common/color.dart';
import 'package:qena_movie/models/movie_model.dart';
import 'package:qena_movie/screens/Movie/movie_detail_screen.dart';
import 'package:qena_movie/screens/home_screen.dart';
import 'package:qena_movie/screens/movie_type/Action.dart';
import 'package:qena_movie/screens/movie_type/Documentary.dart';
import 'package:qena_movie/screens/movie_type/Romance.dart';
import 'package:qena_movie/screens/movie_type/War.dart';
import 'package:qena_movie/screens/userPage/userMain.dart';
import 'package:qena_movie/widgets/My_Drawer.dart';
import 'package:qena_movie/widgets/search.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var images = <MovieModel>[].obs;
  var filteredImages = <MovieModel>[].obs;

  @override
  void onInit() {
    fetchImages();
    super.onInit();
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse('${BASE_URL}getMovie'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        images.value = jsonData
            .map<MovieModel>((json) => MovieModel.fromJson(json))
            .toList();
        filteredImages.value = images;
      } else {
        print('Failed to fetch images');
        throw Exception('Failed to fetch images');
      }
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }
}

class DashboardScreen extends StatelessWidget {
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: MyDrawer34(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
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
      body: Obx(() => Body(context, _theme)),
      backgroundColor: Colors.grey[200],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Qena Movie Review App',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.amber,
        ),
      ),
      iconTheme: IconThemeData(color: Colors.amber), // Change color to amber
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.amber),
          onPressed: () {
            showSearch(
              context: context,
              delegate: ImageSearchDelegate(dashboardController.images),
            );
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.amber),
          onSelected: (value) {
            // Handle the selected value, you can navigate to different pages here
            if (value == 'Action Movie') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            } else if (value == 'Romance Movie') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => RomanceMovie(),
                ),
              );
            } else if (value == 'War Movie') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => WarMovie(),
                ),
              );
            } else if (value == 'Documentary Movie') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DocumentaryMovie(),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'Action Movie',
                child: ListTile(
                  title: Text(
                    'Action Movie',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.movie,
                    color: Colors.amber,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'Romance Movie',
                child: ListTile(
                  title: Text(
                    'Romance Movie',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.movie,
                    color: Colors.amber,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'War Movie',
                child: ListTile(
                  title: Text(
                    'War Movie',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.movie,
                    color: Colors.amber,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'Documentary Movie',
                child: ListTile(
                  title: Text(
                    'Documentary Movie',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.movie,
                    color: Colors.amber,
                  ),
                ),
              ),
            ];
          },
        ),
      ],
      backgroundColor: CustomColors.testColor1,
    );
  }

  Widget Body(BuildContext context, ThemeData _theme) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Movies',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See more',
                style: _theme.textTheme.subtitle2?.copyWith(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12.0),
        Container(
          height: 220.0,
          child: ListView.builder(
            itemCount: dashboardController.filteredImages.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            itemBuilder: (context, index) {
              var _movie = dashboardController.filteredImages[index];
              final imageUrl = '${BASE_URL}api/poster/${_movie.id}';
              return GestureDetector(
                onTap: () {
                  // Add your action here, e.g., navigate to a details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movie: _movie, image: imageUrl),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            width: 120,
                            height: 180,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '${_movie.title}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SmoothStarRating(
                        // rating: filterComment[index]['rating']
                        // .toDouble(),
                        size: 10,
                        filledIconData: Icons.star,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: true,
                        color: Colors.amber,
                        borderColor: Colors.amber,
                        spacing: 0.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          margin: EdgeInsets.all(8.0), // Adjust or remove this line
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            "All Movies",
            style: _theme.textTheme.headline6,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            // crossAxisSpacing: 9.0,
            // mainAxisSpacing: 8.0,
            childAspectRatio: 0.9,
          ),
          itemCount: dashboardController.filteredImages.length,
          itemBuilder: (context, index) {
            var _movie = dashboardController.filteredImages[index];
            final imageUrl = '${BASE_URL}api/poster/${_movie.id}';
            return GestureDetector(
              onTap: () {
                // Add your action here, e.g., navigate to a details page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MovieDetailScreen(movie: _movie, image: imageUrl),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          width: double.infinity,
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '${_movie.title}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SmoothStarRating(
                      // rating: filterComment[index]['rating']
                      // .toDouble(),
                      size: 25,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      starCount: 5,
                      allowHalfRating: true,
                      color: Colors.amber,
                      borderColor: Colors.amber,
                      spacing: 0.0,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
