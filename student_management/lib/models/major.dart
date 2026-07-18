class Major {
  int? idMajor;
  String nameMajor;

  Major({this.idMajor, required this.nameMajor});

  Map<String, dynamic> toMap() => {
        'IDMajor': idMajor,
        'nameMajor': nameMajor,
      };

  factory Major.fromMap(Map<String, dynamic> map) => Major(
        idMajor: map['IDMajor'],
        nameMajor: map['nameMajor'],
      );
}
