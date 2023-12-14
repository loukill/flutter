class User {
  String name;
  String? lastName;
  String? email;
  String password;
  int numTel;
  String? location;
  String? resetCode;
  String? picture;
  String role;

  User({
    required this.name,
    this.lastName,
    this.email,
    required this.password,
    required this.numTel,
    this.location,
    this.resetCode,
    this.picture,
    required this.role,
  });

  // Convert the Dart object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'email': email,
      'password': password,
      'numTel': numTel,
      'location': location,
      'resetCode': resetCode,
      'picture': picture,
      'role': role,
    };
  }

  // Create a Dart object from a JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      numTel: json['numTel'],
      location: json['location'],
      resetCode: json['resetCode'],
      picture: json['picture'],
      role: json['role'],
    );
  }

  @override
  String toString() {
    return 'User{name: $name, lastName: $lastName, email: $email, '
        'password: $password, numTel: $numTel, location: $location, '
        'resetCode: $resetCode, picture: $picture, role: $role}';
  }
}
