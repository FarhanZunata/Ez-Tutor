import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateAvailabilityPage extends StatefulWidget {
  final int teacherId;

  const UpdateAvailabilityPage({Key? key, required this.teacherId}) : super(key: key);

  @override
  _UpdateAvailabilityPageState createState() => _UpdateAvailabilityPageState();
}

class _UpdateAvailabilityPageState extends State<UpdateAvailabilityPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _updateAvailability() async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both date and time.')),
      );
      return;
    }

    final bookingDate = "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
    final bookingTime = "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/availability'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'teacher_id': widget.teacherId,
        'available_date': bookingDate,
        'available_time': bookingTime,
      }),
    );

    final result = json.decode(response.body);

    if (response.statusCode == 200 && result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Availability updated successfully!')),
      );
      context.go('/teacher_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Update failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Availability')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text(selectedDate == null
                  ? 'Choose Date'
                  : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            ListTile(
              title: Text(selectedTime == null
                  ? 'Choose Time'
                  : 'Time: ${selectedTime!.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: _pickTime,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.cancel, color: Colors.black,),
                  label: Text('Cancel', style: TextStyle(color: Colors.black),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () => context.go('/teacher_home'),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.update, color: Colors.black,),
                  label: Text('Update', style: TextStyle(color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: _updateAvailability,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
