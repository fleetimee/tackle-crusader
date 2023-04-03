import 'dart:convert';

class MasterMateriResponseModel {
  MasterMateriResponseModel({
    this.status,
    this.message,
    this.data,
  });

  String? status;
  String? message;
  List<Datum>? data;

  factory MasterMateriResponseModel.fromRawJson(String str) =>
      MasterMateriResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MasterMateriResponseModel.fromJson(Map<String, dynamic> json) =>
      MasterMateriResponseModel(
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
    this.idMateri,
    this.idLevel,
    this.idGroupMateri,
    this.urutan,
    this.latihanUrlFile,
    this.latihanTitle,
    this.latihanImage,
    this.latihanVoice,
    this.latihanCina,
    this.latihanIndonesia,
    this.materiCreateBy,
    this.materiCreateDate,
    this.materiUpdateBy,
    this.materiUpdateDate,
    this.materiIsDelete,
  });

  String? idMateri;
  String? idLevel;
  String? idGroupMateri;
  String? urutan;
  String? latihanUrlFile;
  String? latihanTitle;
  String? latihanImage;
  String? latihanVoice;
  String? latihanCina;
  String? latihanIndonesia;
  String? materiCreateBy;
  DateTime? materiCreateDate;
  String? materiUpdateBy;
  DateTime? materiUpdateDate;
  String? materiIsDelete;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idMateri: json["id_materi"],
        idLevel: json["id_level"],
        idGroupMateri: json["id_group_materi"],
        urutan: json["urutan"],
        latihanUrlFile: json["latihan_url_file"],
        latihanTitle: json["latihan_title"],
        latihanImage: json["latihan_image"],
        latihanVoice: json["latihan _voice"],
        latihanCina: json["latihan_cina"],
        latihanIndonesia: json["latihan_indonesia"],
        materiCreateBy: json["materi_create_by"],
        materiCreateDate: json["materi_create_date"] == null
            ? null
            : DateTime.parse(json["materi_create_date"]),
        materiUpdateBy: json["materi_update_by"],
        materiUpdateDate: json["materi_update_date"] == null
            ? null
            : DateTime.parse(json["materi_update_date"]),
        materiIsDelete: json["materi_is_delete"],
      );

  Map<String, dynamic> toJson() => {
        "id_materi": idMateri,
        "id_level": idLevel,
        "id_group_materi": idGroupMateri,
        "urutan": urutan,
        "latihan_url_file": latihanUrlFile,
        "latihan_title": latihanTitle,
        "latihan_image": latihanImage,
        "latihan _voice": latihanVoice,
        "latihan_cina": latihanCina,
        "latihan_indonesia": latihanIndonesia,
        "materi_create_by": materiCreateBy,
        "materi_create_date": materiCreateDate?.toIso8601String(),
        "materi_update_by": materiUpdateBy,
        "materi_update_date": materiUpdateDate?.toIso8601String(),
        "materi_is_delete": materiIsDelete,
      };
}
