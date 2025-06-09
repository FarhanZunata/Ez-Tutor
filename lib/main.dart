import 'package:ez_tutor_system/Admin%20Module/admin_feedback.dart';
import 'package:ez_tutor_system/Admin%20Module/admin_home.dart';
import 'package:ez_tutor_system/Admin%20Module/booking_list.dart';
import 'package:ez_tutor_system/Admin%20Module/summary_report.dart';
import 'package:ez_tutor_system/Student%20Module/Feedback%20Module/feedback.dart';
import 'package:ez_tutor_system/Student%20Module/Payment%20Module/payment.dart';
import 'package:ez_tutor_system/Teacher%20Module/Teacher%20Feedback%20Module/teacher_feedback.dart';
import 'package:ez_tutor_system/Teacher%20Module/Teacher%20Home/teacher_home.dart';
import 'package:ez_tutor_system/Teacher%20Module/Update%20Availability%20Module/update_availability.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import your module pages
import 'package:ez_tutor_system/Welcome.dart';
import 'package:ez_tutor_system/Login%20Module/Login.dart';
import 'package:ez_tutor_system/Register%20Module/Register.dart';
import 'package:ez_tutor_system/Student%20Module/Home%20Module/Student_Home.dart';
import 'package:ez_tutor_system/Student%20Module/Booking%20Module/Book_Class.dart';
import 'package:ez_tutor_system/Student Module/Book Summary Module/summary.dart';

void main() {
  runApp(EzTutorApp());
}

class EzTutorApp extends StatelessWidget {
  EzTutorApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const Welcome(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const Register(),
      ),
      GoRoute(
        path: '/student_home',
        builder: (context, state) => const StudentHome(),
      ),
      GoRoute(
          path: '/teacher_home',
          builder: (context, state) => const TeacherHome(),
      ),
      GoRoute(
        path: '/admin_home',
        builder: (context, state) => const AdminHome(),
      ),
      GoRoute(
        path: '/book_class/:userID',
        builder: (context, state) {
          final studentIdStr = state.pathParameters['userID'];
          final studentId = int.tryParse(studentIdStr ?? '');

          if (studentId == null) {
            return const Scaffold(
              body: Center(child: Text("Invalid student ID")),
            );
          }

          return BookClassPage(studentId: studentId);
        },
      ),
      GoRoute(
          path: '/student_feedback',
          builder: (context, state) => FeedbackPage(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          return PaymentPage(
            userID: int.parse(state.uri.queryParameters['userID']!),
            teacherId: int.parse(state.uri.queryParameters['teacher_id']!),
            bookingDate: state.uri.queryParameters['booking_date']!,
            bookingTime: state.uri.queryParameters['booking_time']!,
            totalPayment: double.parse(state.uri.queryParameters['total_payment']!),
          );
        },
      ),
      GoRoute(
        path: '/summary/:payment_id',
        builder: (context, state) {
          final paymentIdStr = state.pathParameters['payment_id'];
          final paymentID = int.tryParse(paymentIdStr ?? '');

          if (paymentID == null) {
            return const Scaffold(
              body: Center(child: Text("Invalid payment ID")),
            );
          }

          return SummaryPage(paymentId: paymentID);
        },
      ),
      GoRoute(
        path: '/update/:userID',
        builder: (context, state) {
          final teacherIdStr = state.pathParameters['userID'];
          final teacherId = int.tryParse(teacherIdStr ?? '');

          if(teacherId == null){
            return Scaffold(
              body: Center(child: Text('Invalid teacher ID')),
            );
          }
          return UpdateAvailabilityPage(teacherId: teacherId);
        },
      ),
      GoRoute(
        path: '/teacher_feedback',
        builder: (context, state) => TeacherFeedbackPage(),
      ),
      GoRoute(
        path: '/admin_booking',
        builder: (context, state) => AdminBookingListPage(),
      ),
      GoRoute(
          path: '/reportSummary',
          builder: (context, state) => ReportPage(),
      ),
      GoRoute(
          path: '/feedback_list',
          builder: (context, state) => FeedbackListPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'EZ Tutor System',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
