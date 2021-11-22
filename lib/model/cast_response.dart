import 'package:tmdb/model/cast.dart';

class CastResponse {
  final List<Cast>? casts;
  final String? error;

  CastResponse(this.casts, this.error);

  CastResponse.fromJson(Map<String, dynamic> json)
      : casts = (json["cast"] as List).map((e) => Cast.fromJson(e)).toList(),
        error = null;

  CastResponse.withError(String errorValue)
      : casts = null,
        error = errorValue;

}