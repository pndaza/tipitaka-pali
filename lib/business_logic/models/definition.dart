import 'dart:convert';
/////////////////////////////////
// usage
/*    String dbQuery =
        '''Select residentDetails.id_code, residentDetails.dhamma_name, residentDetails.passport_name,residentDetails.kuti, residentDetails.country, interviews.stime, interviews.teacher, interviews.pk
          FROM residentDetails, interviews
          WHERE residentDetails.id_code = interviews.id_code
          ORDER BY interviews.stime DESC''';

    List<Map> list = await _db.rawQuery(dbQuery);
    return list
        .map((interviewdetails) => InterviewDetails.fromJson(interviewdetails))
        .toList();

    /// alternative from original tutorial
    //return list.map((trail) => Trail.fromJson(trail)).toList();
*/

List<Definition> definitionFromJson(String str) =>
    List<Definition>.from(json.decode(str).map((x) => Definition.fromJson(x)));

String definitionToJson(List<Definition> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Definition {
  String? word;
  String definition;
  String bookName;
  int userOrder;

  Definition(
      {this.word = "",
      this.definition = "",
      this.bookName = "",
      this.userOrder = 0});

  factory Definition.fromJson(Map<dynamic, dynamic> json) {
    return Definition(
      word: json["word"] ?? "n/a",
      definition: json["definition"] ?? "n/a",
      bookName: json["name"] ?? "n/a",
      userOrder: json["user_order"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "word": word,
        "definition": definition,
        "name": bookName,
        "user_order": userOrder,
      };

  @override
  String toString() {
    return '$bookName: $definition';
  }
}
