import 'package:event_ticket_booking/features/register/presentation/ui/widgets/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpButton(
    WidgetTester tester, {
    bool isLoading = false,
    VoidCallback? onPressed,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RegisterButton(
            isLoading: isLoading,
            onPressed: onPressed ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('shows Register text when not loading', (tester) async {
    await pumpButton(tester);

    expect(find.text('Register'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('shows a progress indicator while loading', (tester) async {
    await pumpButton(tester, isLoading: true);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Register'), findsNothing);
  });

  testWidgets('invokes onPressed when tapped and not loading', (tester) async {
    var tapped = false;
    await pumpButton(tester, onPressed: () => tapped = true);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('does not invoke onPressed while loading', (tester) async {
    var tapped = false;
    await pumpButton(tester, isLoading: true, onPressed: () => tapped = true);

    await tester.tap(find.byType(FilledButton), warnIfMissed: false);
    await tester.pump();

    expect(tapped, isFalse);
  });
}