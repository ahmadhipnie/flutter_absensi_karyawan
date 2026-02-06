import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/chat_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

class NewChatController extends GetxController {
  final ChatService _chatService = Get.find<ChatService>();

  // Lazy initialization of AuthService
  AuthService? get _authService {
    try {
      return Get.find<AuthService>();
    } catch (e) {
      return null;
    }
  }

  final searchController = TextEditingController();
  final members = <UserModel>[].obs; // All members except current user (for personal chat)
  final allMembers = <UserModel>[].obs; // All members including current user (for group creation)
  final filteredMembers = <UserModel>[].obs;
  final isLoading = false.obs;
  final isCreatingChat = false.obs;
  final searchQuery = ''.obs;
  
  // For group creation
  final selectedMembers = <int>[].obs;
  final groupTitleController = TextEditingController();
  final groupDescriptionController = TextEditingController();

  // Get current user ID to exclude from member list
  int? get currentUserId {
    final user = _authService?.currentUser;
    return user?.id;
  }
  
  // Check if current user is supervisor
  bool get isSupervisor {
    final user = _authService?.currentUser;
    return user?.role == 'supervisor';
  }

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

      // Store all members (for group creation)
      allMembers.assignAll(result);

      // Filter out current user from the list (for personal chat)
      final filtered = result.where((m) => m.id != currentUserId).toList();

      members.assignAll(filtered);
      filteredMembers.assignAll(filtered);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load members');
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    if (value.isEmpty) {
      filteredMembers.assignAll(members);
    } else {
      final query = value.toLowerCase();
      filteredMembers.assignAll(members.where((m) {
        return (m.username?.toLowerCase().contains(query) ?? false) ||
               m.email.toLowerCase().contains(query);
      }).toList());
    }
  }

  /// Start a personal chat with a member
  /// Creates a conversation via API, then navigates to chat detail
  Future<void> startPersonalChat(UserModel member) async {
    try {
      isCreatingChat.value = true;

      // Create conversation via API
      // Title is automatically set to member's name
      final response = await _chatService.createPrivateConversation(
        userId: member.id,
        title: member.displayName,
      );

      if (response != null && response.data != null) {
        final conversation = response.data!;

        // Use member's display name since user explicitly selected this member
        Get.toNamed(
          Routes.CHAT_DETAIL,
          arguments: {
            'chatId': conversation.id.toString(),
            'name': member.displayName,
            'type': conversation.type,
            'avatarUrl': member.avatarUrl,
            'conversation': conversation,
          },
        );
      } else {
        Get.snackbar('Error', 'Failed to create conversation');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreatingChat.value = false;
    }
  }

  void createNewGroup() {
    Get.snackbar('Coming Soon', 'Group chat creation is not implemented yet.');
  }
  
  /// Show create group modal
  void showCreateGroupModal() {
    // Reset form
    groupTitleController.clear();
    groupDescriptionController.clear();
    selectedMembers.clear();
    
    Get.dialog(
      _CreateGroupModal(controller: this),
      barrierDismissible: false,
    );
  }
  
  /// Toggle member selection for group
  void toggleMemberSelection(int userId) {
    if (selectedMembers.contains(userId)) {
      selectedMembers.remove(userId);
    } else {
      selectedMembers.add(userId);
    }
    
    // Force refresh to trigger Obx rebuild
    selectedMembers.refresh();
  }
  
  /// Create group conversation
  Future<void> createGroup() async {
    // Validation
    if (groupTitleController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter group title');
      return;
    }
    
    if (selectedMembers.length < 2) {
      Get.snackbar('Error', 'Please select at least 2 members');
      return;
    }
    
    try {
      isCreatingChat.value = true;
      
      // Include current user in participant list
      final participantIds = [...selectedMembers.toList()];
      if (currentUserId != null && !participantIds.contains(currentUserId)) {
        participantIds.add(currentUserId!);
      }
      
      final response = await _chatService.createGroupConversation(
        title: groupTitleController.text.trim(),
        description: groupDescriptionController.text.trim().isEmpty 
            ? null 
            : groupDescriptionController.text.trim(),
        participantIds: participantIds,
      );
      
      if (response != null && response.data != null) {
        final conversation = response.data!;
        
        // Close modal
        Get.back();
        
        // Navigate to chat detail
        Get.toNamed(
          Routes.CHAT_DETAIL,
          arguments: {
            'chatId': conversation.id.toString(),
            'name': conversation.title ?? 'Group Chat',
            'type': conversation.type,
            'conversation': conversation,
          },
        );
      } else {
        Get.snackbar('Error', 'Failed to create group');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isCreatingChat.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    groupTitleController.dispose();
    groupDescriptionController.dispose();
    super.onClose();
  }
}

/// Modal widget for creating group
class _CreateGroupModal extends StatelessWidget {
  final NewChatController controller;
  
  const _CreateGroupModal({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF003AE6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Create New Group',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            
            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Title
                    const Text(
                      'Group Title *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.groupTitleController,
                      decoration: InputDecoration(
                        hintText: 'Enter group title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Group Description
                    const Text(
                      'Description (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.groupDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter group description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Members Selection
                    const Text(
                      'Select Members * (min. 2)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Obx(() {
                      final selectedCount = controller.selectedMembers.length;
                      final totalWithYou = selectedCount + 1; // +1 for current user
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$selectedCount member${selectedCount == 1 ? '' : 's'} selected',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          if (selectedCount > 0)
                            Text(
                              'Total: $totalWithYou member${totalWithYou == 1 ? '' : 's'} (including you)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      );
                    }),
                    
                    const SizedBox(height: 12),
                    
                    // Member List
                    Container(
                      constraints: const BoxConstraints(maxHeight: 250),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() {
                        // Get all members except current user for selection
                        final availableMembers = controller.allMembers
                            .where((m) => m.id != controller.currentUserId)
                            .toList();
                        
                        if (availableMembers.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('No members available'),
                            ),
                          );
                        }
                        
                        // Get selected members to trigger rebuild
                        final selectedIds = controller.selectedMembers.toList();
                        
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: availableMembers.length,
                          itemBuilder: (context, index) {
                            final member = availableMembers[index];
                            final isSelected = selectedIds.contains(member.id);
                            
                            return CheckboxListTile(
                              value: isSelected,
                              onChanged: (value) {
                                controller.toggleMemberSelection(member.id);
                              },
                              title: Text(
                                member.displayName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                member.email,
                                style: const TextStyle(fontSize: 12),
                              ),
                              secondary: CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(member.avatarUrl),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            
            // Footer Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isCreatingChat.value
                          ? null
                          : controller.createGroup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003AE6),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: controller.isCreatingChat.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Create Group',
                              style: TextStyle(color: Colors.white),
                            ),
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
