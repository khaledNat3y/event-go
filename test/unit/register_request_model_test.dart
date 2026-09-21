import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final model = RegisterRequestModel(
    name: 'John Doe',
    email: 'john@example.com',
    password: 'Password1',
    rePassword: 'Password1',
    phone: '01012345678',
  );

  group('RegisterRequestModel', () {
    test('toJson returns the expected map', () {
      expect(model.toJson(), {
        'name': 'John Doe',
        'email': 'john@example.com',
        'password': 'Password1',
        'rePassword': 'Password1',
        'phone': '01012345678',
      });
    });

    test('toJson reflects the exact field values', () {
      final json = model.toJson();
      expect(json['name'], model.name);
      expect(json['email'], model.email);
      expect(json['password'], model.password);
      expect(json['rePassword'], model.rePassword);
      expect(json['phone'], model.phone);
    });
  });
}