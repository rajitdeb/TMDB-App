import 'package:tmdb/model/person_detail.dart';

class PersonDetailResponse {
  final PersonDetail? persons;
  final String? error;

  PersonDetailResponse(this.persons, this.error);

  PersonDetailResponse.fromJson(Map<String, dynamic> json)
      : persons = PersonDetail.fromJson(json),
        error = null;

  PersonDetailResponse.withError(String errorValue)
      : persons = null,
        error = errorValue;
}
