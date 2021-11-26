import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tmdb/bloc/person_details_screen_bloc/get_person_details_bloc.dart';
import 'package:tmdb/model/person_detail.dart';
import 'package:tmdb/model/person_detail_response.dart';
import 'package:tmdb/style/theme.dart';
import 'package:tmdb/utils/constants.dart';

class PersonDetailsScreen extends StatefulWidget {
  const PersonDetailsScreen({Key? key}) : super(key: key);

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final personId = Get.arguments;

    getPersonDetailsBloc.getPersonDetails(personId);
  }

  @override
  void deactivate() {
    getPersonDetailsBloc.drainStream();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
        centerTitle: true,
        title: const Text(
          "Person Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Container(
          color: MyColors.mainColor,
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<PersonDetailResponse>(
              stream: getPersonDetailsBloc.subject.stream,
              builder:
                  (context, AsyncSnapshot<PersonDetailResponse?> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.error != null &&
                      snapshot.data!.error!.isEmpty) {
                    return _buildErrorWidget(snapshot.data!.error);
                  }
                  return _buildPersonDetailsWidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error.toString());
                } else {
                  return _buildLoadingWidget();
                }
              })),
    );
  }

  Widget _buildErrorWidget(String? error) {
    return SizedBox(
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

  Widget _buildPersonDetailsWidget(PersonDetailResponse? data) {
    PersonDetail? personDetails = data?.persons;

    return personDetails == null
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 100.0,
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        "No details found for this person.",
                        style: TextStyle(color: MyColors.titleColor),
                      )
                    ],
                  )
                ],
              ),
            ))
        : SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Column(
                       children: [
                         Container(
                           width: 100.0,
                           height: 100.0,
                           decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               image: DecorationImage(
                                   fit: BoxFit.cover,
                                   image: NetworkImage(
                                     "${Constants.baseImageUrl_w200}${personDetails.profileImg}",
                                   ))),
                         ),

                         const SizedBox(height: 8.0,),

                         Text(
                           personDetails.name,
                           style: const TextStyle(
                             color: MyColors.secondColor,
                             fontWeight: FontWeight.bold,
                             fontSize: 18.0,
                           ),
                         ),

                         const SizedBox(height: 8.0,),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(
                               personDetails.gender == 1
                               ? Icons.female
                               : Icons.male,
                               size: 20.0,
                               color: MyColors.secondColor,
                             ),

                             const SizedBox(width: 8.0),

                             Text(
                               getPersonGender(personDetails.gender).toUpperCase(),
                               style: const TextStyle(
                                 color: MyColors.titleColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14.0,
                               ),
                             ),
                           ],
                         ),

                         const SizedBox(height: 8.0,),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Icon(
                               FontAwesomeIcons.briefcase,
                               size: 15.0,
                               color: MyColors.secondColor,
                             ),

                             const SizedBox(width: 8.0),

                             Text(
                               personDetails.knownForDepartment.toUpperCase(),
                               style: const TextStyle(
                                 color: MyColors.titleColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14.0,
                               ),
                             ),
                           ],
                         ),

                         const SizedBox(height: 8.0,),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Icon(
                               FontAwesomeIcons.birthdayCake,
                               size: 15.0,
                               color: MyColors.secondColor,
                             ),

                             const SizedBox(width: 8.0),

                             Text(
                               personDetails.birthdate.toUpperCase(),
                               style: const TextStyle(
                                 color: MyColors.titleColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14.0,
                               ),
                             ),
                           ],
                         ),

                         const SizedBox(height: 8.0,),

                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Icon(
                               FontAwesomeIcons.home,
                               size: 15.0,
                               color: MyColors.secondColor,
                             ),

                             const SizedBox(width: 8.0),

                             Text(
                               personDetails.placeOfBirth.toUpperCase(),
                               style: const TextStyle(
                                 color: MyColors.titleColor,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14.0,
                               ),
                             ),
                           ],
                         ),

                       ],
                     )
                   ],
                 ),

                  const SizedBox(height: 8.0,),

                  const Text(
                    "AKA",
                    style: TextStyle(
                        color: MyColors.titleColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  Container(
                    height: 45.0,
                    padding: const EdgeInsets.only(right: 10.0, top: 10.0),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: personDetails.aka.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(width: 1.0, color: Colors.white),
                              ),
                              child: Text(
                                personDetails.aka[index],
                                maxLines: 2,
                                style: const TextStyle(
                                    height: 1.4,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),

                  const SizedBox(height: 16.0,),

                  const Text(
                    "BIOGRAPHY",
                    style: TextStyle(
                        color: MyColors.titleColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 16.0,),

                  Text(
                   personDetails.biography,
                    style: const TextStyle(
                        color: MyColors.titleColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                ],
              ),
            ),
        );
  }

  String getPersonGender(int id) {
    return id == 1 ? "Female" : "Male";
  }

  @override
  void didChangeDependencies() {
    final personId = Get.arguments;

    getPersonDetailsBloc.getPersonDetails(personId);
  }
}
