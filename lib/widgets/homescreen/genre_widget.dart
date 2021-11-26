import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/bloc/homescreen_bloc/get_genres_bloc.dart';
import 'package:tmdb/model/genre.dart';
import 'package:tmdb/model/genreresponse.dart';
import 'package:tmdb/widgets/homescreen/genre_tabs_widget.dart';

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
    return SizedBox(
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
    return SizedBox(
      height: 270.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 70.0,
                child: Lottie.asset("assets/gradient_circular_loader.json")
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGenreWidget(GenreResponse? data) {
    List<Genre>? genres = data?.genres;

    if(genres != null || genres!.isNotEmpty) {
      print(genres[0].name);
      return GenreTabs(genres: genres);
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Text(
          "No genres to display",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black45),
        )
      );
    }
  }

}
