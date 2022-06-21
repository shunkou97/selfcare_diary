import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:selfcare_diary/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      initialRoute: AppRoutes.login,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, widget ?? Container()),
          maxWidth: 1280,
          minWidth: 375,
          defaultScale: true,
          breakpoints: const [
            ResponsiveBreakpoint.autoScale(375, name: MOBILE),
            ResponsiveBreakpoint.resize(450, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: TABLET),
          ],
        ),
      ),
    );
  }
}
