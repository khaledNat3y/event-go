import 'package:event_ticket_booking/features/register/data/models/register_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegisterResponseModel.fromJson', () {
    test('parses a full response with a user and token', () {
      final json = {
        'message': 'Registration successful',
        'user': {
          'name': 'John Doe',
          'email': 'john@example.com',
          'role': 'user',
        },
        'token': 'abc123',
      };

      final model = RegisterResponseModel.fromJson(json);

      expect(model.message, 'Registration successful');
      expect(model.token, 'abc123');
      expect(model.user, isNotNull);
      expect(model.user!.name, 'John Doe');
      expect(model.user!.email, 'john@example.com');
      expect(model.user!.role, 'user');
    });

    test('handles missing user', () {
      final model = RegisterResponseModel.fromJson({
        'message': 'No user',
        'token': 'xyz',
      });

      expect(model.user, isNull);
      expect(model.token, 'xyz');
    });

    test('handles empty json', () {
      final model = RegisterResponseModel.fromJson({});

      expect(model.message, isNull);
      expect(model.token, isNull);
      expect(model.user, isNull);
    });
  });

  group('RegisterResponseModel.toJson', () {
    test('round-trips a full model', () {
      final model = RegisterResponseModel(
        message: 'Registration successful',
        user: User(name: 'John Doe', email: 'john@example.com', role: 'user'),
        token: 'abc123',
      );

      final json = model.toJson();

      expect(json['message'], 'Registration successful');
      expect(json['token'], 'abc123');
      expect(json['user'], {
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'user',
      });
    });

    test('omits user when null', () {
      final model = RegisterResponseModel(message: 'msg', token: 'tok');

      final json = model.toJson();

      expect(json.containsKey('user'), isFalse);
    });

    test('fromJson(toJson()) preserves data', () {
      final original = RegisterResponseModel.fromJson({
        'message': 'ok',
        'user': {'name': 'A', 'email': 'a@b.c', 'role': 'admin'},
        'token': 'tok',
      });

      final restored = RegisterResponseModel.fromJson(original.toJson());

      expect(restored.message, original.message);
      expect(restored.token, original.token);
      expect(restored.user!.name, original.user!.name);
      expect(restored.user!.email, original.user!.email);
      expect(restored.user!.role, original.user!.role);
    });
  });

  group('User', () {
    test('toJson returns expected map', () {
      final user = User(
        name: 'John',
        email: 'john@example.com',
        role: 'user',
      );

      expect(user.toJson(), {
        'name': 'John',
        'email': 'john@example.com',
        'role': 'user',
      });
    });

    test('fromJson omits role when null', () {
      final user = User.fromJson({'name': 'John'});

      expect(user.name, 'John');
      expect(user.email, isNull);
      expect(user.role, isNull);
    });
  });
}