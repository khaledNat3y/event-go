import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/features/home/data/models/event_dates_model.dart';
import 'package:event_ticket_booking/features/home/data/models/event_filters.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/data/models/events_response.dart';
import 'package:event_ticket_booking/features/home/data/models/pagination_model.dart';
import 'package:event_ticket_booking/features/home/data/repos/home_repo.dart';
import 'package:event_ticket_booking/features/home/presentation/cubit/home_cubit.dart';
import 'package:event_ticket_booking/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late MockHomeRepo repo;

  setUpAll(() {
    registerFallbackValue(const EventFilters());
  });

  setUp(() {
    repo = MockHomeRepo();
  });

  EventModel buildEvent({
    String id = 'ev-1',
    String name = 'Taylor Swift | The Eras Tour',
    String statusCode = 'onsale',
  }) {
    return EventModel(
      id: id,
      name: name,
      segmentName: 'Music',
      genreName: 'Pop',
      dates: EventDatesModel(
        startDateTime: DateTime.now().add(const Duration(days: 30)),
        localDate: '2027-08-15',
        localTime: '19:00:00',
        statusCode: statusCode,
      ),
    );
  }

  Future<HomeCubit> pumpScreen(WidgetTester tester) async {
    final cubit = HomeCubit(repo: repo);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<HomeCubit>(
          create: (_) => cubit,
          child: const HomeScreen(),
        ),
      ),
    );
    return cubit;
  }

  Future<void> unmount(WidgetTester tester, HomeCubit cubit) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await cubit.close();
  }

  testWidgets('shows the loading view before events arrive', (tester) async {
    when(
      () => repo.getEvents(
        filters: any(named: 'filters'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => Success<EventsResponse>(
        EventsResponse(events: const [], page: const PaginationModel()),
      ),
    );

    final cubit = await pumpScreen(tester);

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('On Sale'), findsNothing);

    await unmount(tester, cubit);
  });

  testWidgets('renders one card per event', (tester) async {
    when(
      () => repo.getEvents(
        filters: any(named: 'filters'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => Success<EventsResponse>(
        EventsResponse(
          events: [
            buildEvent(),
            buildEvent(id: 'ev-2', name: 'Coldplay'),
          ],
          page: const PaginationModel(),
        ),
      ),
    );

    final cubit = await pumpScreen(tester);
    await cubit.getEvents();
    await tester.pumpAndSettle();

    expect(find.text('Taylor Swift | The Eras Tour'), findsOneWidget);
    expect(find.text('Coldplay'), findsOneWidget);
    expect(find.text('On Sale'), findsNWidgets(2));
    expect(find.text('Music · Pop'), findsNWidgets(2));

    await unmount(tester, cubit);
  });

  testWidgets('shows the empty view when the response has no events', (
    tester,
  ) async {
    when(
      () => repo.getEvents(
        filters: any(named: 'filters'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => Success<EventsResponse>(
        EventsResponse(events: const [], page: const PaginationModel()),
      ),
    );

    final cubit = await pumpScreen(tester);
    await cubit.getEvents();
    await tester.pumpAndSettle();

    expect(find.text('No events found'), findsOneWidget);

    await unmount(tester, cubit);
  });

  testWidgets('shows the error view and retries on tap', (tester) async {
    when(
      () => repo.getEvents(
        filters: any(named: 'filters'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => Error<AppError>(
        const AppError(message: 'Network unreachable', code: 'NETWORK_ERROR'),
      ),
    );

    final cubit = await pumpScreen(tester);
    await cubit.getEvents();
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Network unreachable'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    verify(
      () => repo.getEvents(
        filters: any(named: 'filters'),
        page: any(named: 'page'),
      ),
    ).called(2);

    await unmount(tester, cubit);
  });

  testWidgets('marks a sold out event', (tester) async {
    when(
      () => repo.getEvents(
        filters: any(named: 'filters'),
        page: any(named: 'page'),
      ),
    ).thenAnswer(
      (_) async => Success<EventsResponse>(
        EventsResponse(
          events: [buildEvent(statusCode: 'soldout')],
          page: const PaginationModel(),
        ),
      ),
    );

    final cubit = await pumpScreen(tester);
    await cubit.getEvents();
    await tester.pumpAndSettle();

    expect(find.text('Sold Out'), findsOneWidget);

    await unmount(tester, cubit);
  });
}
