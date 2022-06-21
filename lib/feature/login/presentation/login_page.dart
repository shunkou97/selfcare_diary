import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/core/config/theme.dart';
import 'package:selfcare_diary/feature/login/presentation/controller/login_controller.dart';
import 'package:selfcare_diary/feature/login/presentation/widget/login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(loginControllerProvider).checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.ink[0],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 6),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Image(
                            image: const AssetImage('assets/images/banner.png'),
                            width: MediaQuery.of(context).size.width / 1.8,
                            color: AppColors.ink[500]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
                          style: t14M.copyWith(color: AppColors.ink[500]),
                        ),
                      ),
                    ),
                    LoginForm(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
