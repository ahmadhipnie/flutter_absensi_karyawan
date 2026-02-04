part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const MAIN = _Paths.MAIN;
  static const ADD_TASK = _Paths.ADD_TASK;
  static const EDIT_TASK = _Paths.EDIT_TASK;
  static const SELECT_MEMBER = _Paths.SELECT_MEMBER;
  static const TASK_DETAIL = _Paths.TASK_DETAIL;
  static const EMPLOYEE_DETAIL = _Paths.EMPLOYEE_DETAIL;
  static const USER_TASK_DETAIL = _Paths.USER_TASK_DETAIL;
  static const USER_TASK_COMMENT = _Paths.USER_TASK_COMMENT;
  static const MEMBERS_LIST = _Paths.MEMBERS_LIST;
  static const MEMBER_DETAIL = _Paths.MEMBER_DETAIL;
  static const CREATE_PROFILE = _Paths.CREATE_PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const PROFILE = _Paths.PROFILE;
  static const ATTENDANCE_LOG = _Paths.ATTENDANCE_LOG;
  static const EDIT_MY_PROFILE = _Paths.EDIT_MY_PROFILE;
  static const CHANGE_MY_PASSWORD = _Paths.CHANGE_MY_PASSWORD;
  static const ATTENDANCE = _Paths.ATTENDANCE;
  static const TAKE_ATTENDANCE = _Paths.TAKE_ATTENDANCE;
  static const ATTENDANCE_HISTORY_DETAIL = _Paths.ATTENDANCE_HISTORY_DETAIL;

  static const CREATE_DEPARTMENT = _Paths.CREATE_DEPARTMENT;
  static const EDIT_DEPARTMENT = _Paths.EDIT_DEPARTMENT;
  static const DEPARTMENT_DETAIL = _Paths.DEPARTMENT_DETAIL;
  static const DEPARTMENT_INFO = _Paths.DEPARTMENT_INFO;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const MAIN = '/main';
  static const ADD_TASK = '/add-task';
  static const EDIT_TASK = '/edit-task';
  static const SELECT_MEMBER = '/select-member';
  static const TASK_DETAIL = '/task-detail';
  static const EMPLOYEE_DETAIL = '/employee-detail';
  static const USER_TASK_DETAIL = '/user-task-detail';
  static const USER_TASK_COMMENT = '/user-task-comment';
  static const MEMBERS_LIST = '/members-list';
  static const MEMBER_DETAIL = '/member-detail';
  static const CREATE_PROFILE = '/create-profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHANGE_PASSWORD = '/change-password';
  static const PROFILE = '/profile';
  static const ATTENDANCE_LOG = '/attendance-log';
  static const EDIT_MY_PROFILE = '/edit-my-profile';
  static const CHANGE_MY_PASSWORD = '/change-my-password';
  static const ATTENDANCE = '/attendance';
  static const TAKE_ATTENDANCE = '/take-attendance';
  static const ATTENDANCE_HISTORY_DETAIL = '/attendance-history-detail';

  static const CREATE_DEPARTMENT = '/create-department';
  static const EDIT_DEPARTMENT = '/edit-department';
  static const DEPARTMENT_DETAIL = '/department-detail';
  static const DEPARTMENT_INFO = '/department-info';
}
