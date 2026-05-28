import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/shcc_app_bar.dart';

class CatalogueScreen extends StatefulWidget {
  final bool isAdmin;
  const CatalogueScreen({super.key, required this.isAdmin});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  final List<Map<String, dynamic>> _products = [
    {'name': 'Indonesian Coal',   'grade': 'Standard', 'gcv': '5500', 'price': 6200.0,  'available': true},
    {'name': 'South African Coal','grade': 'Premium',  'gcv': '6000', 'price': 7100.0,  'available': true},
    {'name': 'US Coal',           'grade': 'A-Grade',  'gcv': '4200', 'price': 4800.0,  'available': true},
    {'name': 'Russian Coal',      'grade': 'Standard', 'gcv': '3800', 'price': 3500.0,  'available': false},
    {'name': 'Bio Coal',          'grade': 'Premium',  'gcv': '6500', 'price': 8200.0,  'available': true},
    {'name': 'Metallurgical Coke','grade': 'Export',   'gcv': '7200', 'price': 11500.0, 'available': false},
  ];

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final available = _products.where((p) => p['available'] == true).length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        onProfileTap: () {},
        userInitials: widget.isAdmin ? 'AD' : 'RS',
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Text('Product Catalogue',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text('${_products.length} products  ·  $available available',
            style: theme.textTheme.bodySmall),
          const SizedBox(height: 20),
          ..._products.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ProductCard(
              product: e.value,
              isAdmin: widget.isAdmin,
              isDark: isDark,
              onEdit: () => _editProduct(context, e.key),
            ),
          )),
        ],
      ),
    );
  }

  void _editProduct(BuildContext context, int index) {
    final p = _products[index];
    final priceCtrl = TextEditingController(text: p['price'].toString());
    bool available = p['available'] as bool;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2)))),
            Text('Edit Product', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(p['name'] as String, style: theme.textTheme.bodySmall),
            const SizedBox(height: 24),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: 'Price per MT (₹)',
                prefixIcon: Icon(Icons.currency_rupee_rounded,
                  size: 18, color: AppColors.textMuted))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Available', style: theme.textTheme.bodyMedium),
              Switch(
                value: available,
                activeColor: AppColors.primary,
                onChanged: (v) => setModal(() => available = v)),
            ]),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _products[index]['price'] =
                      double.tryParse(priceCtrl.text) ?? p['price'];
                    _products[index]['available'] = available;
                  });
                  Navigator.pop(ctx);
                },
                child: const Text('Save Changes'))),
          ]),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isAdmin, isDark;
  final VoidCallback onEdit;

  const _ProductCard({
    required this.product, required this.isAdmin,
    required this.isDark,  required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avail = product['available'] as bool;
    final cardBg = isDark ? AppColors.bgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.border : AppColors.lightBorder;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: isDark
          ? null
          : [BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: avail
              ? AppColors.primary.withValues(alpha: isDark ? 0.15 : 0.1)
              : (isDark ? AppColors.bgBase : AppColors.lightBgBase),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.local_fire_department_rounded,
            color: avail ? AppColors.primary
              : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
            size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(product['name'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Row(children: [
            Text('₹${(product['price'] as double).toStringAsFixed(0)}/MT',
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: AppColors.primary)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: avail
                  ? AppColors.success.withValues(alpha: 0.12)
                  : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20)),
              child: Text(avail ? 'Available' : 'Unavailable',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: avail ? AppColors.success : AppColors.error))),
          ]),
        ])),
        if (isAdmin)
          GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgBase : AppColors.lightBgBase,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: border)),
              child: Icon(Icons.edit_outlined, size: 16,
                color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary))),
      ]),
    );
  }
}
