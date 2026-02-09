# Task Employee Work - API Implementation

## Required API Endpoints

For the Employee Work tab in Task Detail (Supervisor view), we need the following endpoints:

### 1. Get Task Assignments
```
GET /api/tasks/:taskId/assignments
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 8,
      "task_id": 1,
      "user_id": 2,
      "status": "completed",
      "is_submitted": true,
      "created_at": "2026-02-08T10:00:00.000Z",
      "updated_at": "2026-02-09T16:09:12.245Z",
      "user": {
        "id": 2,
        "name": "John Doe",
        "email": "john@example.com",
        "photo_profile": "profile.jpg"
      }
    }
  ]
}
```

### 2. Get Assignment Submissions (Already Implemented)
```
GET /api/tasks/assignment/:assignmentId/submissions
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "assignment_id": 8,
      "submission_type": "file",
      "file_path": "task-3-1770628152138-292544096.pdf",
      "file_name": "revisi pak nug.pdf",
      "content_url": null,
      "submitted_at": "2026-02-09T16:09:12.245Z"
    }
  ]
}
```

## Implementation Plan

1. Create TaskAssignmentModel
2. Add getTaskAssignments() to TaskService
3. Update TaskDetailController to load real data
4. Create employee submission detail view
5. Update navigation to pass assignment data
