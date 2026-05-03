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
    {'name': 'Indonesian Coal',  'price': 6200.0,  'available': true},
    {'name': 'Russian',       'price': 7100.0,  'available': true},
    {'name': 'US coal',      'price': 4800.0,  'available': true},
    {'name': 'South African coal',     'price': 8200.0,  'available': true},
    //{'name': 'South African coal',    'grade': 'Premium',  'gcv': '6500', 'price': 8200.0,  'available': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ShccAppBar(
          logoAsset: 'assets/images/logo.png',onProfileTap: () {}, userInitials: widget.isAdmin ? 'AD' : 'RS'),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
        Text('Product Catalogue', style: AppTextStyles.heading1),
        const SizedBox(height: 4),
        Text('${_products.length} products  ·  ${_products.where((p) => p['available'] == true).length} available',
          style: AppTextStyles.caption),
        const SizedBox(height: 20),
        ..._products.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ProductCard(
            product: entry.value,
            isAdmin: widget.isAdmin,
            onEdit: () => _editProduct(context, entry.key),
          ),
        )),
      ]),
    );
  }

  void _editProduct(BuildContext context, int index) {
    final p = _products[index];
    final priceCtrl = TextEditingController(text: p['price'].toString());
    bool available = p['available'] as bool;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Edit Product', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(p['name'] as String, style: AppTextStyles.bodySecondary),
            const SizedBox(height: 24),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number,
              style: AppTextStyles.body,
              decoration: const InputDecoration(labelText: 'Price per MT (₹)', prefixText: '₹ ')),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Available', style: AppTextStyles.bodyMedium),
              Switch(value: available, onChanged: (v) => setModal(() => available = v), activeThumbColor: AppColors.primary),
            ]),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity,
              child: ElevatedButton(onPressed: () {
                setState(() {
                  _products[index]['price'] = double.tryParse(priceCtrl.text) ?? p['price'];
                  _products[index]['available'] = available;
                });
                Navigator.pop(ctx);
              }, child: const Text('Save Changes'))),
          ]),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isAdmin;
  final VoidCallback onEdit;

  const _ProductCard({required this.product, required this.isAdmin, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final avail = product['available'] as bool;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Container(width: 48, height: 48,
          decoration: BoxDecoration(
            color: avail ? AppColors.primaryMuted : AppColors.bgBase,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.local_fire_department_rounded,
            color: avail ? AppColors.primary : AppColors.textMuted, size: 24)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product['name'] as String, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 2),

          Row(children: [
            Text('₹${(product['price'] as double).toStringAsFixed(0)}/MT',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: avail ? AppColors.successMuted : AppColors.errorMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(avail ? 'Available' : 'Unavailable',
                style: AppTextStyles.badge.copyWith(color: avail ? AppColors.success : AppColors.error)),
            ),
          ]),
        ])),
        if (isAdmin)
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
            onPressed: onEdit,
          ),
      ]),
    );
  }
}
