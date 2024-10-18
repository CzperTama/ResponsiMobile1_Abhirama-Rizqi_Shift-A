class Registration {
  final int code;
  final bool status;
  final String? data;

  Registration({
    required this.code,
    required this.status,
    this.data,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      code: json['code'] as int,
      status: json['status'] as bool,
      data: json['data'] as String?,
    );
  }

  bool get isSuccessful => code == 200;
}