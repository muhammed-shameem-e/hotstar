class PopularMovie{
  final String posterPath;
  PopularMovie({
    required this.posterPath,
  });
  factory PopularMovie.fromJson(Map<String,dynamic> json){
    return PopularMovie(
      posterPath: json['poster_path'],
    );
  }
}