import 'package:tmdb/model/crew.dart';

class CrewResponse {

  final List<Crew>? crewMembers;
  final String? error;

  CrewResponse(this.crewMembers, this.error);

  CrewResponse.fromJson(Map<String, dynamic> json)
   : crewMembers = (json["crew"] as List).map((e) => Crew.fromJson(e)).toList(),
      error = null;

  CrewResponse.withError(String errorValue)
  : crewMembers = null,
    error = errorValue;
}