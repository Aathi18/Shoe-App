import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateInvoicePdf(Map<String, dynamic> orderData) async {
  final pdf = pw.Document();

  // Load font
  final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  // Load logo image
  final imageLogo = pw.MemoryImage(
    (await rootBundle.load('images/4.png')).buffer.asUint8List(),
  );

  final date = orderData["timestamp"]?.toDate();
  final items = List<Map<String, dynamic>>.from(orderData["items"]);
  final total = orderData["total"];

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) {
        return pw.DefaultTextStyle(
          style: pw.TextStyle(font: ttf),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with logo
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(imageLogo, height: 60),
                  pw.Text(
                    "INVOICE",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueAccent,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // Order Info
              pw.Text(
                "Order Date: ${date != null ? DateFormat.yMMMMEEEEd().add_jm().format(date) : "N/A"}",
                style: pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),

              // Table Headers
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 8),
                color: PdfColors.grey300,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Text("Item",
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                    pw.Text("Qty", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 40),
                    pw.Text("Price", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
              ),
              pw.SizedBox(height: 8),

              // Items
              ...items.map((item) => pw.Container(
                padding: const pw.EdgeInsets.symmetric(vertical: 6),
                child: pw.Row(
                  children: [
                    pw.Expanded(child: pw.Text(item['name'])),
                    pw.Text("x${item['quantity']}"),
                    pw.SizedBox(width: 40),
                    pw.Text("₹${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
                  ],
                ),
              )),

              pw.Divider(),

              // Total
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  "Total: ₹${total.toStringAsFixed(2)}",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green800,
                  ),
                ),
              ),

              pw.Spacer(),
              pw.Divider(),

              // Footer Note
              pw.Text("Thank you for your purchase!", style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 12),

              // QR and Signature
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.BarcodeWidget(
                    data: "Order ID: 123456", // You can use dynamic ID here
                    barcode: pw.Barcode.qrCode(),
                    width: 60,
                    height: 60,
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("Authorized Signature"),
                      pw.SizedBox(height: 20),
                      pw.Container(width: 120, height: 1, color: PdfColors.black),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}
