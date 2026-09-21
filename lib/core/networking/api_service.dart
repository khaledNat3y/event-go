// lib/core/network/api_service.dart

import 'package:dio/dio.dart';
import 'package:event_ticket_booking/core/networking/dio_factory.dart';

class ApiService {
  final DioFactory _dioFactory;

  ApiService(this._dioFactory);

  Future<Response> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await _dioFactory.dio.get(endPoint, queryParameters: queryParams);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postRequest({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dioFactory.dio.post(endPoint, data: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> putRequest({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dioFactory.dio.put(endPoint, data: body);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dioFactory.dio.delete(endPoint, data: body);
    } catch (e) {
      rethrow;
    }
  }
}
