// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class LogingHeaderRequestModel {
  final String user_id;
  final String id_level;
  final String id_group_materi;
  final String id_lesson;
  LogingHeaderRequestModel({
    required this.user_id,
    required this.id_level,
    required this.id_group_materi,
    required this.id_lesson,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'id_level': id_level,
      'id_group_materi': id_group_materi,
      'id_lesson': id_lesson,
    };
  }

  factory LogingHeaderRequestModel.fromMap(Map<String, dynamic> map) {
    return LogingHeaderRequestModel(
      user_id: map['user_id'] ?? '',
      id_level: map['id_level'] ?? '',
      id_group_materi: map['id_group_materi'] ?? '',
      id_lesson: map['id_lesson'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LogingHeaderRequestModel.fromJson(String source) =>
      LogingHeaderRequestModel.fromMap(json.decode(source));
}
