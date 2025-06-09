import 'package:ez_tutor_system/Register%20Module/RegisterService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _hpNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;

  final List<Map<String, String>> _roles = [
    {'value': 'S', 'label': 'Student'},
    {'value': 'T', 'label': 'Teacher'},
    {'value': 'A', 'label': 'Admin'},
  ];

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
                      padding: EdgeInsets.only(top: 100),
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1
                        ),
                      ),
                  ),
                ),
                
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
                      child: TextFormField(
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
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
                      controller: _hpNumberController,
                      decoration: InputDecoration(
                          labelText: 'Phone No.',
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
                      padding: EdgeInsets.fromLTRB(50, 20, 50, 10),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Select Role',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                          value: _selectedRole,
                          items: _roles.map((role){
                            return DropdownMenuItem(
                                value: role['value'],
                                child: Text(role['label']!),
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              _selectedRole = value;
                            });
                          }),
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
                            if(_selectedRole == null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a role')),
                              );
                              return;
                            }

                            final registerService = RegisterService(context);
                            registerService.registerUser(
                                _fullNameController.text,
                                _emailController.text,
                                _hpNumberController.text,
                                _passwordController.text,
                                _passwordController.text,
                                _selectedRole!,
                            );
                          },
                          child: Text(
                            'Register',
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
