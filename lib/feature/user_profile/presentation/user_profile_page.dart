import 'package:flutter/material.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/core/config/theme.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/widget/user_profile_info.dart';
import 'package:selfcare_diary/feature/user_profile/presentation/widget/user_profile_picture.dart';
import 'package:selfcare_diary/routes.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink[0],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          'User Profile',
          style: t16M.copyWith(
            color: AppColors.ink[500],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.userProfileConfig),
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const ProfilePic(),
            Divider(
              color: AppColors.ink[0],
            ),
            const UserProfileInfo(),
          ],
        ),
      ),
    );
  }
}
