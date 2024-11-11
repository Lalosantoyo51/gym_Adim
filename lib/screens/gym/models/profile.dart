class ProfileModel {
  late String? aboutme;
  late String? youtube;
  late String? tiktok;
  late String? twitter;
  late String? insta;
  late String? logro;
  late String? img11;
  late String? img12;
  late String? logro2;
  late String? img21;
  late String? img22;
  late String? logro3;
  late String? img31;
  late String? img32;
  late int? fileid1;
  late int? fileid12;
  late int? fileid21;
  late int? fileid22;
  late int? fileid31;
  late int? fileid32;

  ProfileModel({
    this.aboutme,
    this.youtube,
    this.tiktok,
    this.twitter,
    this.insta,
    this.logro,
    this.img11,
    this.img12,
    this.logro2,
    this.img21,
    this.img22,
    this.logro3,
    this.img31,
    this.img32,
  });

  ProfileModel.fromJson(Map<String, dynamic> json)
      : aboutme = json["aboutme"],
        youtube = json["youtube"],
        tiktok = json["tiktok"],
        twitter = json["twitter"],
        insta = json["insta"],
        logro = json["logro"],
        img11 = json["img11"],
        img12 = json["img12"],
        logro2 = json["logro2"],
        img21 = json["img21"],
        img22 = json["img22"],
        logro3 = json["logro3"],
        img31 = json["img31"],
        img32 = json["img32"],
        fileid1 = json["fileid1"] ==null?null: int.parse(json["fileid1"]),
        fileid12 =json["fileid12"] ==null?null: int.parse(json["fileid12"]),
        fileid21 =json["fileid21"] ==null?null: int.parse(json["fileid21"]),
        fileid22 =json["fileid22"] ==null?null: int.parse(json["fileid22"]),
        fileid31 =json["fileid31"] ==null?null: int.parse(json["fileid31"]),
        fileid32 =json["fileid32"] ==null?null: int.parse(json["fileid32"]);

  Map toJson(int id_usuario) => {
        "aboutme": aboutme,
        "youtube": youtube,
        "tiktok": tiktok,
        "twitter": twitter,
        "insta": insta,
        "logro": logro,
        "img11": img11,
        "img12": img12,
        "logro2": logro2,
        "img21": img21,
        "img22": img22,
        "logro3": logro3,
        "img31": img31,
        "img32": img32,
        "fileid1": fileid1,
        "fileid12": fileid12,
        "fileid21": fileid21,
        "fileid22": fileid22,
        "fileid31": fileid31,
        "fileid32": fileid32,
        "id_usuario": id_usuario
      };
}
