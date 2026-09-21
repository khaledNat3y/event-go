import 'package:event_ticket_booking/core/helper/app_constants.dart';
import 'package:event_ticket_booking/core/helper/shared_pref_helper.dart';
import 'package:event_ticket_booking/core/routes/app_router.dart';
import 'package:event_ticket_booking/core/routes/app_routes.dart';
import 'package:event_ticket_booking/core/theme/themes.dart';
import 'package:flutter/material.dart';

class EventGo extends StatelessWidget {
  const EventGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventGo',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: AppRouter.onGenerateRoutes,
      initialRoute: isLoggedIn
          ? AppRoutes.loginScreen
          : AppRoutes.registerScreen,
    );
  }
}

Future<void> checkIfUserIsLoggedIn() async {
  final token = await SharedPrefHelper.getSecuredString(AppConstants.tokenKey);
  if (token.isNotEmpty) {
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
  }
}
