import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/schedule_model.dart';
import '../providers/api_provider.dart';

class ScheduleService {
  late final ApiProvider _apiProvider;

  ScheduleService() {
    // Get shared ApiProvider instance from GetX
    _apiProvider = Get.find<ApiProvider>();
  }

  /// Get all schedules
  /// GET /schedules
  Future<List<ScheduleModel>> getSchedules() async {
    try {
      print('=== GET SCHEDULES ===');

      final response = await _apiProvider.get('/schedules');

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final scheduleResponse = ScheduleResponseModel.fromJson(response.data);

        if (scheduleResponse.success) {
          print('Schedules loaded: ${scheduleResponse.data.length}');
          return scheduleResponse.data;
        }

        throw 'Failed to load schedules';
      }

      throw 'Failed to load schedules: ${response.statusCode}';
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch schedules';

      if (e.response != null) {
        print('Schedules error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Schedules error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Schedules unexpected error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Update schedule
  /// PUT /schedules/:scheduleId
  Future<ScheduleModel> updateSchedule({
    required int scheduleId,
    required String startTime,
    required String endTime,
  }) async {
    try {
      print('=== UPDATE SCHEDULE ===');
      print('Schedule ID: $scheduleId');
      print('Start Time: $startTime');
      print('End Time: $endTime');

      final response = await _apiProvider.put(
        '/schedules/$scheduleId',
        data: {
          'start_time': startTime,
          'end_time': endTime,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final updateResponse = ScheduleUpdateResponseModel.fromJson(response.data);

        if (updateResponse.success) {
          print('Schedule updated successfully');
          return updateResponse.data;
        }

        throw updateResponse.message;
      }

      throw 'Failed to update schedule: ${response.statusCode}';
    } on DioException catch (e) {
      String errorMessage = 'Failed to update schedule';

      if (e.response != null) {
        print('Update schedule error response: ${e.response!.data}');
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      } else {
        print('Update schedule error: ${e.message}');
      }

      throw errorMessage;
    } catch (e) {
      print('Update schedule unexpected error: $e');
      throw 'An error occurred: ${e.toString()}';
    }
  }
}
