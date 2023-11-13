import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qena_movie/common/base_url.dart';
import 'package:qena_movie/common/color.dart';
import 'package:qena_movie/models/movie_model.dart';
import 'package:qena_movie/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class MovieDetailScreen extends StatefulWidget {
  final MovieModel movie;
  final String image;

  MovieDetailScreen({
    Key? key,
    required this.movie,
    required this.image,
  }) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final TextEditingController content = TextEditingController();
  // final TextEditingController userName = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic> filterComment = [];
  String userName34 = '';

  Future<void> _loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName34 = prefs.getString('name') ?? '';
    });
  }

  Future<void> _saveValues(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', username);

    setState(() {
      userName34 = username;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchComments();
    _loadSavedValues();
  }

  Future<void> fetchComments() async {
    final response = await http.get(
      Uri.parse('${BASE_URL}api/comments/${widget.movie.id}'),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        filterComment = jsonData;
      });
    } else {
      print('Failed to fetch comments');
    }
  }

  Future<void> addComment(String text) async {
    final response = await http.post(
      Uri.parse('${BASE_URL}api/comments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'text': text,
        'userName': userName34, // Replace with actual username logic
        'id': widget.movie.id,
      }),
    );
    if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: "Comment added successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      throw Exception('Failed to add comment');
    }
    fetchComments();
    content.clear();
  }

  Future<void> addReply(String commentId, String userName, String text) async {
    final response = await http.post(
      Uri.parse('${BASE_URL}api/comments/$commentId/replies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text, "username": userName34}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add reply');
    } else {
      fetchComments();
    }
  }

  Future<void> rateComment(String commentId, int rating) async {
    final response = await http.post(
      Uri.parse('${BASE_URL}api/comments/$commentId/rate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'rating': rating}),
    );
    if (response.statusCode == 200) {
      // Update the rating count in the local data
      setState(() {
        var commentIndex =
            filterComment.indexWhere((comment) => comment['_id'] == commentId);
        if (commentIndex != -1) {
          filterComment[commentIndex]['rating'] += rating;
        }
      });
    } else {
      throw Exception('Failed to rate comment');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        },
        elevation: 180,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.home_outlined),
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title ?? '',
                style:
                    TextStyle(color: Colors.amber), // Set title color to amber
              ),
              background: Hero(
                tag: 'movie-poster-${widget.movie.Actors}',
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.amber, // Set arrow color to amber
            ),

            backgroundColor: CustomColors.testColor1,
            iconTheme:
                IconThemeData(color: Colors.amber), // Set arrow color to amber
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie Details Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Director: ${widget.movie.Director ?? ''}',
                              style: _theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Actors: ${widget.movie.Actors ?? ''}',
                              style: _theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'Description',
                              style: _theme.textTheme.headline5
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              '${widget.movie.description ?? ''}',
                            ),
                            Text(
                              'Language: ${widget.movie.Language ?? ''}/'
                              '${widget.movie.Type ?? ''}movie',
                              style: _theme.textTheme.bodyMedium
                                  ?.copyWith(color: CustomColors.testColor1),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[400], thickness: 2.0),

                      // User Information Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Comment input field
                            Form(
                              key: _formKey,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: content,
                                      decoration: InputDecoration(
                                        hintText: 'Add a comment...',
                                        filled: true,
                                        fillColor: Colors.amber,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a comment';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        addComment(content.text);
                                      }
                                    },
                                    child: Text(
                                      'Add Comment',
                                      style: TextStyle(
                                          color: Colors
                                              .amber), // Set text color to amber
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: CustomColors.testColor1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey[400], thickness: 2.0),

                      // Display comments
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Comments',
                              style: _theme.textTheme.headline5
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),

                          // Comment List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: filterComment.length,
                            itemBuilder: (context, index) {
                              TextEditingController replyController =
                                  TextEditingController();

                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${filterComment[index]['userName']}: ${filterComment[index]['text']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.testColor1,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.add),
                                                    onPressed: () =>
                                                        rateComment(
                                                            filterComment[index]
                                                                ['_id'],
                                                            1),
                                                    color:
                                                        CustomColors.testColor1,
                                                  ),
                                                  SmoothStarRating(
                                                    rating: filterComment[index]
                                                            ['rating']
                                                        .toDouble(),
                                                    size: 20,
                                                    filledIconData: Icons.star,
                                                    halfFilledIconData:
                                                        Icons.star_half,
                                                    defaultIconData:
                                                        Icons.star_border,
                                                    starCount: 5,
                                                    allowHalfRating: true,
                                                    color: Colors.amber,
                                                    borderColor: Colors.amber,
                                                    spacing: 0.0,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons
                                                        .minimize_outlined),
                                                    onPressed: () =>
                                                        rateComment(
                                                            filterComment[index]
                                                                ['_id'],
                                                            -1),
                                                    color:
                                                        CustomColors.testColor1,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                '12h ago', // Replace with actual timestamp
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    for (var reply in filterComment[index]
                                        ['replies'])
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          '${reply['userName34']}: ${reply['text']}',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: replyController,
                                              decoration: InputDecoration(
                                                hintText: 'Add a reply...',
                                                border: InputBorder.none,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a replay';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          IconButton(
                                            onPressed: () => addReply(
                                                filterComment[index]['_id'],
                                                filterComment[index]
                                                    ['userName'],
                                                replyController.text),
                                            icon: Icon(Icons.send),
                                            color: CustomColors
                                                .testColor1, // Set your desired color
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
