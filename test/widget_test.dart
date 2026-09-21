import 'package:event_ticket_booking/core/di/service_locator.dart';
import 'package:event_ticket_booking/event_go.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    setupGetIt();
  });

  testWidgets('app launches on the register screen when logged out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EventGo());
    await tester.pump();

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  });
}