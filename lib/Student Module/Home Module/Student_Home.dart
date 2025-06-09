import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    "EZ Tuisyen Booking",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      letterSpacing: 1
                    ),
                  ),
                )
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Image.asset(
                      'images/ez_tutor.png',
                      width: 350,
                    ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 10),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            final userID = prefs.getInt('userID');
                            if (userID != null){
                              context.go('/book_class/$userID');
                            }
                          },
                          child: Text(
                              'Book Class',
                              style: TextStyle(color: Colors.white),
                          ),
                      ),
                    ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
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
                        context.go('/student_feedback');
                      },
                      child: Text(
                        'Feedback',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
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
                        _logout();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

  Future<void> _logout() async{

    // Clear SharedPreferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout Success'),
          backgroundColor: Colors.green,
        )
      );

      // Navigate to login page after a short delay
      Future.delayed(Duration(milliseconds: 5), (){
        if(mounted){
          context.go('/login');
        }
      });
    }
  }
}
