import 'dart:math' as math;

import 'package:event_ticket_booking/core/theme/app_colors.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/data/models/pagination_model.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventsList extends StatefulWidget {
  final List<EventModel> events;
  final PaginationModel pagination;
  final void Function(EventModel event)? onEventTap;
  final VoidCallback? onLoadMore;
  final VoidCallback? onRetryLoadMore;
  final bool isLoadingMore;
  final String? loadMoreError;
  final EdgeInsetsGeometry padding;

  const EventsList({
    super.key,
    required this.events,
    this.onEventTap,
    this.padding = const EdgeInsets.fromLTRB(16, 20, 16, 32),
    required this.pagination,
    this.onLoadMore,
    this.onRetryLoadMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  @override
  State<EventsList> createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (widget.isLoadingMore || widget.loadMoreError != null) return;
    if (!widget.pagination.hasNextPage) return;
    if (widget.onLoadMore == null) return;

    final position = scrollController.position;
    if (position.pixels < position.maxScrollExtent - 400) return;

    widget.onLoadMore!();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          stretch: true,
          expandedHeight: 180,
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
          actions: [
            IconButton(
              tooltip: 'Search',
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                HapticFeedback.selectionClick();
                // TODO: navigate to search
              },
            ),
            const SizedBox(width: 16),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            titlePadding: const EdgeInsetsDirectional.only(
              start: 20,
              bottom: 16,
            ),
            title: const Text(
              'Events',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            background: _HeaderBackground(count: widget.events.length),
          ),
        ),
        SliverPadding(
          padding: widget.padding,
          sliver: SliverList.separated(
            itemCount: widget.events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final event = widget.events[index];
              return _FadeSlideIn(
                index: index,
                child: _PressScale(
                  child: EventCard(
                    event: event,
                    onTap: widget.onEventTap == null
                        ? null
                        : () {
                            HapticFeedback.lightImpact();
                            widget.onEventTap!(event);
                          },
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: _PaginationFooter(
            isLoading: widget.isLoadingMore,
            error: widget.loadMoreError,
            hasNextPage: widget.pagination.hasNextPage,
            onRetry: widget.onRetryLoadMore,
          ),
        ),
      ],
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final bool hasNextPage;
  final VoidCallback? onRetry;

  const _PaginationFooter({
    required this.isLoading,
    required this.error,
    required this.hasNextPage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          children: [
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 13,
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (hasNextPage) return const SizedBox(height: 8);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: Text(
          "You've reached the end",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(
              alpha: 0.5,
            ),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final int count;
  const _HeaderBackground({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black, AppColors.primarySoft],
            ),
          ),
        ),
        Positioned(
          top: -60,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.14),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          bottom: 68,
          child: Text(
            'Discover $count upcoming events',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _FadeSlideIn extends StatelessWidget {
  final int index;
  final Widget child;
  const _FadeSlideIn({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + math.min(index, 5) * 90),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 28 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// Subtle scale-down while the card is pressed.
class _PressScale extends StatefulWidget {
  final Widget child;
  const _PressScale({required this.child});

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale> {
  bool _pressed = false;

  void _set(bool v) {
    if (!mounted || _pressed == v) return;

    setState(() {
      _pressed = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listener doesn't compete with EventCard's own tap handling.
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
