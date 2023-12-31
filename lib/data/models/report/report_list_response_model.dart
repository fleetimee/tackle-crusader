import 'dart:convert';

class ReportListResponseModel {
  ReportListResponseModel({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<Datum>? data;

  factory ReportListResponseModel.fromRawJson(String str) =>
      ReportListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportListResponseModel.fromJson(Map<String, dynamic> json) =>
      ReportListResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.idLevel,
    this.name,
    this.levelCreateBy,
    this.levelCreateDate,
    this.levelUpdateBy,
    this.levelUpdateDate,
    this.imgUrl,
    this.imgFile,
    this.levelIsDelete,
    this.reportReading,
    this.reportSpeaking,
  });

  String? idLevel;
  String? name;
  String? levelCreateBy;
  DateTime? levelCreateDate;
  String? levelUpdateBy;
  DateTime? levelUpdateDate;
  String? imgUrl;
  String? imgFile;
  String? levelIsDelete;
  List<ReportIng>? reportReading;
  List<ReportIng>? reportSpeaking;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idLevel: json["id_level"],
        name: json["name"],
        levelCreateBy: json["level_create_by"],
        levelCreateDate: json["level_create_date"] == null
            ? null
            : DateTime.parse(json["level_create_date"]),
        levelUpdateBy: json["level_update_by"],
        levelUpdateDate: json["level_update_date"] == null
            ? null
            : DateTime.parse(json["level_update_date"]),
        imgUrl: json["img_url"],
        imgFile: json["img_file"],
        levelIsDelete: json["level_is_delete"],
        reportReading: json["report_reading"] == null
            ? []
            : List<ReportIng>.from(
                json["report_reading"]!.map((x) => ReportIng.fromJson(x))),
        reportSpeaking: json["report_speaking"] == null
            ? []
            : List<ReportIng>.from(
                json["report_speaking"]!.map((x) => ReportIng.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_level": idLevel,
        "name": name,
        "level_create_by": levelCreateBy,
        "level_create_date": levelCreateDate?.toIso8601String(),
        "level_update_by": levelUpdateBy,
        "level_update_date": levelUpdateDate?.toIso8601String(),
        "img_url": imgUrl,
        "img_file": imgFile,
        "level_is_delete": levelIsDelete,
        "report_reading": reportReading == null
            ? []
            : List<dynamic>.from(reportReading!.map((x) => x.toJson())),
        "report_speaking": reportSpeaking == null
            ? []
            : List<dynamic>.from(reportSpeaking!.map((x) => x.toJson())),
      };
}

class ReportIng {
  ReportIng({
    this.idLevel,
    this.levelName,
    this.userId,
    this.jawabanBenar,
    this.jmlSoal,
    this.nilai,
  });

  String? idLevel;
  String? levelName;
  String? userId;
  String? jawabanBenar;
  String? jmlSoal;
  String? nilai;

  factory ReportIng.fromRawJson(String str) =>
      ReportIng.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReportIng.fromJson(Map<String, dynamic> json) => ReportIng(
        idLevel: json["id_level"],
        levelName: json["level_name"],
        userId: json["user_id"],
        jawabanBenar: json["jawaban_benar"],
        jmlSoal: json["jml_soal"],
        nilai: json["nilai"],
      );

  Map<String, dynamic> toJson() => {
        "id_level": idLevel,
        "level_name": levelName,
        "user_id": userId,
        "jawaban_benar": jawabanBenar,
        "jml_soal": jmlSoal,
        "nilai": nilai,
      };
}
