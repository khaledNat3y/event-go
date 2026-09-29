import 'package:event_ticket_booking/features/home/presentation/ui/widgets/events_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: const EventsView()));
  }
}
