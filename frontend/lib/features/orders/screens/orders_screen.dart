import 'package:flutter/material.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/order_card.dart';
import 'create_order_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': 'ORD-001', 'customer': 'JSW Steel Ltd', 'product': 'Indonesian Coal · GCV 5500', 'qty': '200 MT', 'status': 'synced'},
      {'id': 'ORD-002', 'customer': 'Ultratech Cement', 'product': 'Steam Coal · GCV 4200', 'qty': '150 MT', 'status': 'pending'},
    ];
    return Scaffold(
      appBar: AppBar(title: Text('Orders', style: AppTextStyles.heading2)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOrderScreen())),
        icon: const Icon(Icons.add),
        label: const Text('New Order'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: orders.map((o) => OrderCard(order: o)).toList(),
      ),
    );
  }
}