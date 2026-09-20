import 'package:event_ticket_booking/core/di/service_locator.dart';
import 'package:event_ticket_booking/core/routes/app_routes.dart';
import 'package:event_ticket_booking/features/login/presentation/ui/login_screen.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<RegisterCubit>(),
            child: RegisterScreen(),
          ),
        );

      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
    }
    return null;
  }
}
