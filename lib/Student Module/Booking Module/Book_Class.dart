import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookClassPage extends StatefulWidget {
  final int studentId;

  const BookClassPage({super.key, required this.studentId});

  @override
  State<BookClassPage> createState() => _BookClassPageState();
}

class _BookClassPageState extends State<BookClassPage> {
  List<Map<String, dynamic>> teachers = [];
  List<Map<String, dynamic>> availableDates = [];
  List<Map<String, dynamic>> availableTimes = [];

  int? selectedTeacherId;
  String? selectedDate;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    fetchTeachers();
  }

  Future<void> fetchTeachers() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/teachers'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() => teachers = List<Map<String, dynamic>>.from(data));
      } else {
        debugPrint('Failed to fetch teachers: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching teachers: $e');
    }
  }

  Future<void> fetchAvailableDates(int teacherId) async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/availability/$teacherId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          availableDates = List<Map<String, dynamic>>.from(data);
          selectedDate = null;
          selectedTime = null;
          availableTimes.clear();
        });
      } else {
        debugPrint('Failed to fetch dates: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching dates: $e');
    }
  }

  Future<void> fetchAvailableTimes(int teacherId, String date) async {
    try {
      final url = 'http://10.0.2.2:3000/availability/$teacherId/$date';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          availableTimes = List<Map<String, dynamic>>.from(data);
          selectedTime = null;
        });
      } else {
        debugPrint('Failed to fetch times: ${response.statusCode}');
        setState(() {
          availableTimes.clear();
          selectedTime = null;
        });
      }
    } catch (e) {
      debugPrint('Error fetching times: $e');
      setState(() {
        availableTimes.clear();
        selectedTime = null;
      });
    }
  }

  Future<void> bookClass(BuildContext context) async {
    if (selectedTeacherId == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all selections.")),
      );
      return;
    }

    // Instead of posting to server, just navigate to payment page
    // You can generate dummy bookingId and totalPayment here or pass real values if you have them
    final int bookingId = 0; // dummy booking id
    final double totalPayment = 100.0; // dummy total payment

    if (context.mounted) {
      context.go('/payment?userID=${widget.studentId}&teacher_id=$selectedTeacherId&booking_date=$selectedDate&booking_time=$selectedTime&total_payment=$totalPayment');

    }
  }


  String _extractDateString(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '';
    return dateTimeStr.split('T').first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Class")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: 'Select Teacher',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              value: selectedTeacherId,
              items: teachers
                  .where((t) => t['userID'] != null && t['full_name'] != null)
                  .map((t) {
                return DropdownMenuItem<int>(
                  value: t['userID'] as int,
                  child: Text(t['full_name']),
                );
              }).toList(),

                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedTeacherId = value;
                      selectedDate = null;
                      selectedTime = null;
                      availableDates.clear();
                      availableTimes.clear();
                    });
                    fetchAvailableDates(value);
                  }
                }
            ),
            const SizedBox(height: 16),
            if (availableDates.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedDate,
                items: availableDates.map((d) {
                  final dateStr = _extractDateString(d['available_date']?.toString());
                  return DropdownMenuItem<String>(
                    value: dateStr,
                    child: Text(dateStr),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null && selectedTeacherId != null) {
                    setState(() {
                      selectedDate = value;
                      selectedTime = null;
                      availableTimes.clear();
                    });
                    final teacherId = selectedTeacherId;
                    if (teacherId != null && value != null) {
                      fetchAvailableTimes(teacherId, value);
                    }

                  }
                },
              ),
            const SizedBox(height: 16),
            if (availableTimes.isNotEmpty)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Time',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedTime,
                items: availableTimes.map((t) {
                  final timeStr = t['available_time']?.toString() ?? '';
                  return DropdownMenuItem<String>(
                    value: timeStr,
                    child: Text(timeStr),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selectedTime = value);
                },
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: (selectedTeacherId != null && selectedDate != null && selectedTime != null)
                  ? () => bookClass(context)
                  : null,
              child: const Text("Book Now"),
            ),
            
            const SizedBox(height: 16,),
            ElevatedButton(
                onPressed: (){
                  context.go('/student_home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
                ),
                child: Text('Cancel', style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}
