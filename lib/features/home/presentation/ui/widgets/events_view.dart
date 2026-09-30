import 'package:event_ticket_booking/features/home/presentation/cubit/home_cubit.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/events_empty_view.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/events_error_view.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/events_list.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/widgets/events_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsView extends StatelessWidget {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return switch (state) {
          HomeInitial() || EventsLoading() => const EventsLoadingView(),
          EventsSuccess(
            eventsList: final events,
            paginationModel: final page,
          ) =>
            events.isEmpty
                ? const EventsEmptyView()
                : EventsList(
                    key: const ValueKey('eventsList'),
                    events: events,
                    pagination: page,
                    isLoadingMore: state.isLoadingMore,
                    loadMoreError: state.loadMoreError,
                    onLoadMore: () => context.read<HomeCubit>().loadMore(),
                    onRetryLoadMore: () => context.read<HomeCubit>().loadMore(),
                    onEventTap: (event) {
                      // launchUrlToEvent(Uri.parse(event.ticketUrl!));
                    },
                  ),
          EventsFailure(message: final message) => EventsErrorView(
            message: message,
            onRetry: () => context.read<HomeCubit>().getEvents(),
          ),
        };
      },
    );
  }
}
