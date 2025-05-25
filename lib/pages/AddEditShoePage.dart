import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditShoePage extends StatefulWidget {
  final String? shoeId; // 🆔 Firestore ID for editing
  final Map<String, dynamic>? existingData;

  const AddEditShoePage({super.key, this.shoeId, this.existingData});

  @override
  State<AddEditShoePage> createState() => _AddEditShoePageState();
}

class _AddEditShoePageState extends State<AddEditShoePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _nameController.text = widget.existingData!['name'] ?? '';
      _descController.text = widget.existingData!['description'] ?? '';
      _imageUrlController.text = widget.existingData!['image'] ?? '';
      _priceController.text = widget.existingData!['price'].toString();
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final data = {
      "name": _nameController.text.trim(),
      "description": _descController.text.trim(),
      "image": _imageUrlController.text.trim(),
      "price": double.parse(_priceController.text.trim()),
      "timestamp": FieldValue.serverTimestamp(),
    };

    try {
      if (widget.shoeId == null) {
        // Create new
        await FirebaseFirestore.instance.collection("shoes").add(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Shoe uploaded")));
      } else {
        // Update
        await FirebaseFirestore.instance.collection("shoes").doc(widget.shoeId).update(data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✏️ Shoe updated")));
      }

      Navigator.pop(context); // Go back
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _deleteShoe() async {
    if (widget.shoeId == null) return;

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Shoe?"),
        content: const Text("Are you sure you want to delete this shoe?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance.collection("shoes").doc(widget.shoeId).delete();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("🗑 Shoe deleted")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.shoeId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Shoe" : "Add New Shoe"),
        backgroundColor: isEditing ? Colors.orange : Colors.blueAccent,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteShoe,
              tooltip: "Delete Shoe",
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
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
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(isEditing ? Icons.save : Icons.upload),
                label: Text(isEditing ? "Update Shoe" : "Upload Shoe"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEditing ? Colors.orange : Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
