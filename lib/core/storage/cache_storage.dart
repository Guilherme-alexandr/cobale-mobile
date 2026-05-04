// lib/core/storage/cache_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../../features/home/models/home_item_model.dart';

class CacheStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _keyHomeCache = 'home_cache';
  static const int _cacheDurationMinutes = 5;

  Future<void> saveHomeCache(List<HomeItem> itens) async {
    final cacheData = {
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'itens': itens.map((i) => i.toJson()).toList(),
    };
    await _storage.write(key: _keyHomeCache, value: jsonEncode(cacheData));
  }

  Future<List<HomeItem>?> getHomeCache() async {
    final cached = await _storage.read(key: _keyHomeCache);
    if (cached == null) return null;

    try {
      final data = jsonDecode(cached);
      final timestamp = data['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      if (now - timestamp > _cacheDurationMinutes * 60 * 1000) {
        return null;
      }

      final itensJson = data['itens'] as List;

      return itensJson
          .map((json) => HomeItem.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
