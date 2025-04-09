import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/on_generate_route.dart';
import 'core/themes/app_themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eGrocery',
      theme: AppTheme.defaultTheme,
      onGenerateRoute: RouteGenerator.onGenerate,
<<<<<<< HEAD
      // initialRoute: AppRoutes.onboarding,
      initialRoute: AppRoutes.login,
=======
<<<<<<< HEAD
      initialRoute: AppRoutes.onboarding,
=======
<<<<<<< HEAD
      initialRoute: AppRoutes.introLogin,
=======
      initialRoute: AppRoutes.login,
>>>>>>> main
>>>>>>> a180e10 (로그인화면)
>>>>>>> 37628b6 (0411_1034_은우 login커밋 cherrypick)
    );
  }
}
