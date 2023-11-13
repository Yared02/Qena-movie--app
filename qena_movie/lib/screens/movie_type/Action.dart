import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:octo_image/octo_image.dart';
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/common/color.dart';
import 'package:qena_movie/models/movie_model.dart'; // Make sure to import MovieModel if it's in a separate file
import 'package:qena_movie/screens/Movie/movie_detail_screen.dart';
import 'package:qena_movie/screens/home_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MovieApi {
  static Future<List<MovieModel>> getActionMovies() async {
    final String url = 'http://localhost:8005/get-Action';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<MovieModel> movies =
            data.map((item) => MovieModel.fromJson(item)).toList();
        return movies;
      } else {
        throw Exception('Failed to load action movies');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to connect to the server');
    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<MovieModel>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = MovieApi.getActionMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Action Movies',
          style:
              TextStyle(color: Colors.amber), // Set title text color to amber
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
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
      body: FutureBuilder<List<MovieModel>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<MovieModel> movies = snapshot.data!;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final imageUrl = '${BASE_URL}api/poster/${movies[index].id}';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          movie: movies[index],
                          image: imageUrl,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Card(
                      elevation: 5.0,
                      color: Colors.blueAccent, // Customize the color
                      child: Hero(
                        tag:
                            'movieImage${movies[index].id}', // Unique tag for each movie
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Movie Image with Gradient Overlay
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.0, 2.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: OctoImage(
                                image: CachedNetworkImageProvider(imageUrl),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Movie Title
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    '${movies[index].title}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            RatingBar.builder(
                              // initialRating: movies[index].rating ?? 0.0,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20.0,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // Update the rating
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
