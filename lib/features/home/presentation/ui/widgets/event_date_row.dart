import 'package:event_ticket_booking/features/home/data/models/event_dates_model.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_info_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDateRow extends StatelessWidget {
  final EventDatesModel? dates;

  const EventDateRow({super.key, required this.dates});

  @override
  Widget build(BuildContext context) {
    return EventInfoRow(icon: Icons.calendar_today_outlined, text: _label);
  }

  String get _label {
    final date = dates?.resolvedDate;
    if (date == null) return 'Date to be announced';

    final pattern = dates?.localTime == null
        ? 'EEE, MMM d, yyyy'
        : 'EEE, MMM d, yyyy · h:mm a';
    return DateFormat(pattern).format(date);
  }
}
