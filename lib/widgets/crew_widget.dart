import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tmdb/bloc/get_crew_from_movie_bloc.dart';
import 'package:tmdb/model/crew.dart';
import 'package:tmdb/model/crew_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class CrewWidget extends StatefulWidget {
  final int id;

  const CrewWidget({Key? key, required this.id}) : super(key: key);

  @override
  _CrewWidgetState createState() => _CrewWidgetState(id);
}

class _CrewWidgetState extends State<CrewWidget> {
  final int id;

  _CrewWidgetState(this.id);

  @override
  void initState() {
    super.initState();
    crewFromMovieBloc.getCrewFromMovie(id);
  }

  @override
  void dispose() {
    crewFromMovieBloc.drainStream();
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
            "CREW",
            style: TextStyle(
                color: MyColors.titleColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.0),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        StreamBuilder<CrewResponse>(
          stream: crewFromMovieBloc.subject.stream,
          builder: (context, AsyncSnapshot<CrewResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildCrewFromMovieWidget(snapshot.data);
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

  Widget _buildCrewFromMovieWidget(CrewResponse? data) {
    List<Crew>? crewMembers = data?.crewMembers;

    return crewMembers == null || crewMembers.isEmpty
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
                        "No cast found for this movie.",
                        style: TextStyle(color: MyColors.titleColor),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 170.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: crewMembers.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                    width: 100.0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          crewMembers[index].img == null
                              ? Hero(
                                  tag: crewMembers[index].id,
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyColors.secondColor),
                                    child: const Icon(
                                      FontAwesomeIcons.userAlt,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Hero(
                                  tag: crewMembers[index].id,
                                  child: Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "${Constants.baseImageUrl_w300}${crewMembers[index].img}"))),
                                  ),
                                ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            crewMembers[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              height: 1.4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            crewMembers[index].knownFor == null
                                ? "Unknown"
                                : crewMembers[index].knownFor.toString(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
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
                }),
          );
  }
}
