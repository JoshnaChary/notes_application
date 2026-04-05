import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:notes_application/core/config/app_config.dart';

/// Sample PostgREST row for `notes` table (matches [Note.fromSupabase]).
Map<String, dynamic> testNoteJson({
  String id = '550e8400-e29b-41d4-a716-446655440000',
  String title = 'Hello',
  String body = 'World',
  String category = 'WORK',
  String colorHex = '#FF0000',
  DateTime? createdAt,
  DateTime? updatedAt,
  bool pinned = false,
  bool favourite = false,
  String? imageUrl,
}) {
  final c = createdAt ?? DateTime.utc(2024, 6, 1, 12);
  final u = updatedAt ?? DateTime.utc(2024, 6, 2, 12);
  return {
    'id': id,
    'title': title,
    'body': body,
    'category': category,
    'color_hex': colorHex,
    'created_at': c.toIso8601String(),
    'updated_at': u.toIso8601String(),
    'is_pinned': pinned,
    'is_favourite': favourite,
    'image_url': imageUrl,
  };
}

/// HTTP stub with [StreamedResponse.request] set so PostgREST can parse responses.
class NotesRestStubClient extends http.BaseClient {
  NotesRestStubClient({
    List<Map<String, dynamic>>? rows,
    int failGetTimes = 0,
    bool failPost = false,
    bool failPatch = false,
    bool failDelete = false,
  })  : _rows = List<Map<String, dynamic>>.from(rows ?? [testNoteJson()]),
        _failGetRemaining = failGetTimes,
        _failPost = failPost,
        _failPatch = failPatch,
        _failDelete = failDelete;

  List<Map<String, dynamic>> _rows;
  int _failGetRemaining;
  final bool _failPost;
  final bool _failPatch;
  final bool _failDelete;

  List<Map<String, dynamic>> get rows => List.unmodifiable(_rows);

  void replaceRows(List<Map<String, dynamic>> rows) {
    _rows = List<Map<String, dynamic>>.from(rows);
  }

  http.StreamedResponse _respond(
    http.BaseRequest request,
    String body,
    int status, {
    Map<String, String> headers = const {},
  }) {
    return http.StreamedResponse(
      Stream.value(utf8.encode(body)),
      status,
      headers: {'content-type': 'application/json', ...headers},
      request: request,
    );
  }

  http.StreamedResponse _empty(http.BaseRequest request, int status) {
    return http.StreamedResponse(
      const Stream.empty(),
      status,
      request: request,
    );
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final path = request.url.path;

    if (path.contains('/auth/')) {
      return _respond(request, '{}', 200);
    }

    if (!path.contains('/rest/v1/notes')) {
      return _respond(request, '"not found"', 404);
    }

    switch (request.method) {
      case 'GET':
        if (_failGetRemaining > 0) {
          _failGetRemaining--;
          return _respond(
            request,
            '{"message":"stub failure","code":"stub"}',
            500,
          );
        }
        return _respond(request, jsonEncode(_rows), 200);
      case 'POST':
        if (_failPost) {
          return _respond(
            request,
            '{"message":"insert failed"}',
            500,
          );
        }
        var raw = '';
        if (request is http.Request) {
          raw = request.body;
        }
        expect(raw, isNotEmpty);
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        expect(decoded['user_id'], AppConfig.hardcodedUserId);
        return _respond(request, jsonEncode(testNoteJson()), 201);
      case 'PATCH':
        if (_failPatch) {
          return _respond(request, '{"message":"update failed"}', 500);
        }
        return _respond(
          request,
          jsonEncode(
            testNoteJson(pinned: true, favourite: true),
          ),
          200,
        );
      case 'DELETE':
        if (_failDelete) {
          return _respond(request, '{"message":"delete failed"}', 500);
        }
        return _empty(request, 204);
      default:
        return _respond(request, '"unsupported"', 500);
    }
  }
}
