import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

Future<Uint8List> generateInvoicePdf(Map<String, dynamic> orderData) async {
  final pdf = pw.Document();
  final date = orderData["timestamp"]?.toDate();
  final items = List<Map<String, dynamic>>.from(orderData["items"]);
  final total = orderData["total"];

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text("Shoe Store - Invoice", style: pw.TextStyle(fontSize: 24)),
          pw.SizedBox(height: 12),
          pw.Text("Date: ${DateFormat.yMMMMd().add_jm().format(date)}"),
          pw.SizedBox(height: 12),
          pw.Text("Items:", style: pw.TextStyle(fontSize: 18)),
          pw.ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index];
              return pw.Text(
                "• ${item['name']} x${item['quantity']} - ₹${item['price']}",
              );
            },
          ),
          pw.Divider(),
          pw.Text("Total: ₹${total.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 18)),
        ],
      ),
    ),
  );

  return pdf.save();
}
