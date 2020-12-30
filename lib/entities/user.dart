class User {
  String name;
  String email;
  String token;
  String password;

  User({this.name, this.email, this.password, this.token});

  Map<String, String> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }

  User.fromJson(dynamic map) {
    name = map['name'];
    email = map['email'];
    token = map['token'];
    password = map['password'];
  }
}
