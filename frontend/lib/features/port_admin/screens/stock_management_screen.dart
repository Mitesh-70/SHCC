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
  String? _selectedPortFilter;
  String? _selectedCoalFilter;

  // Manual Adjustments Form controllers
  final _qtyCtrl = TextEditingController();
  final _remarkCtrl = TextEditingController();
  String _adjustmentType = 'add'; // 'add' or 'subtract'
  String? _formSelectedPort;
  String? _formSelectedCoal;

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

  // Fetch stock levels filtered by port and coal
  List<Map<String, dynamic>> get _filteredStock {
    final list = <Map<String, dynamic>>[];
    for (final port in _myPorts) {
      if (_selectedPortFilter != null && _selectedPortFilter != port) continue;
      final portStock = StockStore.getStockForPort(port);
      portStock.forEach((coal, qty) {
        if (_selectedCoalFilter != null && _selectedCoalFilter != coal) return;
        list.add({
          'port': port,
          'coalType': coal,
          'quantity': qty,
        });
      });
    }
    // Sort: port name first, then coal type
    list.sort((a, b) {
      final portComp = (a['port'] as String).compareTo(b['port'] as String);
      if (portComp != 0) return portComp;
      return (a['coalType'] as String).compareTo(b['coalType'] as String);
    });
    return list;
  }

  // Fetch transactions filtered
  List<StockTransaction> get _filteredTransactions {
    final txs = StockStore.getTransactionsForPorts(_myPorts);
    return txs.where((tx) {
      if (_selectedPortFilter != null && tx.port != _selectedPortFilter) return false;
      if (_selectedCoalFilter != null && tx.coalType != _selectedCoalFilter) return false;
      return true;
    }).toList();
  }

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

    setState(() {
      _formSelectedPort = preselectedPort ?? (_myPorts.isNotEmpty ? _myPorts.first : null);
      _formSelectedCoal = preselectedCoal ?? (AppConstants.productTypes.isNotEmpty ? AppConstants.productTypes.first : null);
      _qtyCtrl.clear();
      _remarkCtrl.clear();
      _adjustmentType = 'add';
    });

    final theme = Theme.of(context);
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
              Text(
                'Manual Stock Entry',
                style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 16),

              // Port and Coal Selection
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _formSelectedPort,
                      decoration: const InputDecoration(labelText: 'Port', isDense: true),
                      items: _myPorts
                          .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (v) => setModalState(() => _formSelectedPort = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _formSelectedCoal,
                      decoration: const InputDecoration(labelText: 'Coal Type', isDense: true),
                      items: AppConstants.productTypes
                          .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14))))
                          .toList(),
                      onChanged: (v) => setModalState(() => _formSelectedCoal = v),
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
                      label: const Center(
                        child: Text(
                          'Add / Increase Stock (+)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      selected: _adjustmentType == 'add',
                      selectedColor: AppColors.success.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.success,
                      labelStyle: TextStyle(
                        color: _adjustmentType == 'add' ? AppColors.success : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: _adjustmentType == 'add' ? AppColors.success : AppColors.border,
                      ),
                      onSelected: (val) {
                        if (val) setModalState(() => _adjustmentType = 'add');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(
                        child: Text(
                          'Reduce Stock (-)',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      selected: _adjustmentType == 'subtract',
                      selectedColor: AppColors.error.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.error,
                      labelStyle: TextStyle(
                        color: _adjustmentType == 'subtract' ? AppColors.error : AppColors.textSecondary,
                      ),
                      side: BorderSide(
                        color: _adjustmentType == 'subtract' ? AppColors.error : AppColors.border,
                      ),
                      onSelected: (val) {
                        if (val) setModalState(() => _adjustmentType = 'subtract');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quantity Field
              TextField(
                controller: _qtyCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Quantity (MT)',
                  prefixIcon: Icon(Icons.scale_rounded, size: 18),
                ),
              ),
              const SizedBox(height: 16),

              // Remark Field
              TextField(
                controller: _remarkCtrl,
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
                    backgroundColor: _adjustmentType == 'add' ? AppColors.success : AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final qty = double.tryParse(_qtyCtrl.text) ?? 0.0;
                    final remark = _remarkCtrl.text.trim();
                    if (qty <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid quantity.')),
                      );
                      return;
                    }
                    if (remark.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Remarks are required for audit trail.')),
                      );
                      return;
                    }
                    if (_formSelectedPort == null || _formSelectedCoal == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select Port and Coal Type.')),
                      );
                      return;
                    }

                    try {
                      final finalQty = _adjustmentType == 'add' ? qty : -qty;
                      if (_adjustmentType == 'subtract') {
                        final current = StockStore.getStock(_formSelectedPort!, _formSelectedCoal!);
                        if (current < qty) {
                          ScaffoldMessenger.of(context).showSnackBar(
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
                        _formSelectedPort!,
                        _formSelectedCoal!,
                        finalQty,
                        remark,
                        AppSession.instance.name,
                      );

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.white),
                              const SizedBox(width: 8),
                              Text('Stock updated successfully for $_formSelectedPort!'),
                            ],
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filteredStock = _filteredStock;
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
      body: Column(
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
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Current Stock'),
                      Tab(text: 'Audit Trail'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Filter Bar ─────────────────────────────────────────────────────
          _buildFilterBar(isDark),

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

                      // Stock breakdown progress bars
                      _buildBreakdownSection(breakdown, isDark),
                      const SizedBox(height: 24),

                      Text('Stock Details', style: AppTextStyles.heading3),
                      const SizedBox(height: 12),

                      if (filteredStock.isEmpty)
                        _buildEmptyState('No stock entries match the selected filters.')
                      else
                        ...filteredStock.map((s) => _buildStockTile(s, isDark)),
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
    );
  }

  Widget _buildFilterBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Port Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedPortFilter,
              decoration: const InputDecoration(
                labelText: 'Filter Port',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('All Ports', style: TextStyle(fontSize: 13))),
                ..._myPorts.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 13)))),
              ],
              onChanged: (v) => setState(() => _selectedPortFilter = v),
            ),
          ),
          const SizedBox(width: 12),
          // Coal Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCoalFilter,
              decoration: const InputDecoration(
                labelText: 'Filter Coal',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: [
                const DropdownMenuItem<String>(value: null, child: Text('All Coal Types', style: TextStyle(fontSize: 13))),
                ...AppConstants.productTypes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))),
              ],
              onChanged: (v) => setState(() => _selectedCoalFilter = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiWidgets(bool isDark) {
    return Row(
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
                Text(
                  '${_totalStock.toStringAsFixed(0)} MT',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Managed Stock',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
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
                Text(
                  '$_lowStockCount Items',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _lowStockCount > 0 ? AppColors.error : AppColors.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Low Stock Alerts',
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownSection(Map<String, double> breakdown, bool isDark) {
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
          Text('Stock Breakdown by Coal Type', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (breakdown.isEmpty)
            Text('No stock metrics to display.', style: AppTextStyles.caption)
          else
            ...breakdown.entries.map((e) {
              final pct = _totalStock == 0 ? 0.0 : e.value / _totalStock;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
                        Text('${e.value.toStringAsFixed(0)} MT (${(pct * 100).toStringAsFixed(0)}%)',
                            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 6,
                        backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                        valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildStockTile(Map<String, dynamic> s, bool isDark) {
    final qty = s['quantity'] as double;
    final isLow = qty < StockStore.lowStockThreshold;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBgCard : AppColors.lightBgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isLow ? AppColors.error.withValues(alpha: 0.35) : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isLow ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: isLow ? AppColors.error : AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['coalType'] as String, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.anchor_rounded, size: 12, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(s['port'] as String, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${qty.toStringAsFixed(0)} MT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isLow ? AppColors.error : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                ),
              ),
              const SizedBox(height: 4),
              if (isLow)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Low Stock',
                    style: TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                )
              else if (!widget.isAdminView)
                GestureDetector(
                  onTap: () => _showAdjustStockSheet(context, preselectedPort: s['port'], preselectedCoal: s['coalType']),
                  child: Row(
                    children: [
                      Text(
                        'Adjust',
                        style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.primary, size: 14),
                    ],
                  ),
                ),
            ],
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
              Text(
                typeLabel,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
              ),
              const Spacer(),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'By: ${tx.operator}',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
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
