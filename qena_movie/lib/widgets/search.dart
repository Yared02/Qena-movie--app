import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/models/movie_model.dart';
import 'package:qena_movie/screens/Movie/movie_detail_screen.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ImageSearchDelegate extends SearchDelegate {
  final List<MovieModel> _movies;

  ImageSearchDelegate(this._movies);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.amber, // Customize the color
        size: 28.0, // Customize the size
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    final filteredResults = _movies
        .where((movie) =>
            movie.title!.toLowerCase().contains(query.toLowerCase()) ||
            movie.Writer!.toLowerCase().contains(query.toLowerCase()) ||
            movie.Genre!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 9.0,
          // mainAxisSpacing: 8.0,
          childAspectRatio: 0.9,
        ),
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          var movie = filteredResults[index];
          final imageUrl = '${BASE_URL}api/poster/${movie.id}';
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MovieDetailScreen(movie: movie, image: imageUrl),
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
                    '${movie.title}',
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
    );
  }
}
