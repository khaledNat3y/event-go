import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();
  // ticket master
  static const String ticketMasterBaseUrl =
      "https://app.ticketmaster.com/discovery/v2/";
  static const String events = 'events.json';
  static String eventById(String id) => 'events/$id.json';
  static String apiKey = dotenv.get('API_KEY');

  static const int pageSize = 20;
  static const String defaultCountryCode = 'US';
  // route
  static const String routeBaseUrl = "https://ecommerce.routemisr.com";
  static const String registerEndPoint = "/api/v1/auth/signup";
  static const String loginEndPoint = "/api/v1/auth/signin";
}
