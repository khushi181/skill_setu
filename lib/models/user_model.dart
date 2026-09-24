class UserModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String subject;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.subject,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'subject': subject,
    };
  }

  factory UserModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? '',
      subject: map['subject'] ?? '',
    );
  }
}