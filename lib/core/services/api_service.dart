import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'supabase_service.dart';

/// API Service for communicating with Go backend
class ApiService {
  static ApiService? _instance;
  static ApiService get instance {
    _instance ??= ApiService._();
    return _instance!;
  }

  ApiService._();

  final String _baseUrl = AppConstants.goApiBaseUrl;
  final Duration _timeout = const Duration(seconds: 30);

  // ============ HTTP HELPERS ============

  /// Get auth headers
  Future<Map<String, String>> _getHeaders() async {
    final token = SupabaseService.instance.auth.currentSession?.accessToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Handle response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (kDebugMode) {
      print('API Response [${response.statusCode}]: ${response.body}');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return ApiResponse.success(fromJson(data));
      }
      throw ApiException('Invalid response format');
    } else if (response.statusCode == 401) {
      throw ApiException('Unauthorized', code: 401);
    } else if (response.statusCode == 403) {
      throw ApiException('Forbidden', code: 403);
    } else if (response.statusCode == 404) {
      throw ApiException('Not found', code: 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Server error', code: response.statusCode);
    } else {
      final error = json.decode(response.body);
      throw ApiException(
        error['message'] ?? 'Unknown error',
        code: response.statusCode,
      );
    }
  }

  /// Handle list response
  ApiResponse<List<T>> _handleListResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = json.decode(response.body);
      if (data is List) {
        return ApiResponse.success(
          data.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
        );
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        return ApiResponse.success(
          (data['data'] as List)
              .map((e) => fromJson(e as Map<String, dynamic>))
              .toList(),
          pagination: data['pagination'] != null
              ? PaginationMeta.fromJson(data['pagination'])
              : null,
        );
      }
      throw ApiException('Invalid response format');
    }
    throw ApiException('Request failed', code: response.statusCode);
  }

  // ============ HTTP METHODS ============

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);
      final headers = await _getHeaders();
      final response = await http.get(uri, headers: headers).timeout(_timeout);
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  /// GET list request
  Future<ApiResponse<List<T>>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse(
        '$_baseUrl$endpoint',
      ).replace(queryParameters: queryParams);
      final headers = await _getHeaders();
      final response = await http.get(uri, headers: headers).timeout(_timeout);
      return _handleListResponse(response, fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http
          .post(uri, headers: headers, body: json.encode(body))
          .timeout(_timeout);
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http
          .put(uri, headers: headers, body: json.encode(body))
          .timeout(_timeout);
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final uri = Uri.parse('$_baseUrl$endpoint');
      final headers = await _getHeaders();
      final response = await http
          .delete(uri, headers: headers)
          .timeout(_timeout);
      return _handleResponse(response, fromJson);
    } on SocketException {
      throw ApiException('No internet connection');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Request failed: $e');
    }
  }

  // ============ WALLET ENDPOINTS (Go Backend) ============

  /// Transfer currency to another user
  Future<ApiResponse<Map<String, dynamic>>> transfer({
    required String toUserId,
    required String currency, // 'spark' or 'orb'
    required int amount,
    String? note,
  }) async {
    return post(
      ApiEndpoints.transfer,
      (json) => json,
      body: {
        'to_user_id': toUserId,
        'currency': currency,
        'amount': amount,
        if (note != null) 'note': note,
      },
    );
  }

  // ============ QUEST ENDPOINTS (Go Backend) ============

  /// Get available quests
  Future<ApiResponse<List<Map<String, dynamic>>>> getQuests({
    String? type,
    int limit = 20,
    int offset = 0,
  }) async {
    return getList(
      ApiEndpoints.quests,
      (json) => json,
      queryParams: {
        if (type != null) 'type': type,
        'limit': limit.toString(),
        'offset': offset.toString(),
      },
    );
  }

  /// Start a quest
  Future<ApiResponse<Map<String, dynamic>>> startQuest(String questId) async {
    return post('${ApiEndpoints.quests}/$questId/start', (json) => json);
  }

  /// Claim quest reward
  Future<ApiResponse<Map<String, dynamic>>> claimQuestReward(
    String questId,
  ) async {
    return post('${ApiEndpoints.claimReward}/$questId', (json) => json);
  }

  // ============ MISSION ENDPOINTS ============

  /// Get daily missions
  Future<ApiResponse<List<Map<String, dynamic>>>> getDailyMissions() async {
    return getList(ApiEndpoints.dailyMissions, (json) => json);
  }

  /// Claim mission reward
  Future<ApiResponse<Map<String, dynamic>>> claimMissionReward(
    String missionId,
  ) async {
    return post('${ApiEndpoints.missions}/$missionId/claim', (json) => json);
  }
}

// ============ API RESPONSE CLASSES ============

class ApiResponse<T> {
  final T? data;
  final String? error;
  final PaginationMeta? pagination;

  ApiResponse._({this.data, this.error, this.pagination});

  factory ApiResponse.success(T data, {PaginationMeta? pagination}) {
    return ApiResponse._(data: data, pagination: pagination);
  }

  factory ApiResponse.failure(String error) {
    return ApiResponse._(error: error);
  }

  bool get isSuccess => error == null;
}

class PaginationMeta {
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 20,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? code;

  ApiException(this.message, {this.code});

  @override
  String toString() => 'ApiException: $message (code: $code)';
}
