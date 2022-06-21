import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/common/common_button.dart';
import 'package:selfcare_diary/core/common/common_text_form_field.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/core/config/theme.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/controller/user_profile_controller.dart';

class ChangePasswordPage extends ConsumerWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    return Scaffold(
        backgroundColor: AppColors.ink[0],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            'Change Password',
            style: t16M.copyWith(
              color: AppColors.ink[500],
            ),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              CommonTextFormField(
                labelText: 'Current password',
                controller: controller.profilePasswordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonTextFormField(
                labelText: 'New password',
                controller: controller.profilePasswordNewController,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonTextFormField(
                labelText: 'Confirm new password',
                controller: controller.profilePasswordNewConfirmController,
                textInputAction: TextInputAction.done,
                obscureText: true,
              ),
              Divider(
                color: AppColors.ink[0],
              ),
              CommonButton(
                onPressed: () async {
                  var res = await controller.changePassword(context);
                  if (res) {
                    Navigator.of(context).pop();
                  }
                },
                btnController: controller.buttonController,
                child: const Text(
                  'Save',
                ),
              )
            ])));
  }
}
