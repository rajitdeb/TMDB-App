class Crew {

  final int id;
  final String? knownFor;
  final String name;
  final String? img;

  Crew(this.id, this.knownFor, this.name, this.img);

  Crew.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        knownFor = json["known_for_department"],
        name = json["name"],
        img = json["profile_path"];
}