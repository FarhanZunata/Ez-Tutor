import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                  'images/logo.png', width: 250
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                        onPressed: (){
                          context.go('/login');
                        },
                        child: Text(
                            'Login',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        ),
                    ),
                  ),

                  Container(
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                        onPressed: (){
                          context.go('/register');
                        },
                        child: Text(
                            'Register',
                          style: TextStyle(
                            color: Colors.black
                          ),
                        )
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
