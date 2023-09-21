class Registrationform {
  int? id;
  String? name;
  String? mobileno;
  String? email;
  String? pwd;

  Registrationform({this.name, this.mobileno, this.email, this.pwd, this.id});
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'mobileno': mobileno,
      'email': email,
      'password': pwd,
    };
  }

  factory Registrationform.fromMap(Map<String, dynamic> map) {
    return Registrationform(
        id: map['id'],
        name: map['name'],
        mobileno: map['mobileno'],
        email: map['email'],
        pwd: map['password']);
  }
}
