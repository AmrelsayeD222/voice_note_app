import 'package:equatable/equatable.dart';

class Datamodel extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String? audioPath;
  const Datamodel(
      {this.id,
      required this.title,
      required this.description,
      this.audioPath});

  Datamodel copyWith(
      {int? id, String? title, String? description, String? audioPath}) {
    return Datamodel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      audioPath: audioPath ?? this.audioPath,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'description': description,
      'audioPath': audioPath,
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
      audioPath: map['audioPath'] as String? ?? '',
    );
  }
  @override
  List<Object?> get props => [id, title, description, audioPath];
}
