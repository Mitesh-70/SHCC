import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../orders/screens/create_order_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      {'label': 'New Order', 'icon': Icons.add_shopping_cart, 'color': AppColors.primary, 'route': 'new_order'},
      {'label': 'Sync Now', 'icon': Icons.sync, 'color': AppColors.info, 'route': 'sync'},
      {'label': 'Export', 'icon': Icons.download_outlined, 'color': AppColors.success, 'route': 'export'},
    ];

    return Row(
      children: actions.map((a) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                if (a['route'] == 'new_order') {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateOrderScreen()));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: (a['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: (a['color'] as Color).withValues(alpha: 0.3)),
                ),
                child: Column(children: [
                  Icon(a['icon'] as IconData, color: a['color'] as Color, size: 22),
                  const SizedBox(height: 6),
                  Text(a['label'] as String, style: AppTextStyles.caption.copyWith(color: a['color'] as Color)),
                ]),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
