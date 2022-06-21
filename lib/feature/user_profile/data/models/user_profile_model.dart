import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UserModel extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final String avatar;

  const UserModel(
      {required this.id,
      required this.displayName,
      required this.email,
      required this.avatar});

  UserModel copyWith({
    String? id,
    String? displayName,
    String? email,
    String? avatar,
  }) =>
      UserModel(
          id: id ?? this.id,
          displayName: displayName! ?? displayName,
          email: email ?? ,
          aboutMe: email ?? aboutMe);

  Map<String, dynamic> toJson() => {
        'fullname': displayName,
        'company': company,
        'email': aboutMe,
      };
  factory UserModel.fromDocument(DocumentSnapshot snapshot) {
    String nickname = "";
    String company = "";
    String aboutMe = "";
    bool isSub = false;

    try {
      nickname = snapshot.get('fullname') ?? '';
      company = snapshot.get('company') ?? '';
      aboutMe = snapshot.get('email') ?? '';
      isSub = snapshot.get('isSub') ?? false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return UserModel(
        id: snapshot.id,
        displayName: nickname,
        company: company,
        aboutMe: aboutMe);
  }
  @override
  List<Object?> get props => [id, displayName, company, aboutMe];
}
