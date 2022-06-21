import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/common/common_button.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/controller/user_profile_controller.dart';

class UserProfileInfo extends ConsumerWidget {
  const UserProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(userProfileControllerProvider);
    return Column(children: [
      Divider(
        color: AppColors.ink[0],
      ),
      Container(
        decoration: BoxDecoration(
            color: AppColors.ink[100], //...
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 1.2, color: AppColors.ink[0]!)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.person_add_alt_1),
          title: Text(controller.displayUserName()),
        ),
      ),
      Divider(
        color: AppColors.ink[0],
      ),
      Container(
        decoration: BoxDecoration(
            color: AppColors.ink[100],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(width: 1.2, color: AppColors.ink[0]!)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: const Icon(Icons.email),
          title: Text(controller.displayUserEmail()),
        ),
      ),
      Divider(
        color: AppColors.ink[0],
      ),
      CommonButton(
          btnController: controller.buttonController,
          child: const Text('Log Out'),
          onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text('Do you really want to logout?',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      content: Row(
                        children: [
                          TextButton(
                              onPressed: () {}, child: const Text('Yes')),
                          VerticalDivider(color: AppColors.ink[0]),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'))
                        ],
                      ));
                },
              )),
    ]);
  }
}
