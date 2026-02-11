class ScheduleModel {
  final int id;
  final int departmentId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final int gracePeriodMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? departmentName; // Make nullable since update response doesn't include it

  ScheduleModel({
    required this.id,
    required this.departmentId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.gracePeriodMinutes,
    required this.createdAt,
    required this.updatedAt,
    this.departmentName, // Optional parameter
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as int,
      departmentId: json['department_id'] as int,
      shiftName: json['shift_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      gracePeriodMinutes: json['grace_period_minutes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      departmentName: json['department_name'] as String?, // Nullable cast
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department_id': departmentId,
      'shift_name': shiftName,
      'start_time': startTime,
      'end_time': endTime,
      'grace_period_minutes': gracePeriodMinutes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'department_name': departmentName,
    };
  }

  /// Format time from HH:MM:SS to HH:MM
  String get formattedStartTime {
    final parts = startTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return startTime;
  }

  /// Format time from HH:MM:SS to HH:MM
  String get formattedEndTime {
    final parts = endTime.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return endTime;
  }

  /// Get start time hour
  int get startHour {
    final parts = startTime.split(':');
    return int.parse(parts[0]);
  }

  /// Get end time hour
  int get endHour {
    final parts = endTime.split(':');
    return int.parse(parts[0]);
  }
}

class ScheduleResponseModel {
  final bool success;
  final List<ScheduleModel> data;

  ScheduleResponseModel({
    required this.success,
    required this.data,
  });

  factory ScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleResponseModel(
      success: json['success'] as bool,
      data: (json['data'] as List?)
              ?.map((item) => ScheduleModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ScheduleUpdateResponseModel {
  final bool success;
  final String message;
  final ScheduleModel data;

  ScheduleUpdateResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ScheduleUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleUpdateResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: ScheduleModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
