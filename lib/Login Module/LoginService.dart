import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_tutor_system/api_mixin.dart';

class LoginService with ApiMixin{
  final BuildContext context;

  LoginService(this.context);

  Future<void> loginUser(String email, String password) async{

    // Generate the API URL dynamically using ApiMixin
    final Uri url = generateUri('tusyen/login');

    if(email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Please fill all form.', style: TextStyle(color: Colors.white)),
          )
      );
      return;
    }

    final Map<String, String> body = {
      "email": email,
      "password": password,
    };

    try{
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
      );

      print("Raw Response: ${response.body}");
      print("Status code: ${response.statusCode}");

      final data = jsonDecode(response.body);

      if(response.statusCode == 200){
        if(data['status'] == 'success'){
          int userID = data['userID'];
           String role = data['role_type'];

          // Display the userID from response
          print(userID);

          // Store userId in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userID', userID);
          await prefs.setString('role_type', role);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.green,
                content: Text('Login Success')
            )
          );

          /*context.go('/student_home');*/
          // Navigate based on role
          if(role == 'S'){
            context.go('/student_home');
          }else if(role == 'T'){
            context.go('/teacher_home');
          }else if(role == 'A') {
            context.go('/admin_home');
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                  content: Text('Invalid role: $role. Please contact support.', style: TextStyle(color: Colors.white))
              )
            );
          }

        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.red,
                content: Text('Login Failed', style: TextStyle(color: Colors.white))
            )
          );
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Login Failed. Please try again', style: TextStyle(color: Colors.white))
          )
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occured: $e'))
      );
      print(e);
    }
  }
}