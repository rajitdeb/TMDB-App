import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tmdb/bloc/search_movies_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class SearchMovies extends SearchDelegate<Movie?> {

  SearchMovies() : super(searchFieldStyle: TextStyle(color: Colors.white));

  final suggestionsList = [
    "Shershaah",
    "1917",
    "Hello Brother",
    "State of Siege",
    "URI",
    "Avengers",
    "Finch"
  ];


  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: MyColors.mainColor, // affects AppBar's background color
        actionsIconTheme: IconThemeData(
          color: Colors.white // affects action Icons like (Search, back button) in AppBar
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: InputBorder.none, // affects the Underline Border of Search Bar; in Focus
        border: InputBorder.none  // affects when Search Bar is in searched state
      ),
      hintColor: Colors.grey, // affects the initial 'Search' text
      textTheme: const TextTheme(
        headline6: TextStyle( // headline 6 affects the query text
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold
        )
      ),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
          selectionColor: Colors.white,
          selectionHandleColor: Colors.white
      ), // affects when the text in Search Bar is selected
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(EvaIcons.close), onPressed: (){
      query = "";
    },)];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    final resultsList = searchMoviesBloc.subject.stream.value.movies;

    return Container(
      color: MyColors.mainColor,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
            itemCount: resultsList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                height: 150.0,
                child: GestureDetector(
                    onTap: () { close(context, resultsList[index]); },
                    child: _buildMovieItemRow(context, resultsList[index]!)
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isNotEmpty){
      searchMoviesBloc.searchAMovie(query);
    }

    return Container(
      color: MyColors.mainColor,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListView.builder(
            itemCount: suggestionsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () { query = suggestionsList[index]; },
                child: SizedBox(
                  height: 50.0,
                  child: _buildSuggestionsItemRow(context, suggestionsList[index])
                ),
              );
            }
        ),
      ),
    );

  }

  Widget _buildMovieItemRow(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 100.0,
            height: 150.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  movie.poster == null
                  ? "https://www.peoplenet.in/assets/not-found.png"
                  : "${Constants.baseImageUrl_w200}${movie.poster}",
                )
              ),
            ),
          ),

          SizedBox(width: 16.0),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                movie.title.length > 20
                ? movie.title.substring(0,20) + "..."
                : movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 19.0
                ),
              ),

              SizedBox(height: 8.0),

              Container(
                width: 200.0,
                child: Text(
                  movie.overview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                      color: MyColors.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0
                  ),
                ),
              ),

              SizedBox(height: 8.0),

              RatingBar.builder(
                  itemSize: 14.0,
                  initialRating: movie.rating / 2,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(
                      horizontal: 2.0),
                  itemBuilder: (context, _) =>
                  const Icon(
                      EvaIcons.star,
                      color: MyColors.secondColor,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  }
              )

            ],
          )
        ],
      ),
    );
  }

  Widget _buildSuggestionsItemRow(BuildContext context, String suggestion) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(EvaIcons.trendingUp, color: MyColors.secondColor,),

          const SizedBox(width: 16.0,),

          Text(
            suggestion,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400 ,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

}