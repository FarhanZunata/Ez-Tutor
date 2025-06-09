import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SummaryPage extends StatefulWidget {
  final int paymentId;

  const SummaryPage({required this.paymentId, Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  Map<String, dynamic>? summaryData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  Future<void> fetchSummary() async {
    final url = Uri.parse('http://10.0.2.2:3000/payment/summary/${widget.paymentId}');
    print("Fetching summary from: $url"); // Add this
    final response = await http.get(url);

    print("Response status: ${response.statusCode}"); // Add this
    print("Response body: ${response.body}"); // Add this

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['success']) {
        setState(() {
          summaryData = result['data'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Summary not found.')),
        );
      }
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load summary.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : summaryData == null
          ? const Center(child: Text('No summary data available.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '✅ Your class has been booked!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Teacher: ${summaryData!['teacher_name']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Date: ${summaryData!['booking_date']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Time: ${summaryData!['booking_time']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.payment, color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          'Total: RM${summaryData!['total_payment']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/student_home');
                },
                icon: const Icon(Icons.home, color: Colors.white,),
                label: const Text('Go to Home', style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
