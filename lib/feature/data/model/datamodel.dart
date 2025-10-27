class Datamodel {
  int? id;
  String title;
  String description;
  Datamodel({this.id, required this.title, required this.description});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Datamodel.fromMap(Map<String, dynamic> map) {
    return Datamodel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }
}
