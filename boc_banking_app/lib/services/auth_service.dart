import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'security_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _security = SecurityService();
  static const String baseUrl = 'http://localhost:8080/api';

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      // Simulate API call - Replace with actual endpoint
      await Future.delayed(const Duration(seconds: 1));

      // Mock successful login
      if (username == 'demo' && password == 'password') {
        final user = User(
          id: '1',
          fullName: 'Thurga Rajinathan',
          accountNumber: '****4551',
          email: 'thurga@boc.lk',
          phoneNumber: '+94771234567',
        );

        const token = 'mock.jwt.token.here.for.demo';
        await _security.saveToken(token);

        return {
          'success': true,
          'user': user,
          'token': token,
        };
      }

      return {
        'success': false,
        'error': 'Invalid credentials',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String accountNumber,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final user = User(
        id: '2',
        fullName: fullName,
        accountNumber: accountNumber,
        email: '$accountNumber@boc.lk',
      );

      const token = 'mock.jwt.token.here.for.signup';
      await _security.saveToken(token);

      return {
        'success': true,
        'user': user,
        'token': token,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> googleSignIn(String googleToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': googleToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _security.saveToken(data['token']);

        return {
          'success': true,
          'user': User.fromJson(data['user']),
          'token': data['token'],
        };
      }

      return {
        'success': false,
        'error': 'Google sign-in failed',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  Future<void> logout() async {
    await _security.clearToken();
    await _security.deleteAllSecureData();
  }

  Future<bool> isLoggedIn() async {
    final token = await _security.getToken();
    return token != null && token.isNotEmpty;
  }
}
