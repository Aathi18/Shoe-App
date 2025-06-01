import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ShoeDetailsPage extends StatefulWidget {
  final String shoeId;
  final Map<String, dynamic> shoeData;

  const ShoeDetailsPage({super.key, required this.shoeId, required this.shoeData});

  @override
  State<ShoeDetailsPage> createState() => _ShoeDetailsPageState();
}

class _ShoeDetailsPageState extends State<ShoeDetailsPage> {
  final _commentController = TextEditingController();
  double _rating = 3.0;

  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final review = {
      "userId": user.uid,
      "userName": user.displayName ?? "Anonymous",
      "rating": _rating,
      "comment": _commentController.text.trim(),
      "timestamp": Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('shoes')
        .doc(widget.shoeId)
        .collection('reviews')
        .add(review);

    _commentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Review submitted")),
    );
  }

  Stream<QuerySnapshot> _reviewsStream() {
    return FirebaseFirestore.instance
        .collection('shoes')
        .doc(widget.shoeId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  double _calculateAverageRating(List<QueryDocumentSnapshot> reviews) {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold(0.0, (sum, doc) => sum + (doc['rating'] as num).toDouble());
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.shoeData;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? "Shoe Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(data['image'], height: 140, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(data['description'] ?? '', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("Price: \$${data['price'].toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const Divider(),

            // 🔁 Reviews Section
            const Text("⭐ Ratings & Reviews", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _reviewsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final reviews = snapshot.data!.docs;
                  final avgRating = _calculateAverageRating(reviews);

                  return Column(
                    children: [
                      Text("Average Rating: ${avgRating.toStringAsFixed(1)}",
                          style: const TextStyle(fontSize: 16, color: Colors.deepOrange)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: reviews.length,
                          itemBuilder: (_, index) {
                            final review = reviews[index];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(review['userName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RatingBarIndicator(
                                    rating: (review['rating'] as num).toDouble(),
                                    itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
                                    itemSize: 20,
                                  ),
                                  Text(review['comment']),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const Divider(),
            const Text("📝 Add Your Review"),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              itemSize: 28,
              allowHalfRating: true,
              itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) => setState(() => _rating = rating),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: "Comment",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text("Submit Review"),
            ),
          ],
        ),
      ),
    );
  }
}
