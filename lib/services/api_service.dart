import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/member.dart';

class ApiService {
  // Reemplazar con la URL IP de tu servidor backend Node.js
  final String baseUrl = "http://192.168.1.149:5000/api";
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: "auth_token");
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  Future<List<Member>> fetchMembers() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/members"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Member.fromJson(item)).toList();
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
