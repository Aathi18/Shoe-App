import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageShoesPage extends StatelessWidget {
  const ManageShoesPage({super.key});

  void _deleteShoe(String id, BuildContext context) async {
    await FirebaseFirestore.instance.collection("shoes").doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑 Shoe deleted")),
    );
  }

  void _editShoe(BuildContext context, String id, Map<String, dynamic> data) {
    final nameController = TextEditingController(text: data['name']);
    final priceController = TextEditingController(text: data['price'].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Shoe"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection("shoes").doc(id).update({
                "name": nameController.text.trim(),
                "price": double.parse(priceController.text.trim()),
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("✅ Shoe updated")),
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Shoes"), backgroundColor: Colors.blueAccent),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("shoes").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final shoes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: shoes.length,
            itemBuilder: (context, index) {
              final shoe = shoes[index];
              final data = shoe.data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(data['image'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(data['name']),
                subtitle: Text("₹${data['price']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () => _editShoe(context, shoe.id, data)),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteShoe(shoe.id, context)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
