import 'package:equatable/equatable.dart';

class Datamodel extends Equatable {
  final int? id;
  final String title;
  final String description;
  const Datamodel({this.id, required this.title, required this.description});

  Datamodel copyWith({int? id, String? title, String? description}) {
    return Datamodel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

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
  @override
  List<Object?> get props => [id, title, description];
}
