import 'package:flutter/material.dart';
import '../../orders/widgets/order_card.dart';

class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data — replace with SQLite/API call
    final orders = [
      {'id': 'ORD-001', 'customer': 'JSW Steel Ltd', 'product': 'Indonesian Coal · GCV 5500', 'qty': '200 MT', 'status': 'synced'},
      {'id': 'ORD-002', 'customer': 'Ultratech Cement', 'product': 'Steam Coal · GCV 4200', 'qty': '150 MT', 'status': 'pending'},
      {'id': 'ORD-003', 'customer': 'Tata Steel', 'product': 'Screen Coal · GCV 6000', 'qty': '500 MT', 'status': 'failed'},
    ];

    return Column(
      children: orders.map((o) => OrderCard(order: o)).toList(),
    );
  }
}
