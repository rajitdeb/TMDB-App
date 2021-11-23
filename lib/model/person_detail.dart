class PersonDetail {
  final int id;
  final String name;
  final String knownForDepartment;
  final String profileImg;
  final int gender;
  final String biography;
  final String birthdate;
  final String placeOfBirth;
  final List<String> aka;

  PersonDetail(this.id, this.name, this.knownForDepartment, this.profileImg,
      this.gender, this.biography, this.birthdate, this.placeOfBirth, this.aka);

  PersonDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        knownForDepartment = json["known_for_department"],
        profileImg = json["profile_path"],
        gender = json["gender"],
        biography = json["biography"],
        birthdate = json["birthday"],
        placeOfBirth = json["place_of_birth"],
        aka = (json["also_known_as"] as List).map((e) => e.toString()).toList();
}
