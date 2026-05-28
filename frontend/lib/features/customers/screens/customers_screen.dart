import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customers', style: AppTextStyles.heading2)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (_, i) => Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: 0.15), child: const Icon(Icons.business, color: AppColors.primary, size: 18)),
            title: Text('Client ${i + 1}', style: AppTextStyles.body),
            subtitle: Text('Surat, Gujarat', style: AppTextStyles.caption),
            trailing: Icon(Icons.chevron_right, color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}
