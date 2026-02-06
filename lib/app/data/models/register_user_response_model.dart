import 'user_model.dart';

class RegisterUserResponseModel {
  final bool success;
  final String message;
  final UserModel data;

  RegisterUserResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterUserResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}
