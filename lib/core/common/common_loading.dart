import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:selfcare_diary/core/config/colors.dart';

class CommonLoading extends StatelessWidget {
  final Color? color;
  const CommonLoading({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink[0],
      child: Center(
          child: Platform.isAndroid
              ? CircularProgressIndicator(
                  backgroundColor: color ?? AppColors.ink[0],
                )
              : CupertinoActivityIndicator(
                  color: color ?? AppColors.ink[0],
                )),
    );
  }
}
