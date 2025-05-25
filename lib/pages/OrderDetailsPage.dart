import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'CartPage.dart';
import 'package:printing/printing.dart';
import '../utils/pdf_invoice.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsPage({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final date = orderData["timestamp"]?.toDate();
    final items = List<Map<String, dynamic>>.from(orderData["items"]);
    final total = orderData["total"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order Date: ${date != null ? DateFormat.yMMMMEEEEd().add_jm().format(date) : "N/A"}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Items:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  final totalPrice = (item['price'] * item['quantity']).toStringAsFixed(2);

                  return ListTile(
                    leading: item['image'] != null
                        ? Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                    )
                        : const Icon(Icons.image),
                    title: Text(item['name']),
                    subtitle: Text("₹${item['price']} x ${item['quantity']}"),
                    trailing: Text("₹$totalPrice"),
                  );
                },
              ),
            ),
            const Divider(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ₹${total.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
            const SizedBox(height: 24),

            // 🔘 ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final cart = Provider.of<CartProvider>(context, listen: false);
                    for (var item in items) {
                      cart.addItem(
                        id: item['name'], // or use item['id']
                        name: item['name'],
                        image: item['image'],
                        price: (item['price'] as num).toDouble(),
                        quantity: item['quantity'],
                      );
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Items added to cart.")),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text("Reorder"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final pdfData = await generateInvoicePdf(orderData);
                      await Printing.layoutPdf(onLayout: (format) => pdfData);
                    }catch(e){
                      print("❌ PDF Error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to generate invoice: $e")),
                      );


                    }
                    },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text("Invoice"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
