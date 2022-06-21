import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/common/common_button.dart';
import 'package:selfcare_diary/core/common/common_snack_bar.dart';
import 'package:selfcare_diary/core/common/common_text_form_field.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/core/config/theme.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/controller/user_profile_controller.dart';

class UserProfileConfig extends ConsumerWidget {
  const UserProfileConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    controller.getUserEmail();
    controller.getUserName();
    return WillPopScope(
      onWillPop: () async {
        ref.read(controller.imageUrl.state).state = '';
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            backgroundColor: AppColors.ink[0],
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: GestureDetector(
                  onTap: () {
                    ref.read(controller.imageUrl.state).state = '';
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios)),
              centerTitle: true,
              title: Text(
                'Edit Profile',
                style: t16M.copyWith(
                  color: AppColors.ink[500],
                ),
              ),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 112,
                        width: 112,
                        child: CircleAvatar(
                          backgroundColor: AppColors.ink[400],
                          backgroundImage: controller.displayUserAva() == ''
                              ? null
                              : NetworkImage(controller.displayUserAva()),
                          child: controller.displayUserAva() == ''
                              ? Icon(
                                  Icons.person,
                                  color: AppColors.ink[0],
                                  size: 72,
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),
                      Positioned(
                          height: 40,
                          width: 40,
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: (() async {
                              await controller.getImage();
                            }),
                            child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.ink[0],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: AppColors.ink[400],
                                )),
                          ))
                    ],
                  ),
                  const SizedBox(height: 16),
                  CommonTextFormField(
                    labelText: 'Name',
                    controller: controller.profileNameController,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 24),
                  CommonButton(
                    onPressed: () async {
                      if (controller.profileNameController.text.isEmpty ||
                          controller.profileEmailController.text.isEmpty) {
                        CommonSnackbar.show(context,
                            type: SnackbarType.warning,
                            message: 'Profile informations must be filled');
                      } else {
                        await controller.updateUser(context);
                      }
                    },
                    btnController: controller.buttonController,
                    child: const Text('Save', style: t16M),
                  )
                ]))),
      ),
    );
  }
}
