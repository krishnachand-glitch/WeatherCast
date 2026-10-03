import 'package:dio/dio.dart';
import 'dart:developer' as developer;

class CachedResponse {
  final Map<String, dynamic> data;
  final DateTime timestamp;

  CachedResponse({required this.data, required this.timestamp});
  
  bool get isValid => DateTime.now().difference(timestamp).inMinutes < 5;
}

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  late Dio _dio;
  final Map<String, CachedResponse> _cache = {};

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
    
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log('API Request: ${options.uri}');
          return handler.next(options);
        },
        onError: (e, handler) {
          developer.log('API Error: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(String url) async {
    if (_cache.containsKey(url) && _cache[url]!.isValid) {
      return _cache[url]!.data;
    }

    int attempts = 0;
    const maxAttempts = 3;
    final backoffs = [1, 2, 4];

    while (attempts < maxAttempts) {
      try {
        final response = await _dio.get(url);
        final data = response.data as Map<String, dynamic>;
        
        _cache[url] = CachedResponse(data: data, timestamp: DateTime.now());
        
        return data;
      } on DioException catch (e) {
        attempts++;
        if (attempts >= maxAttempts) {
          throw Exception('API Request failed after $maxAttempts attempts: ${e.message}');
        }
        await Future.delayed(Duration(seconds: backoffs[attempts - 1]));
      } catch (e) {
        throw Exception('Unexpected error: $e');
      }
    }
    throw Exception('Failed to fetch data');
  }
}
