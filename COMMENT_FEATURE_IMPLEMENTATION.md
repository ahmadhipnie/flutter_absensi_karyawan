# Comment Feature Implementation

## Overview
This document describes the implementation of the comment feature for both member (employee) and supervisor views in the task section.

## API Endpoints

### Get Comments
- **Endpoint**: `GET /tasks/assignment/:assignmentId/comments`
- **Purpose**: Fetch all comments for a specific task assignment
- **Response**: Array of comment objects with user information

### Post Comment
- **Endpoint**: `POST /tasks/assignment/:assignmentId/comments`
- **Body**: `{ "comment_text": "string" }`
- **Purpose**: Post a new comment on a task assignment
- **Response**: The created comment object

## Implementation Details

### 1. Data Models

#### TaskCommentModel (`lib/app/data/models/task_comment_model.dart`)
```dart
class TaskCommentModel {
  final int id;
  final int assignmentId;
  final int userId;
  final String commentText;
  final DateTime createdAt;
  final String userEmail;
  final String username;
  
  // Helpers
  String get formattedTime; // Returns HH:MM format
  String get avatarUrl;     // Returns ui-avatars.com URL
}
```

#### TaskCommentResponseModel
- Wrapper for API response containing a list of TaskCommentModel

#### TaskCommentCreateResponseModel
- Wrapper for API response when creating a comment

### 2. Service Layer

#### TaskService Updates (`lib/app/data/services/task_service.dart`)

##### Get Comments
```dart
Future<List<TaskCommentModel>> getAssignmentComments({
  required int assignmentId,
})
```
- Fetches comments from GET endpoint
- Returns list of TaskCommentModel
- Includes error handling and logging

##### Post Comment
```dart
Future<TaskCommentModel> postAssignmentComment({
  required int assignmentId,
  required String commentText,
})
```
- Posts comment to POST endpoint
- Returns the created comment
- Includes error handling and logging

### 3. Member (Employee) Comment View

#### Controller: UserTaskCommentController
**File**: `lib/app/modules/task/controllers/user_task_comment_controller.dart`

**Key Features**:
- Gets `assignmentId` from navigation arguments
- Loads comments on initialization
- Posts comments via API
- Shows loading and sending states
- Converts TaskCommentModel to UI CommentModel

**Methods**:
- `loadComments()` - Fetches comments from API
- `sendComment()` - Posts new comment
- `CommentModel.fromTaskComment()` - Converts API model to UI model

**Observable States**:
- `comments` - List of comments
- `isLoading` - Loading comments state
- `isSending` - Sending comment state

#### View: UserTaskCommentView
**File**: `lib/app/modules/task/views/user_task_comment/user_task_comment_view.dart`

**UI Features**:
- Shows loading indicator while fetching comments
- Shows "No comments yet" placeholder when empty
- Displays user avatars (from ui-avatars.com)
- Disables input while sending
- Shows "Sending..." hint when posting

#### Binding: UserTaskCommentBinding
**File**: `lib/app/modules/task/bindings/user_task_comment_binding.dart`

**Dependencies**:
- Ensures TaskService is registered
- Registers UserTaskCommentController

#### Navigation
**From**: UserTaskDetailView (user_task_header.dart)
**Arguments Passed**:
```dart
Get.toNamed('/user-task-comment', arguments: {
  'assignmentId': controller.assignmentId.value,
});
```

### 4. Supervisor Comment View

#### Controller: EmployeeDetailController
**File**: `lib/app/modules/task/controllers/employee_detail_controller.dart`

**Key Features**:
- Receives `assignmentId` from navigation arguments
- Loads comments when loading employee data
- Posts private comments via API
- Shows loading and sending states
- Converts TaskCommentModel to UI CommentModel

**Methods**:
- `_loadComments()` - Fetches comments from API (called in _loadEmployeeData)
- `sendPrivateComment()` - Posts new comment
- `CommentModel.fromTaskComment()` - Converts API model to UI model

**Observable States**:
- `comments` - List of comments
- `isLoadingComments` - Loading comments state
- `isSendingComment` - Sending comment state

#### View: EmployeeDetailView
**File**: `lib/app/modules/task/views/employee_detail/employee_detail_view.dart`

