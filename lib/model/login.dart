class Login {
  final int code;
  final bool status;
  final String? token;
  final int? userId;
  final String? userEmail;

  Login({
    required this.code,
    required this.status,
    this.token,
    this.userId,
    this.userEmail,
  });

  factory Login.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final user = data?['user'] as Map<String, dynamic>?;

    return Login(
      code: json['code'] as int,
      status: json['status'] as bool,
      token: data?['token'] as String?,
      userId: user != null ? int.tryParse(user['id'].toString()) : null,
      userEmail: user?['email'] as String?,
    );
  }

  bool get isSuccessful => code == 200;

  get data => null;
}