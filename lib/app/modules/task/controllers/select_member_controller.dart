import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import '../../../data/models/user_model.dart';

class SelectMemberController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();
  
  final RxSet<int> selectedMembers = <int>{}.obs; // Store user IDs
  final RxBool allMembersSelected = false.obs;
  final isLoading = false.obs;
  final members = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  /// Fetch members from API
  Future<void> fetchMembers() async {
    try {
      isLoading.value = true;
      final result = await _chatService.getUsers();
      
      // Filter only members (not supervisors) if needed
      // Or show all users
      members.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load members');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleMember(int userId) {
    if (selectedMembers.contains(userId)) {
      selectedMembers.remove(userId);
    } else {
      selectedMembers.add(userId);
    }
    
    // Check if all members selected
    allMembersSelected.value = selectedMembers.length == members.length;
    
    // Force refresh
    selectedMembers.refresh();
  }
  
  void toggleAllMembers() {
    if (allMembersSelected.value) {
      selectedMembers.clear();
      allMembersSelected.value = false;
    } else {
      selectedMembers.clear();
      for (var member in members) {
        selectedMembers.add(member.id);
      }
      allMembersSelected.value = true;
    }
    selectedMembers.refresh();
  }

  bool isSelected(int userId) {
    return selectedMembers.contains(userId);
  }

  void confirmSelection() {
    if (selectedMembers.isEmpty) {
      Get.snackbar('Error', 'Please select at least one member');
      return;
    }
    
    // Get display names
    final selectedUsers = members
        .where((m) => selectedMembers.contains(m.id))
        .toList();
    
    String displayText;
    if (allMembersSelected.value || selectedUsers.length == members.length) {
      displayText = 'All Members (${members.length})';
    } else {
      displayText = selectedUsers.map((u) => u.displayName).take(3).join(', ');
      if (selectedUsers.length > 3) {
        displayText += ' +${selectedUsers.length - 3}';
      }
    }
    
    Get.back(result: {
      'displayText': displayText,
      'memberIds': selectedMembers.toList(),
    });
  }
}
