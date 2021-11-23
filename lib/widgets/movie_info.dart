import 'package:flutter/material.dart';
import 'package:tmdb/bloc/get_movie_details_bloc.dart';
import 'package:tmdb/model/movie_detail.dart';
import 'package:tmdb/model/movie_detail_response.dart';
import 'package:tmdb/style/theme.dart';

class MovieInfoWidget extends StatefulWidget {

  final int id;

  const MovieInfoWidget({Key? key, required this.id}) : super(key: key);

  @override
  _MovieInfoWidgetState createState() => _MovieInfoWidgetState(id);
}

class _MovieInfoWidgetState extends State<MovieInfoWidget> {

  final int id;

  _MovieInfoWidgetState(this.id);

  @override
  void initState() {
    super.initState();
    getMovieDetailsBloc.getMovieDetails(id);
  }

  @override
  void dispose() {
    super.dispose();
    getMovieDetailsBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieDetailResponse>(
      stream: getMovieDetailsBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<MovieDetailResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error!.isEmpty) {
            return _buildErrorWidget(snapshot.data!.error);
          }
          return _buildMovieDetailsWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else {
          return _buildLoadingWidget();
        }
      },);
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
    return Center(
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
    );
  }

  Widget _buildMovieDetailsWidget(MovieDetailResponse? data) {
    MovieDetail? movieDetail = data?.movieDetails;
    if(movieDetail == null) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No details found for this movie.",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "BUDGET",
                      style: TextStyle(
                        color: MyColors.titleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.0
                      ),),

                    SizedBox(height: 10.0,),

                    Text(
                      "${movieDetail.budget.toString()}\$",
                      style: TextStyle(
                        color: MyColors.secondColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DURATION",
                      style: TextStyle(
                          color: MyColors.titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0
                      ),),

                    SizedBox(height: 10.0,),

                    Text(
                      "${movieDetail.runtime.toString()} min",
                      style: TextStyle(
                          color: MyColors.secondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "RELEASE DATE",
                      style: TextStyle(
                          color: MyColors.titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0
                      ),),

                    SizedBox(height: 10.0,),

                    Text(
                      "${movieDetail.releaseDate.toString()}",
                      style: TextStyle(
                          color: MyColors.secondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          SizedBox(height: 10.0,),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GENRES",
                  style: TextStyle(
                    color: MyColors.titleColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                  ),
                ),

                SizedBox(height: 10.0,),

                movieDetail.genres.isNotEmpty
                ? Container(
                  height: 38.0,
                  padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieDetail.genres.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              border: Border.all(width: 1.0, color: Colors.white),
                            ),
                            child: Text(
                              movieDetail.genres[index].name,
                              maxLines: 2,
                              style: TextStyle(
                                  height: 1.4,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                )
                    : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: Center(
                    child: Text(
                      "No genres found for this movie",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.titleColor
                      ),
                    ),
                  ),
                )
              ],
            )
          ),

        ],
      );
    }
  }

}
