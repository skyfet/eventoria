import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:8080');

Future<List<dynamic>> fetchObjects() async {
  final res = await http.get(Uri.parse('$baseUrl/objects'));
  if (res.statusCode != 200) throw Exception('Failed to load objects');
  return jsonDecode(res.body) as List<dynamic>;
}

Future<Map<String, dynamic>> createObject(Map<String, dynamic> data) async {
  final res = await http.post(
    Uri.parse('$baseUrl/objects'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (res.statusCode != 201) throw Exception('Failed to create object');
  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<void> updateObject(int id, Map<String, dynamic> data) async {
  final res = await http.put(
    Uri.parse('$baseUrl/objects/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (res.statusCode != 200) throw Exception('Failed to update object');
}

Future<void> deleteObject(int id) async {
  final res = await http.delete(Uri.parse('$baseUrl/objects/$id'));
  if (res.statusCode != 204) throw Exception('Failed to delete object');
}

Future<List<dynamic>> fetchWorkLogs() async {
  final res = await http.get(Uri.parse('$baseUrl/worklogs'));
  if (res.statusCode != 200) throw Exception('Failed to load worklogs');
  return jsonDecode(res.body) as List<dynamic>;
}

Future<Map<String, dynamic>> createWorkLog(Map<String, dynamic> data) async {
  final res = await http.post(
    Uri.parse('$baseUrl/worklogs'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (res.statusCode != 201) throw Exception('Failed to create worklog');
  return jsonDecode(res.body) as Map<String, dynamic>;
}

Future<void> updateWorkLog(int id, Map<String, dynamic> data) async {
  final res = await http.put(
    Uri.parse('$baseUrl/worklogs/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );
  if (res.statusCode != 200) throw Exception('Failed to update worklog');
}

Future<void> deleteWorkLog(int id) async {
  final res = await http.delete(Uri.parse('$baseUrl/worklogs/$id'));
  if (res.statusCode != 204) throw Exception('Failed to delete worklog');
}
