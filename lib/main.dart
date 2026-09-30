import 'package:event_ticket_booking/core/di/service_locator.dart';
import 'package:event_ticket_booking/event_go.dart';
import 'package:event_ticket_booking/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setupGetIt();
  await dotenv.load();
  await checkIfUserIsLoggedIn();
  runApp(const EventGo());
}
