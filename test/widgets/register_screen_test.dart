import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:event_ticket_booking/features/register/data/models/register_response_model.dart';
import 'package:event_ticket_booking/features/register/data/repos/register_repo.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_ticket_booking/features/register/presentation/ui/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterRepo extends Mock implements RegisterRepo {}

void main() {
  late MockRegisterRepo repo;

  setUpAll(() {
    registerFallbackValue(RegisterRequestModel(
      name: 'name',
      email: 'email@example.com',
      phone: '01012345678',
      password: 'Password1',
      rePassword: 'Password1',
    ));
  });

  setUp(() {
    repo = MockRegisterRepo();
  });

  Future<RegisterCubit> pumpScreen(WidgetTester tester) async {
    final cubit = RegisterCubit(registerRepo: repo);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<RegisterCubit>(
          create: (_) => cubit,
          child: const RegisterScreen(),
        ),
      ),
    );
    return cubit;
  }

  Future<void> unmount(WidgetTester tester, RegisterCubit cubit) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await cubit.close();
  }

  testWidgets('renders all registration fields and actions', (tester) async {
    final cubit = await pumpScreen(tester);

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Fill in your details to get started'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Already have an account? '), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    await unmount(tester, cubit);
  });

  testWidgets('shows validation errors when submitted empty', (tester) async {
    final cubit = await pumpScreen(tester);

    await tester.ensureVisible(find.text('Register'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Please confirm your password'), findsOneWidget);

    verifyNever(() => repo.register(any()));

    await unmount(tester, cubit);
  });

  testWidgets('navigates to login on a successful registration', (tester) async {
    when(() => repo.register(any())).thenAnswer(
      (_) async => Success<RegisterResponseModel>(
        RegisterResponseModel(
          message: 'Registration successful',
          token: 'tok',
          user: User(name: 'John Doe', email: 'john@example.com', role: 'user'),
        ),
      ),
    );

    final cubit = await pumpScreen(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter your full name'),
      'John Doe',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter your email'),
      'john@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter your phone number'),
      '01012345678',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Create a password'),
      'Password1',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirm your password'),
      'Password1',
    );

    await tester.ensureVisible(find.text('Register'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    verify(() => repo.register(any())).called(1);

    await unmount(tester, cubit);
  });
}