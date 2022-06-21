import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:selfcare_diary/core/common/common_snack_bar.dart';
import 'package:selfcare_diary/core/constant/firebase_constant.dart';
import 'package:selfcare_diary/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

final registerControllerProvider = Provider.autoDispose((ref) {
  return RegisterController(ref: ref);
});

class RegisterController {
  final ProviderRef ref;

  RegisterController({required this.ref});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  final RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();
  //instance Firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  var imageUrl = StateProvider((ref) => '');
  var isImageLoading = StateProvider((ref) => false);
  var isObscureText = StateProvider((ref) => true);
  var isObscureReText = StateProvider((ref) => true);

  registerWithEmailPassword(context,
      {required String name,
      required String email,
      required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var res = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      await res.user?.updateDisplayName(name);
      if (ref.read(imageUrl.state).state != '') {
        await res.user?.updatePhotoURL(ref.read(imageUrl.state).state);
      }
      print(res);
      var firebaseUser = res.user!;

      var deviceToken = await FirebaseMessaging.instance.getToken();

      print('deviceToken: ' + deviceToken!);
      final QuerySnapshot data = await firebaseFirestore
          .collection(FirestoreConstants.pathUserCollection)
          .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
          .get();
      final List<DocumentSnapshot> document = data.docs;
      if (document.isEmpty) {
        firebaseFirestore
            .collection(FirestoreConstants.pathUserCollection)
            .doc(firebaseUser.uid)
            .set({
          FirestoreConstants.displayName: name,
          FirestoreConstants.photoUrl: firebaseUser.photoURL,
          FirestoreConstants.id: firebaseUser.uid,
          "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
          "deviceToken": deviceToken
        });

        User? currentUser = firebaseUser;
        await prefs.setString(FirestoreConstants.id, currentUser.uid);
        await prefs.setString(
            FirestoreConstants.displayName, currentUser.displayName ?? "");
        await prefs.setString(
            FirestoreConstants.photoUrl, currentUser.photoURL ?? "");
      }

      buttonController.reset();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      return {"status": true, "message": "success", "data": res.user};
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      CommonSnackbar.show(context,
          type: SnackbarType.error, message: e.message!);
      buttonController.reset();

      return {"status": false, "message": e.message.toString(), "data": ""};
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      var imageFile = File(pickedFile.path);
      try {
        ref.read(isImageLoading.state).state = true;
        TaskSnapshot snapshot = await uploadImageFile(
            imageFile, DateTime.now().millisecondsSinceEpoch.toString());
        ref.read(imageUrl.state).state = await snapshot.ref.getDownloadURL();
        ref.read(isImageLoading.state).state = false;
      } catch (e) {
        ref.read(isImageLoading.state).state = false;
      }
    }
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }
}
