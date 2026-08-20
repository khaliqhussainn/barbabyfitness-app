import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models/workout_api_model.dart';
import '../../auth/data/auth_service.dart';

class WorkoutApiService {
  // Android emulator  → 10.0.2.2
  // Windows/iOS desktop → localhost
  // Physical device    → your machine's LAN IP (run `ipconfig` on Windows)
  // TODO: replace with your server URL when deploying
  static const _base = 'http://YOUR_LAPTOP_IP:3000/api/workouts';

  static Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (auth) {
      final token = await AuthService.getToken();
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  static Future<List<WorkoutApiModel>> listWorkouts({String? category}) async {
    try {
      final uri = Uri.parse(_base).replace(
        queryParameters: category != null ? {'category': category} : null,
      );
      final response = await http.get(uri, headers: await _headers());
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        return (body['data'] as List)
            .map((e) => WorkoutApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<WorkoutApiModel?> getWorkout(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_base/$id'),
        headers: await _authHeaders(),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        return WorkoutApiModel.fromJson(body['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<List<WorkoutApiModel>> getSavedWorkouts() async {
    try {
      final response = await http.get(
        Uri.parse('$_base/saved'),
        headers: await _authHeaders(),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        return (body['data'] as List)
            .map((e) => WorkoutApiModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<bool> saveWorkout(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/$id/save'),
        headers: await _authHeaders(),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['success'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> unsaveWorkout(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_base/$id/save'),
        headers: await _authHeaders(),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['success'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<WorkoutApiModel?> createWorkout({
    required String title,
    required String description,
    required int durationMinutes,
    required String difficulty,
    String? category,
    String? imageUrl,
    List<Map<String, dynamic>> exercises = const [],
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_base),
        headers: await _authHeaders(),
        body: jsonEncode({
          'title': title,
          'description': description,
          'duration_minutes': durationMinutes,
          'difficulty': difficulty,
          'category': category,
          'image_url': imageUrl,
          'exercises': exercises,
        }),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        return await getWorkout((body['data'] as Map<String, dynamic>)['id'] as int);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateWorkout(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$_base/$id'),
        headers: await _authHeaders(),
        body: jsonEncode(data),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['success'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deleteWorkout(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_base/$id'),
        headers: await _authHeaders(),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['success'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> logSession({
    int? workoutId,
    required String workoutTitle,
    required int durationSeconds,
    required int caloriesBurned,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/sessions'),
        headers: await _authHeaders(),
        body: jsonEncode({
          'workout_id': workoutId,
          'workout_title': workoutTitle,
          'duration_seconds': durationSeconds,
          'calories_burned': caloriesBurned,
        }),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['success'] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getSessionHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_base/sessions'),
        headers: await _authHeaders(),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        return List<Map<String, dynamic>>.from(body['data'] as List);
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
