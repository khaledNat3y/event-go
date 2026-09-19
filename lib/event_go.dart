import 'package:event_ticket_booking/core/routes/app_router.dart';
import 'package:event_ticket_booking/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class EventGo extends StatelessWidget {
  const EventGo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EventGo',
      onGenerateRoute: AppRouter.onGenerateRoutes,
      initialRoute: AppRoutes.registerScreen,
    );
  }
}
