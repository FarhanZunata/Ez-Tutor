import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminBookingListPage extends StatefulWidget {
  const AdminBookingListPage({super.key});

  @override
  State<AdminBookingListPage> createState() => _AdminBookingListPageState();
}

class _AdminBookingListPageState extends State<AdminBookingListPage> {
  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    const String url = 'http://10.0.2.2:3000/bookingList';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          bookings = data;
          isLoading = false;
        });
      } else {
        debugPrint('Failed to load bookings: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('All Bookings'),
          leading: IconButton(
              onPressed: (){
                context.go('/admin_home');  
              },
              icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(child: Text("No bookings available."))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(
                "Student: ${booking['student_name']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Teacher: ${booking['teacher_name']}"),
                  Text("Date: ${booking['booking_date']}"),
                  Text("Time: ${booking['booking_time']}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
