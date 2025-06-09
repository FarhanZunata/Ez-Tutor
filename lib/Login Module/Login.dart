import 'package:ez_tutor_system/Login%20Module/LoginService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          letterSpacing: 1
                        ),
                      ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 90, 50, 10),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                          )
                        ),
                      ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),
                    ),
                  ),
                ),
                
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                            onPressed: (){
                              final loginService = LoginService(context);
                              loginService.loginUser(
                                  _emailController.text,
                                  _passwordController.text
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                letterSpacing: 1
                              ),
                            )
                        ),
                      ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: TextButton(
                          onPressed: (){
                              context.go('/welcome');
                          },
                          child: Text(
                            'Previous Page',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          )),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}

