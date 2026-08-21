import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthResult {
  final bool success;
  final String message;
  final String? token;

  const AuthResult({required this.success, required this.message, this.token});
}

class AuthService {
  // Android emulator  → 10.0.2.2
  // Windows/iOS desktop → localhost
  // Physical device    → your machine's LAN IP (run `ipconfig` on Windows)
  // TODO: replace with your server URL when deploying
  static const _base = 'http://192.168.100.25:3000/api/auth';

  static const _tokenKey = 'auth_token';

  // ── Token helpers ─────────────────────────────────────

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── API calls ─────────────────────────────────────────

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 201 && body['success'] == true) {
        await saveToken(body['token'] as String);
        return AuthResult(success: true, message: 'Account created', token: body['token'] as String);
      }
      return AuthResult(success: false, message: body['message'] as String? ?? 'Registration failed');
    } catch (e) {
      return AuthResult(success: false, message: 'Cannot connect to server');
    }
  }

  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && body['success'] == true) {
        await saveToken(body['token'] as String);
        return AuthResult(success: true, message: 'Logged in', token: body['token'] as String);
      }
      return AuthResult(success: false, message: body['message'] as String? ?? 'Login failed');
    } catch (e) {
      return AuthResult(success: false, message: 'Cannot connect to server');
    }
  }

  static Future<AuthResult> forgotPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResult(
        success: body['success'] == true,
        message: body['message'] as String? ?? 'Request sent',
      );
    } catch (e) {
      return AuthResult(success: false, message: 'Cannot connect to server');
    }
  }

  static Future<AuthResult> resetPassword({
    required String token,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_base/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token, 'password': password}),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResult(
        success: body['success'] == true,
        message: body['message'] as String? ?? 'Password updated',
      );
    } catch (e) {
      return AuthResult(success: false, message: 'Cannot connect to server');
    }
  }

  static Future<void> logout() => clearToken();

  // ── Profile API ───────────────────────────────────────────

  static Future<Map<String, dynamic>?> me() async {
    try {
      final token = await getToken();
      if (token == null) return null;
      final response = await http.get(
        Uri.parse('$_base/me'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) return body['data'] as Map<String, dynamic>;
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<AuthResult> updateProfile({
    String? name,
    String? email,
    String? age,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      final token = await getToken();
      final payload = <String, dynamic>{};
      if (name != null) payload['name'] = name;
      if (email != null) payload['email'] = email;
      if (age != null) payload['age'] = age.isEmpty ? null : int.tryParse(age);
      if (currentPassword != null) payload['current_password'] = currentPassword;
      if (newPassword != null) payload['new_password'] = newPassword;
      final response = await http.put(
        Uri.parse('$_base/profile'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode(payload),
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResult(
        success: body['success'] == true,
        message: body['message'] as String? ?? '',
      );
    } catch (_) {
      return const AuthResult(success: false, message: 'Cannot connect to server');
    }
  }

  static Future<bool> deleteAccount() async {
    try {
      final token = await getToken();
      final response = await http.delete(
        Uri.parse('$_base/account'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (body['success'] == true) {
        await clearToken();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
