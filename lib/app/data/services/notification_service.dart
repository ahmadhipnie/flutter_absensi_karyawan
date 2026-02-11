import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/announcement_model.dart';
import '../providers/api_provider.dart';

class NotificationService extends GetxService {
  late final ApiProvider _apiProvider;

  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();

  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    _apiProvider = Get.find<ApiProvider>();
  }

  Future<AnnouncementResponseModel?> getMyAnnouncements() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = null;

      final response = await _apiProvider.get('/announcements/my');

      if (response.statusCode == 200) {
        final announcementResponse = AnnouncementResponseModel.fromJson(response.data);

        if (announcementResponse.success) {
          return announcementResponse;
        }
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to fetch announcements';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        } else {
          errorMessage = 'Error: ${e.response!.statusCode}';
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please check your internet.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error. Check your internet.';
      }

      _errorMessage.value = errorMessage;
      throw errorMessage;
    } catch (e) {
      final errorMessage = 'An unexpected error occurred: ${e.toString()}';
      _errorMessage.value = errorMessage;
      throw errorMessage;
    } finally {
      _isLoading.value = false;
    }
  }
}
