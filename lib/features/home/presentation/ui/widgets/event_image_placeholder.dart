import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EventImagePlaceholder extends StatelessWidget {
  final double height;
  final double width;

  const EventImagePlaceholder({
    super.key,
    required this.height,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: AppColors.border.withValues(alpha: 0.6),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: AppColors.muted, size: 32),
    );
  }
}
