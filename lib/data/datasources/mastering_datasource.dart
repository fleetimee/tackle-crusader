import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_huixin_app/data/models/mastering/master_group_materi_response_model.dart';
import 'package:flutter_huixin_app/data/models/mastering/master_level_response_model.dart';
import 'package:flutter_huixin_app/data/models/mastering/master_materi_response_model.dart';
import 'package:flutter_huixin_app/data/models/mastering/master_soal_response_model.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import '../../common/constants/api.dart';
import '../models/mastering/master_lesson_response_model.dart';
import 'local/app_secure_storage.dart';

class MasteringDatasource {
  HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);
  Future<String> getToken() async {
    final token = await AppSecureStorage.getAccessToken();
    return 'token_api=$token';
  }

  Future<Either<String, MasterLevelResponseModel>> getMasterLevel(
      String userId) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppApi.baseUrl}/api_level?${await getToken()}&user_id=$userId'));
      return Right(
        MasterLevelResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, MasterLessonResponseModel>> getMasterLesson(
      String userId, String levelId) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppApi.baseUrl}/api_lesson?${await getToken()}&user_id=$userId&id_level=$levelId'));
      return Right(
        MasterLessonResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, MasterGroupMateriResponseModel>> getMasterGroupMateri(
    String userId,
    String levelId,
    String lessonId,
  ) async {
    try {
      final response = await http.get(Uri.parse(
          '${AppApi.baseUrl}/api_group_materi?${await getToken()}&user_id=$userId&id_level=$levelId&id_lesson=$lessonId'));
      return Right(
        MasterGroupMateriResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, MasterMateriResponseModel>> getMasterMateri(
      String userId, String idLevel, String idGroupMateri) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppApi.baseUrl}/api_materi?${await getToken()}&user_id=$userId&id_level=$idLevel&id_group_materi=$idGroupMateri'),
      );
      return Right(
        MasterMateriResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, MasterSoalResponseModel>> getMasterSoal(
      String userId, String idLevel, String idGroupMateri) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppApi.baseUrl}/api_soal?${await getToken()}&user_id=$userId&id_level=$idLevel&id_group_materi=$idGroupMateri'),
      );
      return Right(
        MasterSoalResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, MasterMateriResponseModel>> getMasterMateriSpeaking(
      String userId, String idLevel, String idGroupMateri) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppApi.baseUrl}/api_materi_speaking?${await getToken()}&user_id=$userId&id_level=$idLevel&id_group_materi=$idGroupMateri'),
      );
      return Right(
        MasterMateriResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, MasterSoalResponseModel>> getMasterSoalSpeaking(
      String userId, String idLevel, String idGroupMateri) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${AppApi.baseUrl}/api_soal_speaking?${await getToken()}&user_id=$userId&id_level=$idLevel&id_group_materi=$idGroupMateri'),
      );
      return Right(
        MasterSoalResponseModel.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
