import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:template_getx/shared/utils/constants/api_constant.dart';
import 'package:template_getx/shared/utils/constants/storage_key.dart';

class LocalStorage{
  LocalStorage._(){
    _storage = const FlutterSecureStorage();
    _box = _initSecureBox;
  }

  /// Cukup memanggil instance singleton dari class LocalStorage untuk mengakses func setData, deleteData, dan mengambil data
  static LocalStorage get instance => LocalStorage._();

  late final FlutterSecureStorage _storage;
  late final Future<Box> _box;

  Future<Box> get _initSecureBox async{
    String encryptedKey = await _storage.read(key: StorageKey.encryptedKey) ?? '';

    if(encryptedKey.isEmpty){
      final key = Hive.generateSecureKey();
      await _storage.write(key: StorageKey.encryptedKey, value: base64UrlEncode(key));
      encryptedKey = (await _storage.read(key: StorageKey.encryptedKey))!;
    }

    final encryptionKeyUint8List = base64Url.decode(encryptedKey);
    return await Hive.openBox(StorageKey.box, encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
  }

  /// Untuk menyimpan data
  Future<void> setData<T>(String key, T value)async{
    (await _box).put(key, value);
  }

  /// Untuk menghapus data
  Future<void> deleteData() async {
    (await _box).delete(ApiConstant.token);
  }

  /// Untuk meng-akses data yang sudah disimpan
  Future<String> get token async => (await _box).get(ApiConstant.token) ?? "";
}