**Comment Section**: EmployeeCommentsSection
**File**: `lib/app/modules/task/views/employee_detail/widgets/employee_comments_section.dart`

**UI Features**:
- Shows loading indicator while fetching comments
- Shows "No comments yet" placeholder when empty
- Displays user avatars
- Disables input while sending
- Shows "Sending..." hint when posting
- Blue send button (supervisor styling)

#### Binding: EmployeeDetailBinding
**File**: `lib/app/modules/task/bindings/employee_detail_binding.dart`

**Dependencies**:
- Ensures TaskService is registered
- Registers EmployeeDetailController

#### Navigation
**From**: TaskDetailView (via Employee Work tab)
**Arguments Passed**:
```dart
Get.toNamed('/employee-detail', arguments: {
  'assignmentId': assignment.assignmentId,
  'taskId': taskId,
  'employeeName': assignment.name,
  'taskSubject': task?.title ?? 'Task',
  'submissionDate': assignment.submittedAt,
  'status': assignment.status,
});
```

## UI/UX Considerations

### Loading States
1. **Initial Load**: Shows CircularProgressIndicator while fetching comments
2. **Empty State**: Shows "No comments yet" placeholder
3. **Sending**: Input field shows "Sending..." and is disabled

### Error Handling
- API errors shown via GetX snackbar
- Failed comment fetch: Silent failure with empty list
- Failed comment post: Error snackbar shown to user

### Avatar Display
- Uses ui-avatars.com for generating user avatars
- Shows person icon as fallback
- 40px circle avatar for comments

### Styling Differences
- **Member**: Red send button (Color(0xFFE53935))
- **Supervisor**: Blue send button (Color(0xFF0046BE))

## Testing Checklist

### Member Comments
- [ ] Navigate to task detail
- [ ] Click on comment count
- [ ] Verify comments load from API
- [ ] Verify "No comments yet" shows when empty
- [ ] Post a new comment
- [ ] Verify comment appears in list immediately
- [ ] Verify success snackbar shows
- [ ] Verify avatar displays correctly
- [ ] Test with multiple comments

### Supervisor Comments
- [ ] Navigate to employee detail
- [ ] Verify comments section shows loading
- [ ] Verify comments load from API
- [ ] Verify "No comments yet" shows when empty
- [ ] Post a private comment
- [ ] Verify comment appears in list immediately
- [ ] Verify success snackbar shows
- [ ] Verify avatar displays correctly
- [ ] Test with multiple comments

### Edge Cases
- [ ] Test with no assignmentId
- [ ] Test with network error
- [ ] Test with invalid assignmentId
- [ ] Test posting empty comment (should be blocked)
- [ ] Test rapid comment posting

## Files Modified/Created

### Created
- `lib/app/data/models/task_comment_model.dart`

### Modified
- `lib/app/data/services/task_service.dart`
- `lib/app/modules/task/controllers/user_task_comment_controller.dart`
- `lib/app/modules/task/controllers/employee_detail_controller.dart`
- `lib/app/modules/task/bindings/user_task_comment_binding.dart`
- `lib/app/modules/task/bindings/employee_detail_binding.dart`
- `lib/app/modules/task/views/user_task_comment/user_task_comment_view.dart`
- `lib/app/modules/task/views/employee_detail/employee_detail_view.dart`
- `lib/app/modules/task/views/employee_detail/widgets/employee_comments_section.dart`
- `lib/app/modules/task/views/user_task_detail/widgets/user_task_header.dart`

## API Integration Notes

1. **Comment Text Field**: The backend expects `comment_text` (snake_case) in POST body
2. **User Information**: Backend returns `username` and `userEmail` in comment objects
3. **Timestamps**: Backend returns ISO 8601 formatted `createdAt` timestamps
4. **Assignment ID**: Must be valid assignment ID, not task ID

## Future Enhancements

1. **Comment Editing**: Add ability to edit own comments
2. **Comment Deletion**: Add ability to delete own comments
3. **Comment Reactions**: Add like/reaction functionality
4. **Real-time Updates**: Add WebSocket or polling for real-time comment updates
5. **Comment Notifications**: Notify users when new comments are posted
6. **Rich Text**: Support markdown or rich text in comments
7. **Mentions**: Add @mention functionality to tag users
8. **File Attachments**: Allow attaching files to comments
