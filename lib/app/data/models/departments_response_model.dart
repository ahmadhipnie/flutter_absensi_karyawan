import 'department_model.dart';

class DepartmentsResponseModel {
  final bool success;
  final List<DepartmentModel> data;

  DepartmentsResponseModel({
    required this.success,
    required this.data,
  });

  factory DepartmentsResponseModel.fromJson(Map<String, dynamic> json) {
    return DepartmentsResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List<dynamic>)
          .map((item) => DepartmentModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
