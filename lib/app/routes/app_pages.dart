import 'package:get/get.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/task/bindings/add_task_binding.dart';
import '../modules/task/bindings/select_member_binding.dart';
import '../modules/task/bindings/task_detail_binding.dart';
import '../modules/task/bindings/employee_detail_binding.dart';
import '../modules/task/bindings/user_task_detail_binding.dart';
import '../modules/task/views/add_task/add_task_view.dart';
import '../modules/task/views/select_member/select_member_view.dart';
import '../modules/task/views/detail_task/task_detail_view.dart';
import '../modules/task/views/employee_detail/employee_detail_view.dart';
import '../modules/task/views/user_task_detail/user_task_detail_view.dart';
import '../modules/members/bindings/members_binding.dart';
import '../modules/members/views/members_list_view.dart';
import '../modules/members/views/member_detail_view.dart';
import '../modules/members/views/create_profile_view.dart';
import '../modules/members/views/edit_profile_view.dart';
import '../modules/members/views/change_password_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/attendance_log_view.dart';
import '../modules/profile/views/edit_profile_view.dart' as profile_edit;
import '../modules/department/bindings/department_binding.dart';
import '../modules/department/views/create_department_view.dart';
import '../modules/department/views/department_detail_view.dart';
import '../modules/department/views/edit_department_view.dart';
import '../modules/department/views/department_info_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TASK,
      page: () => const AddTaskView(),
      binding: AddTaskBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_TASK,
      page: () => const AddTaskView(),
      binding: AddTaskBinding(),
    ),
    GetPage(
      name: _Paths.SELECT_MEMBER,
      page: () => const SelectMemberView(),
      binding: SelectMemberBinding(),
    ),
    GetPage(
      name: _Paths.TASK_DETAIL,
      page: () => const TaskDetailView(),
      binding: TaskDetailBinding(),
    ),
    GetPage(
      name: _Paths.EMPLOYEE_DETAIL,
      page: () => const EmployeeDetailView(),
      binding: EmployeeDetailBinding(),
    ),
    GetPage(
      name: _Paths.USER_TASK_DETAIL,
      page: () => const UserTaskDetailView(),
      binding: UserTaskDetailBinding(),
    ),
    GetPage(
      name: _Paths.MEMBERS_LIST,
      page: () => const MembersListView(),
      binding: MembersBinding(),
    ),
    GetPage(name: _Paths.MEMBER_DETAIL, page: () => const MemberDetailView()),
    GetPage(name: _Paths.CREATE_PROFILE, page: () => const CreateProfileView()),
    GetPage(name: _Paths.EDIT_PROFILE, page: () => const EditProfileView()),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
    ),
    // Profile Routes
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_LOG,
      page: () => const AttendanceLogView(),
    ),
    GetPage(
      name: _Paths.EDIT_MY_PROFILE,
      page: () => const profile_edit.EditProfileView(),
      binding: ProfileBinding(),
    ),
    
    // Department Routes
    GetPage(
      name: _Paths.CREATE_DEPARTMENT,
      page: () => const CreateDepartmentView(),
      binding: DepartmentBinding(),
    ),
    GetPage(
      name: _Paths.DEPARTMENT_DETAIL,
      // Pass binding? It uses DepartmentController.
      // Usually better to have binding in detail if it's entry point, 
      // but if we navigated from list, controller might be there.
      // Assuming standalone or shared controller.
      page: () => const DepartmentDetailView(),
      binding: DepartmentBinding(),
    ),
    GetPage(
      name: _Paths.DEPARTMENT_INFO,
      page: () => const DepartmentInfoView(),
      binding: DepartmentBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_DEPARTMENT,
      page: () => const EditDepartmentView(),
      binding: DepartmentBinding(),
    ),
  ];
}
