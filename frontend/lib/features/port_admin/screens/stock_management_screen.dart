import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/session/app_session.dart';
import '../../../data/stock_store.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../profile/screens/profile_screen.dart';

class StockManagementScreen extends StatefulWidget {
  final bool isAdminView;

  const StockManagementScreen({super.key, this.isAdminView = false});

  @override
  State<StockManagementScreen> createState() => _StockManagementScreenState();
}

class _StockManagementScreenState extends State<StockManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Manual Adjustments Form controllers
  final _qtyCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _qtyCtrl.dispose();
    _remarkCtrl.dispose();
    super.dispose();
  }

  List<String> get _myPorts => widget.isAdminView
      ? AppConstants.ports
      : AppSession.instance.assignedPorts;

  // Fetch transactions for the Audit Trail tab (all ports, no filter)
  List<StockTransaction> get _filteredTransactions =>
      StockStore.getTransactionsForPorts(_myPorts);

  // Dashboard Stats Calculations
  double get _totalStock {
    double total = 0;
    for (final port in _myPorts) {
      final portStock = StockStore.getStockForPort(port);
      portStock.forEach((_, qty) => total += qty);
    }
    return total;
  }

  int get _lowStockCount {
    int count = 0;
    for (final port in _myPorts) {
      final portStock = StockStore.getStockForPort(port);
      portStock.forEach((_, qty) {
        if (qty < StockStore.lowStockThreshold) count++;
      });
    }
    return count;
  }

  Map<String, double> get _breakdown {
    final map = <String, double>{};
    for (final port in _myPorts) {
      final portStock = StockStore.getStockForPort(port);
      portStock.forEach((coal, qty) {
        map[coal] = (map[coal] ?? 0.0) + qty;
      });
    }
    return map;
  }



  void _showAdjustStockSheet(BuildContext context, {String? preselectedPort, String? preselectedCoal}) {
    if (widget.isAdminView) return; // Admin has read-only visibility

    final scaffoldMsg = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    // Local form state — lives entirely inside the bottom sheet
    String? localPort = preselectedPort ?? (_myPorts.isNotEmpty ? _myPorts.first : null);
    String? localCoal = preselectedCoal ?? (AppConstants.productTypes.isNotEmpty ? AppConstants.productTypes.first : null);
    String localAdjustmentType = 'add';
    final localQtyCtrl = TextEditingController();
    final localRemarkCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text('Manual Stock Entry', style: AppTextStyles.heading2.copyWith(color: AppColors.primary)),
              const SizedBox(height: 20),

              // Port + Coal dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: localPort,
                      decoration: const InputDecoration(labelText: 'Port', isDense: true),
                      items: _myPorts
                          .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (v) => setModalState(() => localPort = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: localCoal,
                      decoration: const InputDecoration(labelText: 'Coal Type', isDense: true),
                      items: AppConstants.productTypes
                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (v) => setModalState(() => localCoal = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Transaction Type Selector
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      showCheckmark: false,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: const SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Add Stock (+)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      selected: localAdjustmentType == 'add',
                      selectedColor: AppColors.success.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: localAdjustmentType == 'add' ? AppColors.success : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: localAdjustmentType == 'add' ? AppColors.success : AppColors.border,
                      ),
                      onSelected: (val) {
                        if (val) setModalState(() => localAdjustmentType = 'add');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      showCheckmark: false,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: const SizedBox(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Reduce Stock (-)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                      selected: localAdjustmentType == 'subtract',
                      selectedColor: AppColors.error.withValues(alpha: 0.15),
                      labelStyle: TextStyle(
                        color: localAdjustmentType == 'subtract' ? AppColors.error : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: localAdjustmentType == 'subtract' ? AppColors.error : AppColors.border,
                      ),
                      onSelected: (val) {
                        if (val) setModalState(() => localAdjustmentType = 'subtract');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quantity Field
              TextField(
                controller: localQtyCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Quantity (MT)',
                  prefixIcon: Icon(Icons.scale_rounded, size: 18),
                ),
              ),
              const SizedBox(height: 16),

              // Remark Field
              TextField(
                controller: localRemarkCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Remarks / Reason (Required)',
                  prefixIcon: Icon(Icons.comment_outlined, size: 18),
                  hintText: 'e.g. Vessel unloading, correction, quality removal...',
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: localAdjustmentType == 'add' ? AppColors.success : AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final qty = double.tryParse(localQtyCtrl.text) ?? 0.0;
                    final remark = localRemarkCtrl.text.trim();
                    if (qty <= 0) {
                      scaffoldMsg.showSnackBar(
                        const SnackBar(content: Text('Please enter a valid quantity.')),
                      );
                      return;
                    }
                    if (remark.isEmpty) {
                      scaffoldMsg.showSnackBar(
                        const SnackBar(content: Text('Remarks are required for audit trail.')),
                      );
                      return;
                    }
                    if (localPort == null || localCoal == null) {
                      scaffoldMsg.showSnackBar(
                        const SnackBar(content: Text('Please select Port and Coal Type.')),
                      );
                      return;
                    }

                    try {
                      final finalQty = localAdjustmentType == 'add' ? qty : -qty;
                      if (localAdjustmentType == 'subtract') {
                        final current = StockStore.getStock(localPort!, localCoal!);
                        if (current < qty) {
                          scaffoldMsg.showSnackBar(
                            SnackBar(
                              content: Text(
                                'Cannot reduce stock below 0. Available: ${current.toStringAsFixed(0)} MT.',
                              ),
                            ),
                          );
                          return;
                        }
                      }

                      StockStore.adjustStockManual(
                        localPort!,
                        localCoal!,
                        finalQty,
                        remark,
                        AppSession.instance.name,
                      );

                      Navigator.pop(ctx);
                      scaffoldMsg.showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Stock updated successfully for $localPort!',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      setState(() {});
                    } catch (e) {
                      scaffoldMsg.showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: const Text('Confirm Stock Update'),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filteredTxs = _filteredTransactions;
    final breakdown = _breakdown;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        showBranding: widget.isAdminView ? false : true,
        title: widget.isAdminView ? 'Port Stocks' : null,
        showProfileIcon: false,
        leading: widget.isAdminView
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        userInitials: widget.isAdminView ? 'AD' : AppSession.instance.initials,
        onProfileTap: widget.isAdminView
            ? null
            : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(isPortAdmin: true, fromTab: false),
                  ),
                ).then((_) => setState(() {})),
      ),
      floatingActionButton: widget.isAdminView
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showAdjustStockSheet(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Update Stock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // ── Header & TabBar ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isAdminView ? 'Stock Visibility' : 'Stock Management',
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isAdminView
                      ? 'Global inventory across all active ports'
                      : _myPorts.join('  ·  '),
                  style: AppTextStyles.bodySecondary,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFE4E7EC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabCtrl,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    tabs: const [
                      Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Current Stock'))),
                      Tab(child: FittedBox(fit: BoxFit.scaleDown, child: Text('Audit Trail'))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Tab Views ──────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // ── Tab 1: Current Stock ──
                RefreshIndicator(
                  onRefresh: () async => setState(() {}),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    children: [
                      // KPI Widgets
                      _buildKpiWidgets(isDark),
                      const SizedBox(height: 20),

                      // Stock storage bar breakdown
                      _buildStorageBarSection(breakdown, isDark),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                // ── Tab 2: Audit Trail ──
                RefreshIndicator(
                  onRefresh: () async => setState(() {}),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    children: [
                      Text('Stock History / Audit Trail', style: AppTextStyles.heading3),
                      const SizedBox(height: 4),
                      Text(
                        'Track all stock entries, manual adjustments, and delivery updates.',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 16),
                      if (filteredTxs.isEmpty)
                        _buildEmptyState('No transactions logged for selected ports.')
                      else
                        ...filteredTxs.map((tx) => _buildTransactionTile(tx, isDark)),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ],
        ),
      ),
      ),
    );
  }


  Widget _buildKpiWidgets(bool isDark) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warehouse_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_totalStock.toStringAsFixed(0)} MT',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      'Total Managed Stock',
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _lowStockCount > 0
                    ? AppColors.error.withValues(alpha: isDark ? 0.08 : 0.05)
                    : AppColors.success.withValues(alpha: isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _lowStockCount > 0
                      ? AppColors.error.withValues(alpha: 0.25)
                      : AppColors.success.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _lowStockCount > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                    color: _lowStockCount > 0 ? AppColors.error : AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$_lowStockCount Items',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _lowStockCount > 0 ? AppColors.error : AppColors.success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      'Low Stock Alerts',
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCoalColor(String coalType) {
    final lower = coalType.toLowerCase();
    if (lower.contains('indonesian')) return const Color(0xFF9b51e0);
    if (lower.contains('south african')) return const Color(0xFF00c4b4);
    if (lower.contains('us coal') || lower.contains('united states')) return const Color(0xFF2d9cdb);
    if (lower.contains('russian')) return const Color(0xFFeb5757);
    return const Color(0xFFf2994a); // fallback
  }

  Widget _buildStorageBarSection(Map<String, double> breakdown, bool isDark) {
    if (breakdown.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Text('No stock metrics to display.', style: AppTextStyles.caption),
      );
    }

    // Build the segmented bar
    List<Widget> segments = [];
    breakdown.forEach((coalType, qty) {
      if (qty > 0) {
        segments.add(
          Expanded(
            flex: (qty * 1000).toInt(),
            child: Container(color: _getCoalColor(coalType)),
          ),
        );
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stock Breakdown',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            height: 14,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0),
            ),
            child: Row(children: segments),
          ),
          const SizedBox(height: 16),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
              children: breakdown.entries.map((e) {
                final coalType = e.key;
                final totalQty = e.value;
                if (totalQty <= 0) return const SizedBox();

                // Build port breakdown for this coal type
                final Map<String, double> portBreakdownForCoal = {};
                for (final port in _myPorts) {
                  final qty = StockStore.getStock(port, coalType);
                  if (qty > 0) portBreakdownForCoal[port] = qty;
                }

                return ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  iconColor: isDark ? Colors.white54 : Colors.black54,
                  collapsedIconColor: isDark ? Colors.white54 : Colors.black54,
                  title: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 16,
                        color: _getCoalColor(coalType),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          coalType,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${totalQty.toStringAsFixed(0)} MT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  children: portBreakdownForCoal.entries.map((portEntry) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 22, right: 8, top: 4, bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.anchor_rounded, size: 14, color: isDark ? Colors.white54 : Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              portEntry.key,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ),
                          Text(
                            '${portEntry.value.toStringAsFixed(0)} MT',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTransactionTile(StockTransaction tx, bool isDark) {
    IconData icon;
    Color color;
    String typeLabel;
    String sign = '';

    switch (tx.type) {
      case 'manual_add':
        icon = Icons.add_circle_outline;
        color = AppColors.success;
        typeLabel = 'Manual Refill';
        sign = '+';
        break;
      case 'manual_adjust':
        icon = tx.quantity >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
        color = tx.quantity >= 0 ? AppColors.success : AppColors.error;
        typeLabel = 'Manual Adjust';
        sign = tx.quantity >= 0 ? '+' : '';
        break;
      case 'dispatch_reduction':
        icon = Icons.local_shipping_outlined;
        color = AppColors.info;
        typeLabel = 'Cargo Dispatch';
        break;
      case 'dispatch_restore':
        icon = Icons.restore_rounded;
        color = AppColors.success;
        typeLabel = 'Cargo Restored';
        sign = '+';
        break;
      default:
        icon = Icons.swap_horiz;
        color = AppColors.textMuted;
        typeLabel = tx.type;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  typeLabel,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$sign${tx.quantity.toStringAsFixed(0)} MT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${tx.coalType}  ·  Port: ${tx.port}',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          if (tx.remark.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              tx.remark,
              style: AppTextStyles.caption.copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          const Divider(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  'By: ${tx.operator}',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${tx.date}  ·  ${tx.time}',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: AppColors.textMuted),
          const SizedBox(height: 12),
          Text(
            msg,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}