import 'user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final UserModel? data;
  final String? token;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
    this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'token': token,
    };
  }
}
