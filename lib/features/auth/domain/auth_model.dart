class AuthModel {
  final String token;
  final String role;
  final String username;

  AuthModel({required this.token, required this.role, required this.username});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['access_token'],
      role: json['role'],
      username: json['username'],
    );
  }
}
