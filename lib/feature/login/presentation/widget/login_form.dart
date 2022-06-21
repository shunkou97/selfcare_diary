import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/common/common_button.dart';
import 'package:selfcare_diary/core/common/common_snack_bar.dart';
import 'package:selfcare_diary/core/common/common_text_form_field.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/core/config/theme.dart';
import 'package:selfcare_diary/feature/login/presentation/controller/login_controller.dart';
import 'package:selfcare_diary/routes.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32.0),
            CommonTextFormField(
              labelText: 'Username',
              controller: controller.usernameController,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 8),
            CommonTextFormField(
              labelText: 'Password',
              controller: controller.passwordController,
              textInputAction: TextInputAction.done,
              suffixIcon: GestureDetector(
                onTap: () {
                  ref.read(controller.isObscureText.state).state =
                      !ref.read(controller.isObscureText.state).state;
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: ref.watch(controller.isObscureText)
                        ? const Icon(Icons.visibility_off, size: 24)
                        : const Icon(Icons.visibility, size: 24)),
              ),
              sufflixBoxConstrains:
                  const BoxConstraints(maxHeight: 24, maxWidth: 24),
              obscureText: ref.watch(controller.isObscureText),
            ),
            const SizedBox(height: 16),
            CommonButton(
              onPressed: () async {
                if (controller.passwordController.text.isEmpty) {
                  CommonSnackbar.show(context,
                      type: SnackbarType.warning,
                      message: 'Password cannot be empty');
                } else if (!controller
                    .isEmail(controller.usernameController.text)) {
                  CommonSnackbar.show(context,
                      type: SnackbarType.warning, message: 'Incorrect email');
                } else if (controller.usernameController.text.isEmpty) {
                  CommonSnackbar.show(context,
                      type: SnackbarType.warning,
                      message: 'Username cannot be empty');
                } else {
                  var loginRes = await controller.doLogin(context,
                      email: controller.usernameController.text,
                      password: controller.passwordController.text);
                  if (!loginRes['status']) {
                    CommonSnackbar.show(context,
                        type: SnackbarType.warning,
                        message: 'Incorrect password');
                  } else {}
                }
                controller.buttonController.reset();
              },
              btnController: controller.buttonController,
              child: const Text(
                'Login',
                style: t16M,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.resetPassword);
                },
                child: Text(
                  'Forget password?',
                  style: t14M.apply(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {},
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Have no account?',
                        style: t14M.apply(color: AppColors.ink[400])),
                    const WidgetSpan(child: SizedBox(width: 4)),
                    WidgetSpan(
                        child: GestureDetector(
                            onTap: () => Navigator.pushNamed(
                                context, AppRoutes.register),
                            child: Text('SignUp',
                                style: t14M.apply(color: AppColors.primary))))
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
