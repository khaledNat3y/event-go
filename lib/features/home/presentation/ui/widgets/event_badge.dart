import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:flutter/material.dart';

class EventBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const EventBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon = Icons.circle,
  });

  const EventBadge.onSale({super.key})
    : label = 'On Sale',
      color = AppColors.success,
      icon = Icons.check_circle_outline;

  const EventBadge.soldOut({super.key})
    : label = 'Sold Out',
      color = AppColors.error,
      icon = Icons.remove_circle_outline;

  const EventBadge.ended({super.key})
    : label = 'Ended',
      color = AppColors.textSecondary,
      icon = Icons.history;

  factory EventBadge.fromEvent(EventModel event) {
    if (!event.isOnSale) return const EventBadge.soldOut();
    if (!event.isUpcoming) return const EventBadge.ended();
    return const EventBadge.onSale();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
