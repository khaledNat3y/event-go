import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_card.dart';
import 'package:flutter/material.dart';

class EventsList extends StatelessWidget {
  final List<EventModel> events;
  final void Function(EventModel event)? onEventTap;
  final EdgeInsetsGeometry padding;

  const EventsList({
    super.key,
    required this.events,
    this.onEventTap,
    this.padding = const EdgeInsets.fromLTRB(16, 16, 16, 24),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
          event: event,
          onTap: onEventTap == null ? null : () => onEventTap!(event),
        );
      },
    );
  }
}
