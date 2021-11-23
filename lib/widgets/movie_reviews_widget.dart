import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmdb/bloc/get_movie_reviews_bloc.dart';
import 'package:tmdb/model/review.dart';
import 'package:tmdb/model/review_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieReviewsWidget extends StatefulWidget {
  final int id;

  const MovieReviewsWidget({Key? key, required this.id}) : super(key: key);

  @override
  _MovieReviewsWidgetState createState() => _MovieReviewsWidgetState(id);
}

class _MovieReviewsWidgetState extends State<MovieReviewsWidget> {
  final int id;

  _MovieReviewsWidgetState(this.id);

  @override
  void initState() {
    super.initState();
    movieReviewsBloc.getReviewsOfMovie(id);
  }

  @override
  void dispose() {
    movieReviewsBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 20.0),
          child: Text(
            "REVIEWS",
            style: TextStyle(
                color: MyColors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        StreamBuilder<MovieReviewResponse>(
          stream: movieReviewsBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieReviewResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              print("Reviews: " + snapshot.data!.reviews.toString());
              return _buildMovieReviewsWidget(snapshot.data);
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "An Error occurred. Please try again later.",
              style: TextStyle(color: MyColors.titleColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250.0,
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

  Widget _buildMovieReviewsWidget(MovieReviewResponse? data) {
    List<MovieReview>? reviews = data?.reviews;
    return reviews == null || reviews.isEmpty
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        "No reviews found for this movie.",
                        style: TextStyle(color: MyColors.titleColor),
                      )
                    ],
                  )
                ],
              ),
            ))
        : Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            padding: const EdgeInsets.only(left: 10.0),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    width: MediaQuery.of(context).size.width - 50.0,
                    child: Card(
                      color: MyColors.cardColor,
                      elevation: 8.0,
                      child: GestureDetector(
                        onTap: () {
                          _launchURL(reviews[index].reviewUrl);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyColors.mainColor),
                                    child: const Icon(
                                      FontAwesomeIcons.userAlt,
                                      size: 10.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    reviews[index].authorUserName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 4.0,
                              ),

                              Text(
                                "Created at ${reviews[index].createdAt}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  height: 1.4,
                                  color: MyColors.titleColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                ),
                              ),

                              const SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                reviews[index].review,
                                maxLines: 4,
                                style: const TextStyle(
                                  height: 1.4,
                                  color: MyColors.secondColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),

                              // const SizedBox(
                              //   height: 5.0,
                              // ),
                              const Text(
                                "Click here to read full review.",
                                maxLines: 4,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  height: 1.4,
                                  color: MyColors.secondColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),

                            ],
                          ),
                        )
                      ),
                    ),
                  );
                }),
          );
  }

  void _launchURL(String url) async{
    if (!await launch(url)) throw 'Could not launch $url';
  }

}
