// File: persons_api.dart
import 'dart:convert';
import 'dart:io' show HttpClient, X509Certificate;
import 'package:http/io_client.dart';
import 'package:practise/people/person.dart';

const String baseUrl = 'https://192.168.1.2:7074';
const String personsEndpoint = '$baseUrl/api/Persons';

class PersonsApi {
  static final IOClient client = IOClient(
    HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true,
  );

  static Future<List<Person>> getAll({int pageNumber = 1, int pageSize = 10}) async {
    try {
      final url = Uri.parse('$personsEndpoint/paging?pageNumber=$pageNumber&pageSize=$pageSize');
      final res = await client.get(url);
      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body) as Map<String, dynamic>;
        final dataList = jsonResponse['data'] as List<dynamic>;
        return dataList.map((e) => Person.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('حدث خطأ أثناء جلب الأشخاص: $e');
      return [];
    }
  }

  static Future<Person?> create(Person p) async {
    try {
      final res = await client.post(
        Uri.parse(personsEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(p.toJson()),
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        return Person.fromJson(jsonDecode(res.body));
      } else {
        return null;
      }
    } catch (e) {
      print('حدث خطأ أثناء إنشاء الشخص: $e');
      return null;
    }
  }

  static Future<Person?> update(int id, Person p) async {
    try {
      final res = await client.put(
        Uri.parse('$personsEndpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(p.toJson()),
      );
      if (res.statusCode == 200) {
        return Person.fromJson(jsonDecode(res.body));
      } else {
        return null;
      }
    } catch (e) {
      print('حدث خطأ أثناء تحديث الشخص: $e');
      return null;
    }
  }

  static Future<bool> delete(int id) async {
    try {
      final res = await client.delete(Uri.parse('$personsEndpoint/$id'));
      return res.statusCode == 204 || res.statusCode == 200 || res.statusCode == 404;
    } catch (e) {
      print('حدث خطأ أثناء حذف الشخص: $e');
      return false;
    }
  }
}
