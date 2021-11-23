import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tmdb/bloc/get_similar_movies_bloc.dart';
import 'package:tmdb/model/movie.dart';
import 'package:tmdb/model/movie_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class SimilarMoviesWidget extends StatefulWidget {

  final int id;

  const SimilarMoviesWidget({Key? key, required this.id}) : super(key: key);

  @override
  _SimilarMoviesWidgetState createState() => _SimilarMoviesWidgetState(id);
}

class _SimilarMoviesWidgetState extends State<SimilarMoviesWidget> {

  final int id;

  _SimilarMoviesWidgetState(this.id);

  @override
  void initState() {
    super.initState();
    similarMoviesBloc.getSimilarVideos(id);
  }

  @override
  void dispose() {
    similarMoviesBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "SIMILAR MOVIES",
            style: TextStyle(
                color: MyColors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0
            ),
          ),
        ),

        SizedBox(height: 5.0,),

        StreamBuilder<MovieResponse>(
          stream: similarMoviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null && snapshot.data!.error!.isEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildSimilarMoviesWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error.toString());
            } else {
              return _buildLoadingWidget();
            }
          },
        )
      ],
    );
  }

  Widget _buildErrorWidget(String? error) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: MediaQuery
          .of(context)
          .size
          .height,
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
      width: MediaQuery.of(context).size.width,
      height: 220.0,
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

  Widget _buildSimilarMoviesWidget(MovieResponse? data) {
    List<Movie?>? movies = data?.movies;
    if(movies == null || movies.isEmpty){
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No movies found for recommendation.",
                  style: TextStyle(color: MyColors.titleColor),
                )
              ],
            )
          ],
        ),
      );
    }else {
      return Container(
        height: 270.0,
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: movies[index]!.id,
                        child: Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(2.0),),
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                              image: NetworkImage(
                                "${Constants.baseImageUrl_w200}${movies[index]!.poster}"
                              )
                            )
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0,),

                      Container(
                        width: 100.0,
                        child: Text(
                          movies[index]!.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0
                          ),
                        ),
                      ),

                      SizedBox(height: 10.0,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBar.builder(
                              itemSize: 14.0,
                              initialRating: (movies[index]!.rating / 2).toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 2.0),
                              itemBuilder: (context, _) =>
                              const Icon(
                                  EvaIcons.star,
                                  color: MyColors.secondColor
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              }
                          )
                        ],
                      )
                    ],
                  )
                ),
              );
            }
        ),
      );
    }
  }
}
