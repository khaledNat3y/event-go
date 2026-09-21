import 'package:event_ticket_booking/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpField(
    WidgetTester tester, {
    TextEditingController? controller,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            child: CustomTextField(
              label: 'Label',
              hint: 'Hint',
              controller: controller ?? TextEditingController(),
              obscureText: obscureText,
              validator: validator,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows label and hint', (tester) async {
    await pumpField(tester);

    expect(find.text('Label'), findsOneWidget);
    expect(find.text('Hint'), findsOneWidget);
  });

  testWidgets('passes text to the controller on input', (tester) async {
    final controller = TextEditingController();
    await pumpField(tester, controller: controller);

    await tester.enterText(find.byType(TextFormField), 'hello');

    expect(controller.text, 'hello');
  });

  testWidgets('runs the validator', (tester) async {
    final formKey = GlobalKey<FormState>();
    String? mockValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Required';
      }
      return null;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: CustomTextField(
              label: 'Label',
              hint: 'Hint',
              controller: TextEditingController(),
              validator: mockValidator,
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('does not show an error when the value is valid', (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: CustomTextField(
              label: 'Label',
              hint: 'Hint',
              controller: TextEditingController(text: 'ok'),
              validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
            ),
          ),
        ),
      ),
    );

    formKey.currentState!.validate();
    await tester.pump();

    expect(find.text('Required'), findsNothing);
  });

  testWidgets('toggles password visibility when obscureText is enabled', (
    tester,
  ) async {
    await pumpField(tester, obscureText: true);

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('does not show the toggle when obscureText is disabled', (
    tester,
  ) async {
    await pumpField(tester);

    expect(find.byIcon(Icons.visibility_off), findsNothing);
    expect(find.byIcon(Icons.visibility), findsNothing);
  });

  testWidgets('hides the suffix icon parameter when obscureText is enabled', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomTextField(
            label: 'Label',
            hint: 'Hint',
            controller: TextEditingController(),
            obscureText: true,
            suffixIcon: const Icon(Icons.check),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.check), findsNothing);
  });
}