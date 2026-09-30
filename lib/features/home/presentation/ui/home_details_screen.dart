import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/core/utils/validators.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_badge.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_date_row.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_info_row.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeDetailsScreen extends StatelessWidget {
  final EventModel event;

  const HomeDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CollapsingHero(event: event),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleBlock(event: event),
                  const SizedBox(height: 24),
                  _DetailsCard(event: event),
                  if (_aboutText(event) case final about?) ...[
                    const SizedBox(height: 24),
                    _AboutSection(text: about),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _GoToEventBar(event: event),
    );
  }
}

class _CollapsingHero extends StatelessWidget {
  final EventModel event;

  const _CollapsingHero({required this.event});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 300,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      clipBehavior: Clip.antiAlias,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      leading: IconButton(
        tooltip: 'Back',
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.35),
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.of(context).pop();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.fadeTitle,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            EventImage(
              url: event.coverImageUrl,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66000000),
                    Color(0x00000000),
                    Color(0xCC000000),
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: EventBadge.fromEvent(event),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final EventModel event;

  const _TitleBlock({required this.event});

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
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.25,
            letterSpacing: -0.5,
          ),
        ),
        if (category.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            category,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final EventModel event;

  const _DetailsCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final venue = event.venue;
    final location = [
      venue?.name,
      venue?.shortLocation,
    ].where((value) => value != null && value.isNotEmpty).join(' · ');
    final address = venue?.addressLine?.trim();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EventDateRow(dates: event.dates),
          const SizedBox(height: 12),
          EventInfoRow(
            icon: Icons.place_outlined,
            text: location.isEmpty ? 'Venue to be announced' : location,
          ),
          if (address != null && address.isNotEmpty) ...[
            const SizedBox(height: 12),
            EventInfoRow(icon: Icons.map_outlined, text: address),
          ],
          if (event.formattedPriceRange case final price?) ...[
            const SizedBox(height: 12),
            EventInfoRow(
              icon: Icons.sell_outlined,
              text: 'From $price',
              color: AppColors.textPrimary,
            ),
          ],
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  final String text;

  const _AboutSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _GoToEventBar extends StatelessWidget {
  final EventModel event;

  const _GoToEventBar({required this.event});

  @override
  Widget build(BuildContext context) {
    final url = event.ticketUrl;
    final hasUrl = url != null && url.trim().isNotEmpty;
    final uri = hasUrl ? Uri.tryParse(url) : null;
    final canOpen = uri != null && uri.hasScheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.disabled,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                !hasUrl
                    ? 'Tickets unavailable'
                    : event.isBookable
                    ? 'Get Tickets'
                    : 'View Event',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: !canOpen
                  ? null
                  : () async {
                      HapticFeedback.mediumImpact();
                      await _open(context, uri);
                    },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, Uri uri) async {
    try {
      await launchUrlToEvent(uri);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the event page')),
      );
    }
  }
}

String? _aboutText(EventModel event) {
  final info = event.info?.trim();
  if (info == null || info.isEmpty) return null;

  // Ticketmaster returns `info` with inline HTML markup.
  final stripped = info
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll(RegExp(r'&nbsp;'), ' ')
      .replaceAll(RegExp(r'&amp;'), '&')
      .trim();

  return stripped.isEmpty ? null : stripped;
}