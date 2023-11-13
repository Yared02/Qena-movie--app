import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qena_movie/screens/Movie/movie_detail_screen.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import '../models/movie_model.dart';
import 'package:octo_image/octo_image.dart';

class HorizontalMovieCard extends StatelessWidget {
  final MovieModel movie;
  final String imageUrl;

  const HorizontalMovieCard({
    Key? key,
    required this.movie,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Container(
      width: 200.0,
      height: 300.0, // Adjusted the height
      padding: EdgeInsets.only(right: 15.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  MovieDetailScreen(movie: movie, image: imageUrl),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: OctoImage(
                image: CachedNetworkImageProvider(imageUrl),
                width: 200.0,
                height: 170.0,
                fit: BoxFit.cover,
              ),
            ),
            // const SizedBox(height: 15.0),
            Text(
              movie.title!,
              maxLines: 1,
              style: _theme.textTheme.headline3,
            ),
            SmoothStarRating(
              // rating: movie.rating ?? 0.0, // Add rating
              color: Colors.amber,
              size: 15.0,
            ),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}
