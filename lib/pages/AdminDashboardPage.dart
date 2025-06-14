import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int orders = 0;
  int users = 0;
  double sales = 0;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  /// 🔑 Fetch orders & users collection counts and total sales
  Future<void> fetchDashboardData() async {
    try {
      final orderSnap =
      await FirebaseFirestore.instance.collection("orders").get();
      final userSnap =
      await FirebaseFirestore.instance.collection("users").get();

      double totalSales = 0;
      for (var doc in orderSnap.docs) {
        totalSales += (doc.data()["total"] ?? 0).toDouble();
      }

      setState(() {
        orders = orderSnap.size;
        users = userSnap.size;
        sales = totalSales;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Dashboard load failed: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Admin Dashboard"),
        backgroundColor: Colors.indigo,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _infoCard(
                    "Orders", orders.toString(), Icons.shopping_cart, Colors.blue),
                _infoCard(
                    "Users", users.toString(), Icons.people, Colors.orange),
                _infoCard("Sales", "₹${sales.toStringAsFixed(2)}",
                    Icons.attach_money, Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "📉 Sales Overview",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildBarChart()),
          ],
        ),
      ),
    );
  }

  /// 📊 Single info card widget
  Widget _infoCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(title),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  /// 📊 Sales & orders bar chart
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        maxY: [orders.toDouble(), users.toDouble(), sales].reduce((a, b) => a > b ? a : b) + 5,
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: orders.toDouble(), color: Colors.blue)
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: users.toDouble(), color: Colors.orange)
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: sales, color: Colors.green)
          ]),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                switch (value.toInt()) {
                  case 0:
                    return const Text("Orders");
                  case 1:
                    return const Text("Users");
                  case 2:
                    return const Text("Sales");
                  default:
                    return const Text("");
                }
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
      ),
    );
  }
}
