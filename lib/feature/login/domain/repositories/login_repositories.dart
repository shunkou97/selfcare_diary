import 'package:selfcare_diary/feature/login/data/models/login_model.dart';

abstract class LoginRepositories {
  Future<LoginModel> fetchUsername();
}
