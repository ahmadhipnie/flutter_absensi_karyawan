import 'package:get/get.dart';

class CreateAnnouncementController extends GetxController {
  final subjectController = ''.obs;
  final messageController = ''.obs;
  
  // Selected members list
  final selectedMembers = <Map<String, dynamic>>[].obs;
  
  // Dummy members data for selection
  final allMembers = [
    {'id': '1', 'name': 'Karina', 'avatar': 'https://ui-avatars.com/api/?name=Karina&background=random', 'isSelected': true},
    {'id': '2', 'name': 'Lee Jae Wook', 'avatar': 'https://ui-avatars.com/api/?name=Lee+Jae+Wook&background=random', 'isSelected': false},
    {'id': '3', 'name': 'Budi', 'avatar': 'https://ui-avatars.com/api/?name=Budi&background=random', 'isSelected': true},
    {'id': '4', 'name': 'Gerald P', 'avatar': 'https://ui-avatars.com/api/?name=Gerald+P&background=random', 'isSelected': true},
  ].obs;

  void toggleMemberSelection(int index) {
    var member = allMembers[index];
    member['isSelected'] = !(member['isSelected'] as bool);
    allMembers[index] = member;
    updateSelectedMembers();
  }

  void updateSelectedMembers() {
    selectedMembers.value = allMembers.where((m) => m['isSelected'] == true).toList();
  }

  String get notifyToText {
    if (selectedMembers.isEmpty) return 'Select Members';
    if (selectedMembers.length == allMembers.length) return 'All Member';
    return '${selectedMembers.length} Members Selected';
  }

  void postAnnouncement() {
    // Implement post logic
    Get.back();
    Get.snackbar('Success', 'Announcement posted successfully');
  }

  @override
  void onInit() {
    super.onInit();
    updateSelectedMembers();
  }
}
