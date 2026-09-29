import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_badge.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_date_row.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_image.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_info_row.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EventImageHeader(event: event),
              const SizedBox(height: 12),
              _EventTitle(event: event),
              const SizedBox(height: 8),
              EventDateRow(dates: event.dates),
              const SizedBox(height: 6),
              _EventVenueRow(event: event),
              if (event.formattedPriceRange != null) ...[
                const SizedBox(height: 6),
                EventInfoRow(
                  icon: Icons.sell_outlined,
                  text: 'From ${event.formattedPriceRange}',
                  color: AppColors.textPrimary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventImageHeader extends StatelessWidget {
  final EventModel event;

  const _EventImageHeader({required this.event});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EventImage(url: event.coverImageUrl, height: 160),
        Positioned(top: 10, left: 10, child: EventBadge.fromEvent(event)),
      ],
    );
  }
}

class _EventTitle extends StatelessWidget {
  final EventModel event;

  const _EventTitle({required this.event});

  @override
  Widget build(BuildContext context) {
    final category = [
      event.segmentName,
      event.genreName,
    ].where((value) => value != null && value.isNotEmpty).join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        if (category.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class _EventVenueRow extends StatelessWidget {
  final EventModel event;

  const _EventVenueRow({required this.event});

  @override
  Widget build(BuildContext context) {
    final venue = event.venue;
    final location = [
      venue?.name,
      venue?.shortLocation,
    ].where((value) => value != null && value.isNotEmpty).join(' · ');

    return EventInfoRow(
      icon: Icons.place_outlined,
      text: location.isEmpty ? 'Venue to be announced' : location,
    );
  }
}
