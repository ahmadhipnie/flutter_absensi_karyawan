part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const MAIN = _Paths.MAIN;
  static const ADD_TASK = _Paths.ADD_TASK;
  static const SELECT_MEMBER = _Paths.SELECT_MEMBER;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const MAIN = '/main';
  static const ADD_TASK = '/add-task';
  static const SELECT_MEMBER = '/select-member';
}
