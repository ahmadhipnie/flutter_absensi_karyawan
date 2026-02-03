part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const MAIN = _Paths.MAIN;
  static const ADD_TASK = _Paths.ADD_TASK;
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
  static const MEMBERS_LIST = '/members-list';
  static const MEMBER_DETAIL = '/member-detail';
  static const CREATE_PROFILE = '/create-profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHANGE_PASSWORD = '/change-password';
}
