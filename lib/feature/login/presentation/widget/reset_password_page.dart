import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/common/common_button.dart';
import 'package:selfcare_diary/core/common/common_snack_bar.dart';
import 'package:selfcare_diary/core/common/common_text_form_field.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/core/config/theme.dart';
import 'package:selfcare_diary/feature/login/presentation/controller/login_controller.dart';

class ResetPasswordPage extends ConsumerWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(loginControllerProvider);

    final appBar = AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              ref.read(controller.isSendEmail.state).state = false;
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)));

    final body = SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.ink[0],
      child: ref.watch(controller.isSendEmail)
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 1500),
              transitionBuilder: (Widget child, Animation<double> animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Center(
                child: Column(
                  children: [
                    const Image(image: AssetImage('email.png')),
                    const SizedBox(height: 24),
                    Text('Check email',
                        style: t30M.copyWith(color: AppColors.ink[500])),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 136,
                      child: Text(
                        'A recovery email has been sent to your email address. Please check your email.',
                        style: t14M.copyWith(color: AppColors.ink[400]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset password',
                  style: t30M.copyWith(color: AppColors.ink[500]),
                ),
                const SizedBox(height: 16),
                Text(
                  'Enter the email address your account is registered with. The recovery email will be sent to that email address.',
                  style: t16M.copyWith(color: AppColors.ink[400]),
                ),
                const SizedBox(height: 24),
                CommonTextFormField(
                  controller: controller.emailResetController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 8),
                CommonButton(
                  onPressed: () {
                    if (!controller
                        .isEmail(controller.emailResetController.text)) {
                      CommonSnackbar.show(context,
                          type: SnackbarType.warning,
                          message: 'Incorrect email');
                    } else {
                      controller.resetPassword(
                          context, controller.emailResetController.text);
                    }
                    controller.buttonResetPassController.reset();
                  },
                  btnController: controller.buttonResetPassController,
                  child: const Text(
                    'Send email',
                    style: t16M,
                  ),
                ),
              ],
            ),
    ));

    return WillPopScope(
      onWillPop: () async {
        ref.read(controller.isSendEmail.state).state = false;
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.ink[0],
        appBar: appBar,
        body: body,
      ),
    );
  }
}
