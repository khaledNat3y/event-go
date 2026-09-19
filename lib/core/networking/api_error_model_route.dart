class ApiErrorModelRoute {
  String? statusMsg;
  String? message;

  ApiErrorModelRoute({this.statusMsg, this.message});

  ApiErrorModelRoute.fromJson(Map<String, dynamic> json) {
    statusMsg = json['statusMsg'];
    message = json['message'];
  }
}
