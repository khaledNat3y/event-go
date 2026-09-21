import 'package:dio/dio.dart';
import 'package:event_ticket_booking/core/helper/app_constants.dart';
import 'package:event_ticket_booking/core/networking/api_constants.dart';
import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/api_service.dart';
import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:event_ticket_booking/features/register/data/models/register_response_model.dart';
import 'package:event_ticket_booking/features/register/data/repos/register_repo.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApiService extends Mock implements ApiService {}

class _InMemorySecureStorage extends FlutterSecureStoragePlatform {
  final Map<String, String> store = {};

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) async {
    store[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) async => store[key];

  @override
  Future<bool> containsKey({
    required String key,
    required Map<String, String> options,
  }) async => store.containsKey(key);

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) async {
    store.remove(key);
  }

  @override
  Future<Map<String, String>> readAll({
    required Map<String, String> options,
  }) async => Map.of(store);

  @override
  Future<void> deleteAll({required Map<String, String> options}) async {
    store.clear();
  }
}

void main() {
  late MockApiService apiService;
  late RegisterRepo repo;
  late _InMemorySecureStorage secureStorage;

  final request = RegisterRequestModel(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'Password1',
    rePassword: 'Password1',
    phone: '01012345678',
  );

  setUp(() {
    apiService = MockApiService();
    repo = RegisterRepo(apiService);
    secureStorage = _InMemorySecureStorage();
    FlutterSecureStoragePlatform.instance = secureStorage;
  });

  group('RegisterRepo.register', () {
    test('calls postRequest with the register endpoint and request body', () async {
      when(
        () => apiService.postRequest(
          endPoint: ApiConstants.registerEndPoint,
          body: request.toJson(),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.registerEndPoint),
          statusCode: 201,
          data: {
            'message': 'Registration successful',
            'token': 'tok',
            'user': {'name': 'John Doe', 'email': 'john@example.com', 'role': 'user'},
          },
        ),
      );

      await repo.register(request);

      verify(
        () => apiService.postRequest(
          endPoint: ApiConstants.registerEndPoint,
          body: request.toJson(),
        ),
      ).called(1);
    });

    test('returns Success and stores the token on a 2xx response', () async {
      when(
        () => apiService.postRequest(
          endPoint: any(named: 'endPoint'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 201,
          data: {
            'message': 'Registration successful',
            'token': 'abc123',
            'user': {'name': 'John Doe', 'email': 'john@example.com', 'role': 'user'},
          },
        ),
      );

      final result = await repo.register(request);

      expect(result, isA<Success>());
      final data = (result as Success).data as RegisterResponseModel;
      expect(data.message, 'Registration successful');
      expect(data.token, 'abc123');
      expect(secureStorage.store[AppConstants.tokenKey], 'abc123');
    });

    test('returns Error with UNKNOWN_ERROR for a non-2xx status', () async {
      when(
        () => apiService.postRequest(
          endPoint: any(named: 'endPoint'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 409,
          data: {'message': 'Email already exists', 'statusMsg': 'fail'},
        ),
      );

      final result = await repo.register(request);

      expect(result, isA<Error>());
      final error = (result as Error).error;
      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, 'UNKNOWN_ERROR');
    });

    test('returns Error when a DioException is thrown', () async {
      when(
        () => apiService.postRequest(
          endPoint: any(named: 'endPoint'),
          body: any(named: 'body'),
        ),
      ).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''), 
        ),
      );

      final result = await repo.register(request);

      expect(result, isA<Error>());
      final error = (result as Error).error;
      expect(error.code, 'NETWORK_ERROR');
    });

    test('does not store a token when registration fails', () async {
      when(
        () => apiService.postRequest(
          endPoint: any(named: 'endPoint'),
          body: any(named: 'body'),
        ),
      ).thenThrow(DioException(
        type: DioExceptionType.unknown,
        requestOptions: RequestOptions(path: ''),
      ));

      await repo.register(request);

      expect(secureStorage.store, isEmpty);
    });
  });
}