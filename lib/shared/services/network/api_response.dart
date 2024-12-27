import 'dart:convert';

/// Untuk T sendiri adalah generic type, jadi anda hanya perlu define dalam bentuk apa variabel data tersebut, bisa dalam bentuk apa saja
class ApiResponse<T> {
  ApiResponse({this.data, required this.code, required this.message, required this.error});

  final T? data;
  final int code;
  final String message;
  final bool error;

  ApiResponse<T> copyWith({
    T? data,
    int? code,
    String? message,
    bool? success,
  }) {
    return ApiResponse<T>(
      data: data ?? data,
      code: code ?? this.code,
      message: message ?? this.message,
      error: success ?? this.error,
    );
  }

  factory ApiResponse.fromRawJson(String str) => ApiResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    data: json["data"],
    code: json["code"],
    message: json["message"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "code": code,
    "message": message,
    "error": error,
  };
}