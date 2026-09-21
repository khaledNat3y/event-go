import 'package:bloc_test/bloc_test.dart';
import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:event_ticket_booking/features/register/data/models/register_response_model.dart';
import 'package:event_ticket_booking/features/register/data/repos/register_repo.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_cubit.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterRepo extends Mock implements RegisterRepo {}

void main() {
  late MockRegisterRepo repo;

  final request = RegisterRequestModel(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'Password1',
    rePassword: 'Password1',
    phone: '01012345678',
  );

  final successResponse = RegisterResponseModel(
    message: 'Registration successful',
    token: 'tok',
    user: User(name: 'John Doe', email: 'john@example.com', role: 'user'),
  );

  setUp(() {
    repo = MockRegisterRepo();
  });

  Matcher loadingState() =>
      isA<RegisterState>().having((s) => s.status, 'status', Status.loading);

  Matcher stateWith(
    Status status,
    String message,
  ) => isA<RegisterState>().having((s) => s.status, 'status', status).having(
        (s) => s.message,
        'message',
        message,
      );

  blocTest<RegisterCubit, RegisterState>(
    'starts in the initial state',
    build: () => RegisterCubit(registerRepo: repo),
    expect: () => const [],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits loading then success on a successful registration',
    build: () {
      when(() => repo.register(request)).thenAnswer(
        (_) async => Success<RegisterResponseModel>(successResponse),
      );
      return RegisterCubit(registerRepo: repo);
    },
    act: (cubit) => cubit.register(request),
    expect: () => [
      loadingState(),
      stateWith(Status.success, 'Registration successful'),
    ],
    verify: (_) => verify(() => repo.register(request)).called(1),
  );

  blocTest<RegisterCubit, RegisterState>(
    'uses the default success message when none is provided',
    build: () {
      when(() => repo.register(request)).thenAnswer(
        (_) async => Success<RegisterResponseModel>(
          RegisterResponseModel(token: 'tok'),
        ),
      );
      return RegisterCubit(registerRepo: repo);
    },
    act: (cubit) => cubit.register(request),
    expect: () => [
      loadingState(),
      stateWith(Status.success, 'Registration successful'),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits loading then error when the repo returns an error',
    build: () {
      when(() => repo.register(request)).thenAnswer(
        (_) async => Error<AppError>(
          const AppError(message: 'Email already exists', code: 'fail'),
        ),
      );
      return RegisterCubit(registerRepo: repo);
    },
    act: (cubit) => cubit.register(request),
    expect: () => [
      loadingState(),
      stateWith(Status.error, 'Email already exists'),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'keeps the last message when nothing new is provided',
    build: () {
      when(() => repo.register(request)).thenAnswer(
        (_) async => Success<RegisterResponseModel>(successResponse),
      );
      return RegisterCubit(registerRepo: repo);
    },
    seed: () => const RegisterState(
      status: Status.error,
      message: 'Previous error',
    ),
    act: (cubit) => cubit.register(request),
    expect: () => [
      stateWith(Status.loading, 'Previous error'),
      stateWith(Status.success, 'Registration successful'),
    ],
  );
}