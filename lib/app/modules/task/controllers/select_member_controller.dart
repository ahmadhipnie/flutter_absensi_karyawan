import 'package:get/get.dart';

class SelectMemberController extends GetxController {
  final RxSet<String> selectedMembers = <String>{}.obs;
  final RxBool allMembersSelected = false.obs;

  final List<Map<String, dynamic>> members = [
    {
      'id': 'all',
      'name': 'All Member',
      'avatarColor': 0xFF0046BE,
      'avatarText': 'AM',
    },
    {
      'id': '1',
      'name': 'John Doe',
      'avatarColor': 0xFF4CAF50,
      'avatarText': 'JD',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'avatarColor': 0xFF2196F3,
      'avatarText': 'JS',
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'avatarColor': 0xFFFF9800,
      'avatarText': 'MJ',
    },
    {
      'id': '4',
      'name': 'Sarah Williams',
      'avatarColor': 0xFF9C27B0,
      'avatarText': 'SW',
    },
    {
      'id': '5',
      'name': 'David Brown',
      'avatarColor': 0xFFF44336,
      'avatarText': 'DB',
    },
  ];

  void toggleMember(String id) {
    if (id == 'all') {
      if (allMembersSelected.value) {
        selectedMembers.clear();
        allMembersSelected.value = false;
      } else {
        for (var member in members) {
          if (member['id'] != 'all') {
            selectedMembers.add(member['id'] as String);
          }
        }
        allMembersSelected.value = true;
      }
    } else {
      if (selectedMembers.contains(id)) {
        selectedMembers.remove(id);
      } else {
        selectedMembers.add(id);
      }
      allMembersSelected.value = selectedMembers.length == members.length - 1;
    }
  }

  bool isSelected(String id) {
    if (id == 'all') {
      return allMembersSelected.value;
    }
    return selectedMembers.contains(id);
  }

  void confirmSelection() {
    if (allMembersSelected.value) {
      Get.back(result: 'All Member');
    } else {
      final names = members
          .where((m) => selectedMembers.contains(m['id']))
          .map((m) => m['name'] as String)
          .join(', ');
      Get.back(result: names.isEmpty ? 'All Member' : names);
    }
  }
}
