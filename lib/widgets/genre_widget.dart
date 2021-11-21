import 'package:flutter/material.dart';
import 'package:tmdb/bloc/get_genres_bloc.dart';
import 'package:tmdb/model/genre.dart';
import 'package:tmdb/model/genreresponse.dart';
import 'package:tmdb/widgets/genre_tabs_widget.dart';

class GenreWidget extends StatefulWidget {
  const GenreWidget({Key? key}) : super(key: key);

  @override
  _GenreWidgetState createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {

  @override
  void initState() {
    super.initState();
    genresBloc.getAllGenres();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GenreResponse>(
      stream: genresBloc.subject.stream,
      builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data!.error != null && snapshot.data!.error!.isEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildGenreWidget(snapshot.data);
        } else if(snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildErrorWidget(String? error) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 270.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("Error occurred: $error")],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 270.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 4.0,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGenreWidget(GenreResponse? data) {
    List<Genre> genres = data!.genres;

    if(genres.isNotEmpty) {
      return GenreTabs(genres: genres);
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No genres to display",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    }
  }

}
