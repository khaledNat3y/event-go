import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_card_placeholder.dart';
import 'package:flutter/material.dart';

class EventsLoadingView extends StatelessWidget {
  final int itemCount;

  const EventsLoadingView({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => const EventCardPlaceholder(),
    );
  }
}
