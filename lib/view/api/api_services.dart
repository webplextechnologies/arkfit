import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  //Common GET request
  static Future<http.Response> getRequest(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final reqHeaders = Map<String, String>.from(headers ?? {});
      reqHeaders.putIfAbsent('Content-Type', () => 'application/json');

      if (!reqHeaders.containsKey('Authorization')) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          print('token : $token');
          reqHeaders['Authorization'] = 'Bearer $token';
        }
      }
      final response = await http.get(Uri.parse(url), headers: reqHeaders);

      return response;
    } catch (e) {
      throw Exception('GET request error: $e');
    }
  }

  static Future<http.Response> postRequest(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final reqHeaders = Map<String, String>.from(headers ?? {});
      reqHeaders.putIfAbsent('Content-Type', () => 'application/json');
      if (!reqHeaders.containsKey('Authorization')) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          print('token : $token');
          reqHeaders['Authorization'] = 'Bearer $token';
        }
      }
      final response = await http.post(
        Uri.parse(url),
        headers: reqHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return response;
    } catch (e) {
      throw Exception('POST request error: $e');
    }
  }

  static Future<http.Response> putRequest(
    String url, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final reqHeaders = Map<String, String>.from(headers ?? {});
      reqHeaders.putIfAbsent('Content-Type', () => 'application/json');
      if (!reqHeaders.containsKey('Authorization')) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          print('token : $token');
          reqHeaders['Authorization'] = 'Bearer $token';
        }
      }
      final response = await http.put(
        Uri.parse(url),
        headers: reqHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      return response;
    } catch (e) {
      throw Exception('PUT request error: $e');
    }
  }

  static Future<http.Response> deleteRequest(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final reqHeaders = Map<String, String>.from(headers ?? {});
      reqHeaders.putIfAbsent('Content-Type', () => 'application/json');

      if (!reqHeaders.containsKey('Authorization')) {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null && token.isNotEmpty) {
          print('token : $token');
          reqHeaders['Authorization'] = 'Bearer $token';
        }
      }

      final response = await http.delete(Uri.parse(url), headers: reqHeaders);

      return response;
    } catch (e) {
      throw Exception('DELETE request error: $e');
    }
  }

  static Future<http.StreamedResponse> multipartRequest(
  String url, {
  String method = 'POST',
  Map<String, String>? headers,
  Map<String, String>? fields,
  Map<String, File>? files, 
}) async {
  try {
    final uri = Uri.parse(url);
    final request = http.MultipartRequest(method, uri);

    
    final reqHeaders = Map<String, String>.from(headers ?? {});
    reqHeaders.remove('Content-Type');

    if (!reqHeaders.containsKey('Authorization')) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        print('token : $token');
        reqHeaders['Authorization'] = 'Bearer $token';
      }
    }

    request.headers.addAll(reqHeaders);

    if (fields != null) {
      request.fields.addAll(fields);
    }

    // 🖼 Files
    if (files != null) {
      for (final entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
          ),
        );
      }
    }

    return await request.send();
  } catch (e) {
    throw Exception('MULTIPART request error: $e');
  }
}
}
