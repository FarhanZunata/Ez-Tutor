import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int totalBookings = 0;
  double totalPayment = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReportSummary();
  }

  Future<void> fetchReportSummary() async {
    const String url = 'http://10.0.2.2:3000/reportSummary';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalBookings = data['total_bookings'];
          totalPayment = double.parse(data['total_payment'].toString());
          isLoading = false;
        });
      } else {
        debugPrint('Failed to load summary: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching summary: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin_home'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary Statistics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Total Bookings: $totalBookings',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Total Payments: RM ${totalPayment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
