import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'dart:io';
import '../models/attendance_model.dart';
import '../providers/api_provider.dart';

class AttendanceService extends GetxService {
  late final ApiProvider _apiProvider;

  @override
  void onInit() {
    super.onInit();
    _apiProvider = Get.find<ApiProvider>();
  }

  /// Check-in attendance
  /// POST /attendances/check-in
  Future<AttendanceModel?> checkIn({
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      print('Sending check-in request...');
      final response = await _apiProvider.post(
        '/attendances/check-in',
        data: formData,
      );

      print('Check-in response status: ${response.statusCode}');
      print('Check-in response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Handle both cases: data['data'] exists or data is the attendance directly
        if (data['success'] == true) {
          if (data['data'] != null) {
            print('Parsing attendance model from data...');
            try {
              final attendanceModel = AttendanceModel.fromJson(data['data']);
              print(
                'Attendance model parsed successfully: ${attendanceModel.id}',
              );
              return attendanceModel;
            } catch (e) {
              print('Error parsing attendance model: $e');
              throw 'Failed to parse attendance data: $e';
            }
          } else if (data['attendance'] != null) {
            // Some APIs return 'attendance' instead of 'data'
            return AttendanceModel.fromJson(data['attendance']);
          } else {
            // If success but no nested data, the response might be the attendance itself
            print(
              'Success but data structure unexpected, returning success anyway',
            );
            // Return a dummy model to indicate success
            return AttendanceModel.fromJson({
              'id': 1,
              'user_id': 1,
              'date': DateTime.now().toIso8601String(),
              'clock_in': DateTime.now().toIso8601String(),
              'status': 'present',
              'late_duration': 0,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            });
          }
        }
      }

      print('Check-in failed: returning null');
      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to check in';

      if (e.response != null) {
        print('Check-in error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw errorMessage;
    } catch (e) {
      print('Check-in error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Check-out attendance
  /// POST /attendances/check-out
  Future<AttendanceModel?> checkOut({
    required double latitude,
    required double longitude,
    required File imageFile,
  }) async {
    try {
      final formData = FormData.fromMap({
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      print('Sending check-out request...');
      final response = await _apiProvider.post(
        '/attendances/check-out',
        data: formData,
      );

      print('Check-out response status: ${response.statusCode}');
      print('Check-out response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Handle both cases: data['data'] exists or data is the attendance directly
        if (data['success'] == true) {
          if (data['data'] != null) {
            return AttendanceModel.fromJson(data['data']);
          } else if (data['attendance'] != null) {
            // Some APIs return 'attendance' instead of 'data'
            return AttendanceModel.fromJson(data['attendance']);
          } else {
            // If success but no nested data, the response might be the attendance itself
            print(
              'Success but data structure unexpected, returning success anyway',
            );
            // Return a dummy model to indicate success
            return AttendanceModel.fromJson({
              'id': 1,
              'user_id': 1,
              'date': DateTime.now().toIso8601String(),
              'clock_in': DateTime.now().toIso8601String(),
              'clock_out': DateTime.now().toIso8601String(),
              'status': 'present',
            });
          }
        }
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to check out';

      if (e.response != null) {
        print('Check-out error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw errorMessage;
    } catch (e) {
      print('Check-out error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Get today's attendance status
  /// GET /attendances/today
  Future<AttendanceModel?> getTodayAttendance() async {
    try {
      final response = await _apiProvider.get('/attendances/today');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return AttendanceModel.fromJson(data['data']);
        }
      }

      return null;
    } catch (e) {
      // Silent fail - return null if no attendance today
      return null;
    }
  }

  /// Get all my attendances (for history/report)
  /// GET /attendances/my
  /// Optional filters: startDate, endDate, status
  Future<List<AttendanceModel>> getMyAttendances({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{};

      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _apiProvider.get(
        '/attendances/my',
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final List attendanceList = data['data'];
          return attendanceList
              .map((json) => AttendanceModel.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error fetching my attendances: $e');
      return [];
    }
  }

  /// Get all attendances (for supervisor)
  /// GET /attendances
  /// Returns all employee attendances with user info
  Future<List<AttendanceModel>> getAllAttendances() async {
    try {
      final response = await _apiProvider.get('/attendances');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          final List attendanceList = data['data'];
          return attendanceList
              .map((json) => AttendanceModel.fromJson(json))
              .toList();
        }
      }

      return [];
    } catch (e) {
      print('Error fetching all attendances: $e');
      return [];
    }
  }
}
