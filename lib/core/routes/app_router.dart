import 'package:event_ticket_booking/core/routes/app_routes.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/register_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
    }
    return null;
  }
}
