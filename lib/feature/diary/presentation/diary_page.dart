import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:selfcare_diary/core/config/colors.dart';
import 'package:selfcare_diary/feature/diary/presentation/widget/diary_form.dart';

class DiaryPage extends ConsumerStatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.ink[0],
        body: const SafeArea(
          child: SingleChildScrollView(
            child: DiaryForm(),
          ),
        ),
      ),
    );
  }
}
