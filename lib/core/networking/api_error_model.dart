class ApiErrorModel {
  final Fault? fault;

  ApiErrorModel({this.fault});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) => ApiErrorModel(
    fault: json["fault"] == null ? null : Fault.fromJson(json["fault"]),
  );
}

class Fault {
  final String? faultstring;
  final Detail? detail;

  Fault({this.faultstring, this.detail});

  factory Fault.fromJson(Map<String, dynamic> json) => Fault(
    faultstring: json["faultstring"],
    detail: json["detail"] == null ? null : Detail.fromJson(json["detail"]),
  );
}

class Detail {
  final String? errorcode;

  Detail({this.errorcode});

  factory Detail.fromJson(Map<String, dynamic> json) =>
      Detail(errorcode: json["errorcode"]);
}
