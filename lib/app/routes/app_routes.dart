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
  static const MEMBERS_LIST = _Paths.MEMBERS_LIST;
  static const MEMBER_DETAIL = _Paths.MEMBER_DETAIL;
  static const CREATE_PROFILE = _Paths.CREATE_PROFILE;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
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
  static const MEMBERS_LIST = '/members-list';
  static const MEMBER_DETAIL = '/member-detail';
  static const CREATE_PROFILE = '/create-profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHANGE_PASSWORD = '/change-password';
}
