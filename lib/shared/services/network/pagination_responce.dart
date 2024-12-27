import 'dart:convert';

/// Untuk T sendiri adalah generic type, jadi anda hanya perlu define dalam bentuk apa variabel data tersebut, bisa dalam bentuk apa saja
/// Untuk pagination response, T wajib berbentuk tipe data list.
class PaginationResponse<T> {
  PaginationResponse({this.data, required this.lastPage, required this.code, required this.message, required this.error});

  final T? data;
  final int lastPage;
  final int code;
  final String message;
  final bool error;

  PaginationResponse<T> copyWith({
    T? data,
    int? lastPage,
    int? code,
    String? message,
    bool? success,
  }) {
    return PaginationResponse<T>(
      data: data ?? this.data,
      lastPage: lastPage ?? this.lastPage,
      code: code ?? this.code,
      message: message ?? this.message,
      error: success ?? this.error,
    );
  }

  factory PaginationResponse.fromRawJson(String str) => PaginationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaginationResponse.fromJson(Map<String, dynamic> json) => PaginationResponse(
    data: json["data"],
    lastPage: json["last_page"],
    code: json["code"],
    message: json["message"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "last_page": lastPage,
    "code": code,
    "message": message,
    "error": error,
  };
}