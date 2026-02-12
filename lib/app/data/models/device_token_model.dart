class DeviceTokenModel {
  final int? id;
  final int? userId;
  final String deviceToken;
  final String deviceType;
  final String? appVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DeviceTokenModel({
    this.id,
    this.userId,
    required this.deviceToken,
    required this.deviceType,
    this.appVersion,
    this.createdAt,
    this.updatedAt,
  });

  factory DeviceTokenModel.fromJson(Map<String, dynamic> json) {
    return DeviceTokenModel(
      id: json['id'],
      userId: json['user_id'],
      deviceToken: json['device_token'] ?? '',
      deviceType: json['device_type'] ?? '',
      appVersion: json['app_version'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_token': deviceToken,
      'device_type': deviceType,
      'app_version': appVersion,
    };
  }
}
