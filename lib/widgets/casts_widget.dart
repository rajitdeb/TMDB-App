import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmdb/bloc/get_cast_from_movie_bloc.dart';
import 'package:tmdb/model/cast.dart';
import 'package:tmdb/model/cast_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class CastsWidget extends StatefulWidget {

  final int id;

  const CastsWidget({Key? key, required this.id}) : super(key: key);

  @override
  _CastsWidgetState createState() => _CastsWidgetState(id);
}

class _CastsWidgetState extends State<CastsWidget> {

  final int id;

  _CastsWidgetState(this.id);

  @override
  void initState() {
    super.initState();
    castFromMovieBloc.getCastsFromMovie(id);
  }

  @override
  void dispose() {
    castFromMovieBloc.drainStream();
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
            "CASTS",
            style: TextStyle(
              color: MyColors.titleColor,
              fontWeight: FontWeight.w500,
              fontSize: 12.0
            ),
          ),
        ),

        SizedBox(height: 5.0,),

        StreamBuilder<CastResponse>(
          stream: castFromMovieBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null && snapshot.data!.error!.isEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildCastsFromMovieWidget(snapshot.data);
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

  Widget _buildCastsFromMovieWidget(CastResponse? data) {
    List<Cast>? casts = data?.casts;
    if(casts == null || casts.isEmpty){
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
                  "No cast found for this movie.",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 170.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: casts.length,
            itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(top: 10.0, left: 10.0),
                  width: 100.0,
                  child: GestureDetector(
                    onTap:() {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        casts[index].img == null
                        ? Hero(
                          tag: casts[index].id,
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: MyColors.secondColor
                            ),
                            child: Icon(
                              FontAwesomeIcons.userAlt,
                              color: Colors.white,
                            ),
                          ),
                        )
                        : Hero(
                          tag: casts[index].id,
                          child: Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    "${Constants.baseImageUrl_w300}${casts[index].img}"
                                  )
                                )
                            ),
                          ),
                        ),

                        SizedBox(height: 4.0,),

                        Text(
                          casts[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),

                        SizedBox(height: 4.0,),

                        Text(
                          casts[index].character == null
                          ? "Unknown"
                          : casts[index].character.toString(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.4,
                            color: MyColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),

                      ],
                    ),
                  ),
                );
            }
        ),
      );
    }
  }

}
