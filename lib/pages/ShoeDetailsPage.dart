import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';

class ShoeDetailsPage extends StatefulWidget {
  final String shoeId;
  final Map<String, dynamic> shoeData;

  const ShoeDetailsPage({super.key, required this.shoeId, required this.shoeData});

  @override
  State<ShoeDetailsPage> createState() => _ShoeDetailsPageState();
}

class _ShoeDetailsPageState extends State<ShoeDetailsPage> {
  double averageRating = 0.0;
  List<Map<String, dynamic>> reviews = [];

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final snap = await FirebaseFirestore.instance
        .collection('shoes')
        .doc(widget.shoeId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .get();

    final all = snap.docs.map((doc) => doc.data()).toList();
    double total = 0;
    for (var r in all) {
      total += (r['rating'] ?? 0).toDouble();
    }

    setState(() {
      reviews = all;
      averageRating = all.isEmpty ? 0 : total / all.length;
    });
  }

  Future<void> addReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    double rating = 0;
    String comment = '';

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Review"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              allowHalfRating: true,
              itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (val) => rating = val,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: "Comment"),
              onChanged: (val) => comment = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (rating == 0) return;

              final reviewRef = FirebaseFirestore.instance
                  .collection('shoes')
                  .doc(widget.shoeId)
                  .collection('reviews')
                  .doc();

              await reviewRef.set({
                'userId': user.uid,
                'userName': user.displayName ?? user.email ?? "Anonymous",
                'rating': rating,
                'comment': comment,
                'timestamp': FieldValue.serverTimestamp(),
              });

              Navigator.pop(context);
              fetchReviews();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoe = widget.shoeData;
    final price = shoe['price'];
    final priceText = (price is int || price is double) ? "\$${price.toStringAsFixed(2)}" : "\$0.00";

    return Scaffold(
      appBar: AppBar(title: const Text("Shoe Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.network(shoe['image'] ?? '', height: 200, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Text(shoe['name'] ?? 'No Name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(shoe['description'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            Text(priceText, style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // ⭐ Average rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(averageRating.toStringAsFixed(1)),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: addReview,
                  icon: const Icon(Icons.rate_review),
                  label: const Text("Add Review"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            const Divider(),
            const Text("Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            if (reviews.isEmpty)
              const Text("No reviews yet.")
            else
              ...reviews.map((review) => ListTile(
                title: Text(review['userName']),
                subtitle: Text(review['comment']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    final rating = review['rating'] ?? 0.0;
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              )),
          ],
        ),
      ),
    );
  }
}
