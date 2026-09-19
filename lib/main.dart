import 'package:event_ticket_booking/core/di/service_locator.dart';
import 'package:event_ticket_booking/event_go.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  await dotenv.load();
  runApp(const EventGo());
}
