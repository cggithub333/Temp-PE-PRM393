class Student {
  int? id;
  String name;
  String date;
  String gender;
  String email;
  String address;
  String phone;
  int idMajor;

  Student({
    this.id,
    required this.name,
    required this.date,
    required this.gender,
    required this.email,
    required this.address,
    required this.phone,
    required this.idMajor,
  });

  Map<String, dynamic> toMap() => {
        'ID': id,
        'name': name,
        'date': date,
        'gender': gender,
        'email': email,
        'Address': address,
        'Phone': phone,
        'idMajor': idMajor,
      };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        id: map['ID'],
        name: map['name'],
        date: map['date'],
        gender: map['gender'],
        email: map['email'],
        address: map['Address'],
        phone: map['Phone'],
        idMajor: map['idMajor'],
      );
}
