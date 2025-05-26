import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddShoePage extends StatefulWidget {
  const AddShoePage({super.key});

  @override
  State<AddShoePage> createState() => _AddShoePageState();
}

class _AddShoePageState extends State<AddShoePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;
  String? editingId;

  Future<void> _uploadOrUpdateShoe() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final shoeData = {
        "name": _nameController.text.trim(),
        "description": _descController.text.trim(),
        "image": _imageUrlController.text.trim(),
        "price": double.parse(_priceController.text.trim()),
        "timestamp": FieldValue.serverTimestamp(),
      };

      if (editingId != null) {
        // Update
        await FirebaseFirestore.instance.collection("shoes").doc(editingId).update(shoeData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Shoe updated successfully")),
        );
      } else {
        // Create
        await FirebaseFirestore.instance.collection("shoes").add(shoeData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Shoe uploaded successfully")),
        );
      }

      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    }

    setState(() => _isLoading = false);
  }

  void _clearForm() {
    _nameController.clear();
    _descController.clear();
    _imageUrlController.clear();
    _priceController.clear();
    editingId = null;
  }

  void _fillForm(Map<String, dynamic> data, String id) {
    setState(() {
      _nameController.text = data['name'];
      _descController.text = data['description'];
      _imageUrlController.text = data['image'];
      _priceController.text = data['price'].toString();
      editingId = id;
    });
  }

  Future<void> _deleteShoe(String id) async {
    await FirebaseFirestore.instance.collection("shoes").doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("🗑 Shoe deleted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add / Manage Shoes"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Shoe Name"),
                    validator: (val) => val!.isEmpty ? "Enter shoe name" : null,
                  ),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (val) => val!.isEmpty ? "Enter description" : null,
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                    validator: (val) => val!.isEmpty ? "Enter image URL" : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: "Price"),
                    keyboardType: TextInputType.number,
                    validator: (val) => val!.isEmpty ? "Enter price" : null,
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                    onPressed: _uploadOrUpdateShoe,
                    icon: Icon(editingId != null ? Icons.update : Icons.upload),
                    label: Text(editingId != null ? "Update Shoe" : "Upload Shoe"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: editingId != null ? Colors.orange : Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                  ),
                  if (editingId != null)
                    TextButton(
                      onPressed: _clearForm,
                      child: const Text("Cancel Edit"),
                    )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 10),
            const Text("📦 Existing Shoes", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("shoes").orderBy("timestamp", descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final shoes = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shoes.length,
                  itemBuilder: (context, index) {
                    final shoe = shoes[index];
                    final data = shoe.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Image.network(data['image'], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(data['name']),
                        subtitle: Text("₹${data['price']}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _fillForm(data, shoe.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteShoe(shoe.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
