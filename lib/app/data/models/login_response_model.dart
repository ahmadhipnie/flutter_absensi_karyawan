import 'user_model.dart';

class LoginResponseModel {
  final bool success;
  final String message;
  final UserModel? data;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? UserModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
