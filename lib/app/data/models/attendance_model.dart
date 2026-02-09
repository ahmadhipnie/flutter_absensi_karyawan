class AttendanceModel {
  final int id;
  final int userId;
  final int? scheduleId;
  final DateTime date;
  final DateTime? clockIn;
  final String? clockInLat;
  final String? clockInLong;
  final String? clockInImage;
  final DateTime? clockOut;
  final String? clockOutLat;
  final String? clockOutLong;
  final String? clockOutImage;
  final String status;
  final int lateDuration;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Additional fields for supervisor view
  final String? email;
  final String? username;

  AttendanceModel({
    required this.id,
    required this.userId,
    this.scheduleId,
    required this.date,
    this.clockIn,
    this.clockInLat,
    this.clockInLong,
    this.clockInImage,
    this.clockOut,
    this.clockOutLat,
    this.clockOutLong,
    this.clockOutImage,
    required this.status,
    required this.lateDuration,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.username,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      scheduleId: json['schedule_id'] as int?,
      date: DateTime.parse(json['date'] as String),
      clockIn: json['clock_in'] != null ? DateTime.parse(json['clock_in'] as String) : null,
      clockInLat: json['clock_in_lat'] as String?,
      clockInLong: json['clock_in_long'] as String?,
      clockInImage: json['clock_in_image'] as String?,
      clockOut: json['clock_out'] != null ? DateTime.parse(json['clock_out'] as String) : null,
      clockOutLat: json['clock_out_lat'] as String?,
      clockOutLong: json['clock_out_long'] as String?,
      clockOutImage: json['clock_out_image'] as String?,
      status: json['status'] as String,
      lateDuration: json['late_duration'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      email: json['email'] as String?,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'schedule_id': scheduleId,
      'date': date.toIso8601String(),
      'clock_in': clockIn?.toIso8601String(),
      'clock_in_lat': clockInLat,
      'clock_in_long': clockInLong,
      'clock_in_image': clockInImage,
      'clock_out': clockOut?.toIso8601String(),
      'clock_out_lat': clockOutLat,
      'clock_out_long': clockOutLong,
      'clock_out_image': clockOutImage,
      'status': status,
      'late_duration': lateDuration,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'email': email,
      'username': username,
    };
  }

  /// Check if user has checked in today
  bool get hasCheckedIn => clockIn != null;

  /// Check if user has checked out today
  bool get hasCheckedOut => clockOut != null;

  /// Get formatted clock in time
  String get clockInTime {
    if (clockIn == null) return '-';
    return '${clockIn!.hour.toString().padLeft(2, '0')}:${clockIn!.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted clock out time
  String get clockOutTime {
    if (clockOut == null) return '-';
    return '${clockOut!.hour.toString().padLeft(2, '0')}:${clockOut!.minute.toString().padLeft(2, '0')}';
  }
}
