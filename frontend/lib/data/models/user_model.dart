class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // admin | sales_staff
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.token,
  });

  bool get isAdmin => role == 'admin';

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    role: json['role'],
    token: json['token'],
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'email': email, 'role': role,
  };
}
