import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final int userID;
  final int teacherId;
  final String bookingDate;
  final String bookingTime;
  final double totalPayment;

  const PaymentPage({
    Key? key,
    required this.userID,
    required this.teacherId,
    required this.bookingDate,
    required this.bookingTime,
    required this.totalPayment,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  File? _receipt;
  final picker = ImagePicker();
  bool isLoading = false;

  Future<void> _pickReceipt() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _receipt = File(pickedFile.path));
    }
  }

  Future<void> _submitPayment() async {
    setState(() => isLoading = true);

    try {
      // Step 1: Book class
      final bookingResponse = await http.post(
        Uri.parse('http://10.0.2.2:3000/book'), // <-- replace with your API
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'student_id': widget.userID,
          'teacher_id': widget.teacherId,
          'booking_date': widget.bookingDate,
          'booking_time': widget.bookingTime,
        }),
      );

      final bookingResult = jsonDecode(bookingResponse.body);

      if (bookingResponse.statusCode == 200 && bookingResult['success']) {
        final bookingId = bookingResult['booking_id'];

        // Step 2: Submit payment with bookingId
        final uri = Uri.parse('http://10.0.2.2:3000/payment');
        final request = http.MultipartRequest('POST', uri)
          ..fields['booking_id'] = bookingId.toString()
          ..fields['total_payment'] = widget.totalPayment.toString();

        if (_receipt != null) {
          request.files.add(await http.MultipartFile.fromPath('receipt', _receipt!.path));
        }

        final response = await request.send();
        final respStr = await response.stream.bytesToString();
        final paymentResult = jsonDecode(respStr);

        if (response.statusCode == 200 && paymentResult['success']) {
          final paymentId = paymentResult['payment_id'];
          context.go('/summary/$paymentId');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Booking failed.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Total Payment: RM${widget.totalPayment.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Image.asset('assets/qr.png', width: 200),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickReceipt,
              icon: Icon(Icons.upload_file),
              label: Text(_receipt == null ? 'Upload Receipt (Optional)' : 'Receipt Selected'),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/book_class/${widget.userID}'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _submitPayment,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
