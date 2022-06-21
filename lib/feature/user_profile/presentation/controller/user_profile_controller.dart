import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:selfcare_diary/core/common/common_snack_bar.dart';
import 'package:selfcare_diary/core/constant/firebase_constant.dart';
import 'package:selfcare_diary/feature/user_profile/data/repositories/user_profile_repositories_impl.dart';
import 'package:selfcare_diary/feature/user_profile/domain/repositories/user_profile_repositories.dart';

import 'package:shared_preferences/shared_preferences.dart';

final userProfileControllerProvider = Provider.autoDispose((ref) {
  final userProfileRepositories = ref.watch(userProfileRepositoryProvider);
  return UserProfileController(
      ref: ref, userProfileRepositories: userProfileRepositories);
});

final fetchUserInfoProvider = FutureProvider.autoDispose((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  return userProfileRepository.fetchUserInfo();
});

class UserProfileController {
  final ProviderRef ref;
  final UserProfileRepositories userProfileRepositories;

  UserProfileController(
      {required this.ref, required this.userProfileRepositories});

  final profileNameController = TextEditingController();
  final profileEmailController = TextEditingController();
  final profilePasswordController = TextEditingController();
  final profilePasswordNewController = TextEditingController();
  final profilePasswordNewConfirmController = TextEditingController();

  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;
  var firebaseFirestore = FirebaseFirestore.instance;

  var isUpdateSuccessfully = false;
  var imageUrl = StateProvider((ref) => '');

  getUserName() {
    final User user = _firebaseAuth.currentUser!;
    profileNameController.text = user.displayName ?? '';
  }

  getUserEmail() {
    final User user = _firebaseAuth.currentUser!;
    profileEmailController.text = user.email ?? '';
  }

  String displayUserName() {
    final User user = _firebaseAuth.currentUser!;
    final userName = user.displayName.toString();
    return userName;
  }

  String displayUserEmail() {
    final User user = _firebaseAuth.currentUser!;
    final userEmail = user.email.toString();
    return userEmail;
  }

  String displayUserAva() {
    final User user = _firebaseAuth.currentUser!;
    var userAva = user.photoURL ?? '';
    return userAva;
  }

  logoutUser() async {
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('usernameFirebase', '');
      await sharedPreferences.setString('passwordFirebase', '');
      await FirebaseAuth.instance.signOut();

      return true;
    } catch (e) {
      buttonController.reset();
      return false;
    }
  }

  File imageFile = File('');

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      TaskSnapshot snapshot = await uploadImageFile(
          imageFile, DateTime.now().millisecondsSinceEpoch.toString());
      ref.read(imageUrl.state).state = await snapshot.ref.getDownloadURL();
    }
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  updateUser(context) async {
    try {
      final User user = _firebaseAuth.currentUser!;
      await user.updateDisplayName(profileNameController.text);
      await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .doc(user.uid)
          .update({
        FirestoreConstants.displayName: profileNameController.text,
      });
      if (ref.read(imageUrl.state).state != '') {
        await user.updatePhotoURL(ref.read(imageUrl.state).state);
        await firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(user.uid)
            .update({
          FirestoreConstants.photoUrl: ref.read(imageUrl.state).state,
        });
      }

      isUpdateSuccessfully = true;
      Navigator.of(context).pop();
      CommonSnackbar.show(context,
          type: SnackbarType.success, message: 'Update succesfully');
      buttonController.reset();
    } catch (e) {
      buttonController.reset();
      isUpdateSuccessfully = false;
    }
  }

  changePassword(context) async {
    final User user = _firebaseAuth.currentUser!;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var currentPassword = sharedPreferences.getString('passwordFirebase');

    var credential = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword!);
    try {
      user.reauthenticateWithCredential(credential).then((value) {
        if (profilePasswordController.text == currentPassword) {
          if (profilePasswordNewController.text != '' &&
              profilePasswordNewController.text ==
                  profilePasswordNewController.text) {
            user.updatePassword(profilePasswordNewController.text);
          } else {
            CommonSnackbar.show(context,
                type: SnackbarType.error, message: 'Invalid Password');
          }
        } else {
          CommonSnackbar.show(context,
              type: SnackbarType.error, message: 'Wrong Password');
        }
      }).catchError((e) {
        CommonSnackbar.show(context,
            type: SnackbarType.error, message: e.toString());
      });
      buttonController.reset();

      return true;
    } catch (e) {
      buttonController.reset();

      return false;
    }
  }
}
