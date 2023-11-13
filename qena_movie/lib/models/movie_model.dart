class MovieModel {
  final String? id;
  final String? movieId;
  final String? title;

  final String? Runtime;
  final String? Genre;
  final String? Writer;

  final String? Actors;
  final String? Director;

  final String? Plot;

  final String? Language;
  final String? description;
  final String? Type;

  final String? image;

  MovieModel({
    this.id,
    this.movieId,
    this.Runtime,
    this.title,
    this.Genre,
    this.Writer,
    this.image,
    this.Actors,
    this.Plot,
    this.Director,
    this.Language,
    this.description,
    this.Type,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['_id'],
      movieId: json['movieId'],
      Runtime: json['Runtime'],
      Genre: json['Genre'],
      Writer: json['Writer'],
      Actors: json['Actors'],
      Plot: json['Plot'],
      Language: json['Language'],
      description: json['description'],
      Type: json['Type'],
      title: json['Title'],
      Director: json['Director'],
    );
  }
}
