Untuk model yang digunakan di lebih dari 1 fitur







jika ada 2 API memiliki response yang hampir mirip cukup buat 1 model. Jangan buat bermacam macam model, apalagi ketika response nya banyak
dan biasanya akan memiliki model yang sama.

Intinya cukup 1 model

Misal

API driver
{
"status": "success",
"message": "Data retrieved successfully",
"data": {
"id": 1,
"name": "John Doe",
"email": "john.doe@example.com",
"role": "driver",
"created_at": "2024-12-26T10:00:00Z",
"updated_at": "2024-12-26T10:15:00Z",
"last_login": "2024-12-25T09:30:00Z",
}
}

API admin
{
"status": "success",
"message": "Data retrieved successfully",
"data": {
"id": 1,
"name": "John Doe",
"email": "john.doe@example.com",
"role": "admin",
"created_at": "2024-12-26T10:00:00Z",
"updated_at": "2024-12-26T10:15:00Z",
"last_login": "2024-12-25T09:30:00Z",
"permissions": ["view_users", "edit_roles", "manage_system"]
}
}

cukup buat 1 model dengan nama UserModel. Dengan property yang ada di dalam nya bersifat nullable, dengan bentuk class seperti ini

--------------------------------------------------------------------------------------------------------------------------------------------

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
int? id;
String? name;
String? email;
String? role;
DateTime? createdAt;
DateTime? updatedAt;
DateTime? lastLogin;
List<String>? permissions;

    UserModel({
        this.id,
        this.name,
        this.email,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.lastLogin,
        this.permissions,
    });

    UserModel copyWith({
        int? id,
        String? name,
        String? email,
        String? role,
        DateTime? createdAt,
        DateTime? updatedAt,
        DateTime? lastLogin,
        List<String>? permissions,
    }) => 
        UserModel(
            id: id ?? this.id,
            name: name ?? this.name,
            email: email ?? this.email,
            role: role ?? this.role,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            lastLogin: lastLogin ?? this.lastLogin,
            permissions: permissions ?? this.permissions,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        lastLogin: json["last_login"] == null ? null : DateTime.parse(json["last_login"]),
        permissions: json["permissions"] == null ? [] : List<String>.from(json["permissions"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "last_login": lastLogin?.toIso8601String(),
        "permissions": permissions == null ? [] : List<dynamic>.from(permissions!.map((x) => x)),
    };
}

--------------------------------------------------------------------------------------------------------------------------------------------

jadi di repository cukup seperti berikut

final response = UserModel.fromJson(response.data["data"]);