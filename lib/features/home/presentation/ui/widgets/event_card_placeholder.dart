import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_image_placeholder.dart';
import 'package:flutter/material.dart';

class EventCardPlaceholder extends StatelessWidget {
  const EventCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          EventImagePlaceholder(height: 160),
          SizedBox(height: 12),
          _PlaceholderLine(widthFactor: 0.9, height: 16),
          SizedBox(height: 8),
          _PlaceholderLine(widthFactor: 0.5, height: 12),
          SizedBox(height: 12),
          _PlaceholderLine(widthFactor: 0.7, height: 12),
          SizedBox(height: 8),
          _PlaceholderLine(widthFactor: 0.6, height: 12),
        ],
      ),
    );
  }
}

class _PlaceholderLine extends StatelessWidget {
  final double widthFactor;
  final double height;

  const _PlaceholderLine({required this.widthFactor, required this.height});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
