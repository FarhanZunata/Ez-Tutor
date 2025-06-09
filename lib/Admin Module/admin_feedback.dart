import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<dynamic> feedbacks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFeedbacks();
  }

  Future<void> fetchFeedbacks() async {
    const String url = 'http://10.0.2.2:3000/feedbackList'; // Your backend endpoint

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          feedbacks = data;
          isLoading = false;
        });
      } else {
        debugPrint('Failed to load feedbacks: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint('Error fetching feedbacks: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin_home'),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : feedbacks.isEmpty
          ? const Center(child: Text("No feedback available."))
          : ListView.builder(
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                feedback['feedback_text'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}
