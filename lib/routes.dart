import 'package:flutter/material.dart';
import 'package:selfcare_diary/feature/home/presentation/home_page.dart';
import 'package:selfcare_diary/feature/login/presentation/login_page.dart';
import 'package:selfcare_diary/feature/login/presentation/widget/reset_password_page.dart';
import 'package:selfcare_diary/feature/register/presentation/register_page.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/user_profile_page.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/widget/user_password_change.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/widget/user_profile_config.dart';

import 'feature/diary/presentation/diary_page.dart';

class AppRoutes {
  static const login = '/login-page';
  static const register = '/register-page';
  static const resetPassword = '/reset-password';
  static const changePassword = '/change-password';
  static const home = '/home-page';
  static const userProfile = '/user-profile';
  static const diary = '/diary';
  static const userProfileConfig = '/user-profile-config';

  AppRoutes(Type userProfileConfig);
}

class AppRouter {
  static Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Animatable<double> _tween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.linear));

        return FadeTransition(
          opacity: animation.drive(_tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _createRoute(const LoginPage());
      case AppRoutes.home:
        return _createRoute(HomePage());
      case AppRoutes.resetPassword:
        return _createRoute(const ResetPasswordPage());
      case AppRoutes.changePassword:
        return _createRoute(const ChangePasswordPage());
      case AppRoutes.register:
        return _createRoute(RegisterPage());
      case AppRoutes.diary:
        return _createRoute(DiaryPage());
      case AppRoutes.userProfile:
        return _createRoute(UserProfilePage());
      case AppRoutes.userProfileConfig:
        return _createRoute(UserProfileConfig());
    }
    return null;
  }
}
