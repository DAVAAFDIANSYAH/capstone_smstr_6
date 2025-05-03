import 'package:get/get.dart';

import '../modules/ArtScan/bindings/art_scan_binding.dart';
import '../modules/ArtScan/views/art_scan_view.dart';
import '../modules/Dashboard/bindings/dashboard_binding.dart';
import '../modules/Dashboard/views/dashboard_view.dart';
import '../modules/Login/bindings/login_binding.dart';
import '../modules/Login/views/login_view.dart';
import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/Register/bindings/register_binding.dart';
import '../modules/Register/views/register_view.dart';
import '../modules/WaveClipper/bindings/wave_clipper_binding.dart';
import '../modules/WaveClipper/views/wave_clipper_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/tutorial/bindings/tutorial_binding.dart';
import '../modules/tutorial/views/tutorial_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => Register(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => Dashboard(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => Profile(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ART_SCAN,
      page: () => ARTScan(),
      binding: ArtScanBinding(),
    ),
    // GetPage(
    //   name: _Paths.WAVE_CLIPPER,
    //   page: () =>  WaveClipper(),
    //   binding: WaveClipperBinding(),
    // ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => Onboarding(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.TUTORIAL,
      page: () =>  Tutorial(),
      binding: TutorialBinding(),
    ),
  ];
}
