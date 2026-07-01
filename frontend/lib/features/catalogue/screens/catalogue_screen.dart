import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/stock_store.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../profile/screens/profile_screen.dart';

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
        onProfileTap: () => Navigator.push(context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              isAdmin: widget.isAdmin,
              fromTab: false,
            ))),
        userInitials: widget.isAdmin ? 'AD' : 'RS',
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Catalogue',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700, letterSpacing: -0.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('${_products.length} products  ·  $available available',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      ),
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
                activeThumbColor: AppColors.primary,
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

  // Badge widget shared between layouts
  Widget _badge(bool avail) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: avail
        ? AppColors.success.withValues(alpha: 0.12)
        : AppColors.error.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20)),
    child: Text(avail ? 'Available' : 'Unavailable',
      style: TextStyle(
        fontSize: 11, fontWeight: FontWeight.w600,
        color: avail ? AppColors.success : AppColors.error)));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final avail = product['available'] as bool;
    final cardBg = isDark ? AppColors.bgCard : AppColors.lightBgCard;
    final border = isDark ? AppColors.border : AppColors.lightBorder;

    // Original fire icon
    const coalIcon = Icons.local_fire_department_rounded;

    final iconBox = Icon(
      coalIcon,
      color: avail
          ? AppColors.primary
          : (isDark ? AppColors.textMuted : AppColors.lightTextMuted),
      size: 28,
    );

    final cardDecoration = BoxDecoration(
      color: cardBg,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: border),
      boxShadow: isDark
        ? null
        : [BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6, offset: const Offset(0, 2))],
    );

    // ── ADMIN layout: icon | name + price + inline badge | edit button ──
    if (isAdmin) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              iconBox,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '₹${(product['price'] as double).toStringAsFixed(0)}/MT',
                            style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w700,
                              color: AppColors.primary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _badge(avail),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onEdit,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.edit_outlined, size: 20,
                    color: isDark ? AppColors.textSecondary
                      : AppColors.lightTextSecondary),
                ),
              ),
            ]),
            const Divider(height: 20),
            Text('Current Stock by Port:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
            const SizedBox(height: 8),
            Column(
              children: [
                for (int i = 0; i < AppConstants.ports.length; i += 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(child: _buildPortStockItem(AppConstants.ports[i], product['name'] as String, isDark)),
                        if (i + 1 < AppConstants.ports.length)
                          Expanded(child: _buildPortStockItem(AppConstants.ports[i + 1], product['name'] as String, isDark))
                        else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    // ── SALESPERSON layout: badge pinned top-right, no inline badge ──
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration,
      child: Stack(clipBehavior: Clip.none, children: [
        // Main content row
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          iconBox,
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '₹${(product['price'] as double).toStringAsFixed(0)}/MT',
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700,
                    color: AppColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 70), // reserve space for badge
        ]),
        // Badge pinned to top-right
        Positioned(
          top: 0, right: 0,
          child: _badge(avail)),
      ]),
    );
  }

  Widget _buildPortStockItem(String port, String productName, bool isDark) {
    final qty = StockStore.getStock(port, productName);
    final isLow = qty < StockStore.lowStockThreshold;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.anchor_rounded, size: 14, color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text('$port: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary), overflow: TextOverflow.ellipsis),
        ),
        Text(
          '${qty.toStringAsFixed(0)} MT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isLow ? AppColors.error : AppColors.primary,
          ),
        ),
      ],
    );
  }
}