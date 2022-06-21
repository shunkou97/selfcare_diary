import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/feature/login/data/models/login_model.dart';
import 'package:selfcare_diary/feature/login/domain/repositories/login_repositories.dart';

final loginRepositoryProvider = Provider.autoDispose<LoginRepositoriesImpl>(
    (ref) => LoginRepositoriesImpl());

class LoginRepositoriesImpl implements LoginRepositories {
  @override
  Future<LoginModel> fetchUsername() async {
    return const LoginModel(userName: 'Hieu');
  }
}
