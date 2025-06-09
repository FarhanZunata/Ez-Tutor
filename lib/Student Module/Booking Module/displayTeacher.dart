import 'dart:convert';
import 'package:ez_tutor_system/api_mixin.dart';
import 'package:http/http.dart' as http;

class TeacherModel {
  final int userID;
  final String fullname;
  
  TeacherModel({required this.userID, required this.fullname});
  
  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
        userID: json['userID'],
        fullname: json['full_name'],
    );
  }
}

class TeacherService with ApiMixin {
  Future<List<TeacherModel>> fetchTeachers() async {
    final Uri url = generateUri('tusyen/teachers');
    print('Fetching teachers from: $url');

    final response = await http.get(url);

    if (response.statusCode == 200){
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return (data['teachers'] as List)
            .map((json) => TeacherModel.fromJson(json))
            .toList();
      } else {
        throw Exception("Error from server: ${data['message']}");
      }
    } else {
      throw Exception("HTTP error: ${response.statusCode}");
    }
  }
}