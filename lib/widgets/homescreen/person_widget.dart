import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/bloc/homescreen_bloc/get_persons_bloc.dart';
import 'package:tmdb/model/person.dart';
import 'package:tmdb/model/personresponse.dart';
import 'package:tmdb/screens/person_details_screen.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class PersonList extends StatefulWidget {
  const PersonList({Key? key}) : super(key: key);

  @override
  _PersonListState createState() => _PersonListState();
}

class _PersonListState extends State<PersonList> {
  @override
  void initState() {
    super.initState();
    personsBloc.getAllTrendingPerson();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.only(left: 10.0, top: 20.0),
            child: Text(
              "TRENDING PEOPLE OF THIS WEEK",
              style: TextStyle(
                  color: MyColors.titleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.0),
            )),
        const SizedBox(
          height: 10.0,
        ),
        StreamBuilder<PersonResponse>(
          stream: personsBloc.subject.stream,
          builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildTrendingPersonsWidget(snapshot.data);
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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

  Widget _buildTrendingPersonsWidget(PersonResponse? data) {
    List<Person>? persons = data?.persons;
    if (persons == null || persons.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: const [
                Text(
                  "No trending people to display",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 170.0,
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView.builder(
            itemCount: persons.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("Person Id: ${persons[index].id}");
                  Get.to(() => const PersonDetailsScreen(), arguments: persons[index].id);
                },
                child: Container(
                  width: 100.0,
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      persons[index].profileImg == null
                          ? Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.secondColor,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.userAlt,
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              width: 70.0,
                              height: 70.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: MyColors.secondColor,
                                  image: DecorationImage(
                                      image: NetworkImage("${Constants.baseImageUrl_w200}${persons[index].profileImg}"),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),

                      const SizedBox(height: 10.0),

                      Text(
                          persons[index].name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0
                        ),
                      ),

                      const SizedBox(height: 4.0),

                      Text(
                        "Trending for ${persons[index].known}",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: MyColors.secondColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11.0
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
}
