import 'package:ez_tutor_system/api_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService with ApiMixin{
  final BuildContext context;

  RegisterService(this.context);

  Future<void> registerUser(String fullname, String email, String hpnumber, String password, String confirmPassword, String role) async{
    final Uri url = generateUri('tusyen/register');

    if(fullname.isEmpty || email.isEmpty || hpnumber.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text('All fields are required', style: TextStyle(color: Colors.white))
        )
      );
      return;
    }

    if(confirmPassword != password){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text('Password not match', style: TextStyle(color: Colors.white))
        )
      );
      return;
    }

    final Map<String, String> body = {
      "fullname": fullname,
      "email": email,
      "hpnumber": hpnumber,
      "password": password,
      "role_type": role,
    };

    try{
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
      );

      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Register Success'))
        );
        context.go('/login');

      }else{
        print('Status: ${response.statusCode}');
        print('Body: ${response.body}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to register. Try again.'))
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occured: $e'))
      );
    }
  }
}