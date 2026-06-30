import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../core/session/app_session.dart';
import '../../../data/order_store.dart';
import '../../profile/screens/profile_screen.dart';

const _salesPersons = ['All', 'Raj Sharma', 'Amit Patel', 'Priya Mehta'];

class ReportsScreen extends StatefulWidget {
  final String userRole;

  const ReportsScreen({super.key, this.userRole = 'admin'});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ── Filter state ───────────────────────────────────────────────────
  DateTime? _fromDate;
  DateTime? _toDate;
  late String _salesperson;
  late String _port;
  bool   _pdfLoading     = false;

  @override
  void initState() {
    super.initState();
    _salesperson = widget.userRole == 'sales_person' && AppSession.isLoggedIn
        ? AppSession.instance.name
        : 'All';
    _port = 'All';
  }

  bool get _hasActiveFilters => 
    _fromDate != null || _toDate != null || _salesperson != 'All' || _port != 'All';

  // ── Filtered orders ────────────────────────────────────────────────
  List<Map<String, dynamic>> get _baseOrders {
    switch (widget.userRole) {
      case 'port_admin':
        return OrderStore.getOrdersForPorts(AppSession.instance.assignedPorts);
      case 'sales_person':
        return OrderStore.getOrdersForSalesPerson(AppSession.instance.name);
      default:
        return OrderStore.getAllOrders();
    }
  }

  List<Map<String, dynamic>> get _filtered {
    return _baseOrders.where((o) {
      if (_fromDate != null || _toDate != null) {
        final dateStr = (o['date_iso'] ?? o['date']) as String;
        final parts = dateStr.contains('-')
            ? dateStr.split('-')
            : dateStr.split(' ').reversed.toList();
        DateTime? d;
        if (parts.length >= 3 && parts[0].length == 4) {
          d = DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        }
        if (d != null) {
          if (_fromDate != null && d.isBefore(_fromDate!)) return false;
          if (_toDate != null && d.isAfter(_toDate!)) return false;
        }
      }
      if (_salesperson != 'All' && o['sales_person_name'] != _salesperson) {
        return false;
      }
      if (_port != 'All' && o['port_name'] != _port) return false;
      return true;
    }).toList();
  }

  // ── Metrics ────────────────────────────────────────────────────────
  double _total(Map<String, dynamic> o) {
    final b = (o['base_rate'] as num).toDouble()
      * (o['quantity'] as num).toDouble();
    final f = ((o['freight'] ?? 0.0) as num).toDouble();
    return b + f + b * ((o['gst'] as num) / 100)
                 + b * ((o['tcs'] as num) / 100);
  }

  double get _revenue  => _filtered.fold(0, (s, o) => s + _total(o));
  double get _qty      => _filtered.fold(
    0, (s, o) => s + (o['quantity'] as num).toDouble());
  int get _pendingApproval => _filtered
      .where((o) => o['status'] == AppConstants.statusPendingApproval).length;
  int get _approved => _filtered
      .where((o) => o['status'] == AppConstants.statusApproved).length;
  int get _dispatched => _filtered
      .where((o) => o['status'] == AppConstants.statusDispatched).length;
  int get _onHold => _filtered
      .where((o) => o['status'] == AppConstants.statusOnHold).length;
  int get _completed => _filtered
      .where((o) => o['status'] == AppConstants.statusCompleted).length;

  Map<String, Map<String, dynamic>> get _portStats {
    final stats = <String, Map<String, dynamic>>{};
    for (final o in _filtered) {
      final port = o['port_name'] as String;
      stats.putIfAbsent(port, () => {
        'orders': 0,
        'revenue': 0.0,
        'dispatched': 0,
        'completed': 0,
      });
      stats[port]!['orders'] = (stats[port]!['orders'] as int) + 1;
      stats[port]!['revenue'] =
          (stats[port]!['revenue'] as double) + _total(o);
      if (o['status'] == AppConstants.statusDispatched) {
        stats[port]!['dispatched'] =
            (stats[port]!['dispatched'] as int) + 1;
      }
      if (o['status'] == AppConstants.statusCompleted) {
        stats[port]!['completed'] =
            (stats[port]!['completed'] as int) + 1;
      }
    }
    return stats;
  }

  String _fmt(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(0)}';
  }

  // Format without ₹ symbol (for metric cards that already show a rupee icon)
  String _fmtNoSymbol(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '${(v / 100000).toStringAsFixed(2)} L';
    // ignore: unnecessary_string_interpolations
    return '${v.toStringAsFixed(0)}';
  }

  String _fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  // ── PDF generation ─────────────────────────────────────────────────
  Future<void> _downloadPdf() async {
    setState(() => _pdfLoading = true);
    final pdf = pw.Document();
    final orders = _filtered;
    final now = DateTime.now();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('SHCC',
                    style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Shree Hari Coal Corporation',
                    style: const pw.TextStyle(fontSize: 11)),
                ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('SALES REPORT',
                    style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                    'Generated: ${_fmtDate(now)} ${now.hour}:${now.minute.toString().padLeft(2,'0')}',
                    style: const pw.TextStyle(fontSize: 9)),
                  if (_fromDate != null || _toDate != null)
                    pw.Text(
                      'Period: ${_fromDate != null ? _fmtDate(_fromDate!) : 'Start'} → ${_toDate != null ? _fmtDate(_toDate!) : 'Today'}',
                      style: const pw.TextStyle(fontSize: 9)),
                ]),
            ]),
          pw.Divider(thickness: 1),
          pw.SizedBox(height: 4),
        ]),
      build: (ctx) => [
        // Filters applied
        if (_salesperson != 'All' || _port != 'All')
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(children: [
              pw.Text('Filters: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold,
                  fontSize: 10)),
              if (_salesperson != 'All')
                pw.Text('Salesperson: $_salesperson  ',
                  style: const pw.TextStyle(fontSize: 10)),
              if (_port != 'All')
                pw.Text('Port: $_port',
                  style: const pw.TextStyle(fontSize: 10)),
            ]),
          ),
        pw.SizedBox(height: 12),

        // Summary
        pw.Text('Summary',
          style: pw.TextStyle(
            fontSize: 13, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            _pdfHeaderRow(['Metric', 'Value']),
            _pdfRow(['Total Revenue', _fmt(_revenue)]),
            _pdfRow(['Total Orders',  '${orders.length}']),
            _pdfRow(['Total Quantity','${_qty.toStringAsFixed(0)} MT']),
            _pdfRow(['Approved',      '$_approved']),
            _pdfRow(['Dispatched',    '$_dispatched']),
            _pdfRow(['Completed',     '$_completed']),
            _pdfRow(['On Hold',       '$_onHold']),
            _pdfRow(['Pending',       '$_pendingApproval']),
          ],
        ),
        pw.SizedBox(height: 20),

        // Orders table
        pw.Text('Order Details',
          style: pw.TextStyle(
            fontSize: 13, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          columnWidths: {
            0: const pw.FlexColumnWidth(1.4),
            1: const pw.FlexColumnWidth(1.8),
            2: const pw.FlexColumnWidth(1.4),
            3: const pw.FlexColumnWidth(1.0),
            4: const pw.FlexColumnWidth(0.8),
            5: const pw.FlexColumnWidth(1.2),
            6: const pw.FlexColumnWidth(1.0),
            7: const pw.FlexColumnWidth(1.0),
          },
          children: [
            _pdfHeaderRow([
              'Order ID', 'Buyer', 'Salesperson',
              'Port', 'Qty (MT)', 'Amount', 'Status', 'Date',
            ]),
            ...orders.map((o) => _pdfRow([
              o['id'] as String,
              o['buyer_name'] as String,
              o['sales_person_name'] as String,
              o['port_name'] as String,
              (o['quantity'] as num).toStringAsFixed(0),
              _fmt(_total(o)),
              (o['status'] as String).toUpperCase(),
              (o['date'] as String).split('-').reversed.join('/'),
            ])),
          ],
        ),
      ],
    ));

    setState(() => _pdfLoading = false);
    await Printing.layoutPdf(
      onLayout: (fmt) async => pdf.save(),
      name: 'SHCC_Sales_Report_${now.millisecondsSinceEpoch}.pdf',
    );
  }

  pw.TableRow _pdfHeaderRow(List<String> cells) {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: cells.map((c) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        child: pw.Text(c,
          style: pw.TextStyle(
            fontSize: 9, fontWeight: pw.FontWeight.bold)),
      )).toList(),
    );
  }

  pw.TableRow _pdfRow(List<String> cells) {
    return pw.TableRow(
      children: cells.map((c) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: pw.Text(c, style: const pw.TextStyle(fontSize: 8)),
      )).toList(),
    );
  }

  // ── Date picker helper ─────────────────────────────────────────────
  Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: isDark
              ? const ColorScheme.dark(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.darkBgSurface,
                  onSurface: AppColors.darkTextPrimary,
                )
              : const ColorScheme.light(
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  surface: AppColors.lightBgSurface,
                  onSurface: AppColors.lightTextPrimary,
                ),
        ),
        child: child!,
      ),
    );
  }

  void _clearFilters() => setState(() {
    _fromDate = null; _toDate = null;
    _salesperson = 'All'; _port = 'All';
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        userInitials: AppSession.isLoggedIn
            ? AppSession.instance.initials
            : 'AD',
        onProfileTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileScreen(
              isAdmin: widget.userRole == 'admin',
              isPortAdmin: widget.userRole == 'port_admin',
              fromTab: false,
            ),
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            children: [

          // ── Header ───────────────────────────────────────────────
          Text('Sales Reports', style: AppTextStyles.heading1),
          const SizedBox(height: 8),
          

          // ── Filter panel ─────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.filter_list_rounded,
                    size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Filters', style: AppTextStyles.heading3),
                  const Spacer(),
                  if (_hasActiveFilters)
                    TextButton(
                      onPressed: _clearFilters,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Clear',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.error)),
                    ),
                ]),
                const SizedBox(height: 14),

                // Date range
                Row(children: [
                  Expanded(child: _DateField(
                    label: 'From Date',
                    date: _fromDate,
                    onTap: () async {
                      final d = await _pickDate(context, _fromDate);
                      if (d != null) setState(() => _fromDate = d);
                    },
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _DateField(
                    label: 'To Date',
                    date: _toDate,
                    onTap: () async {
                      final d = await _pickDate(context, _toDate);
                      if (d != null) setState(() => _toDate = d);
                    },
                  )),
                ]),
                const SizedBox(height: 12),

                // Salesperson dropdown
                _FilterDropdown(
                  label: 'Sales Person',
                  icon: Icons.person_outline_rounded,
                  selectedValue: _salesperson,
                  items: widget.userRole == 'sales_person' && AppSession.isLoggedIn
                      ? [AppSession.instance.name]
                      : _salesPersons,
                  onChanged: widget.userRole == 'sales_person'
                      ? null
                      : (v) => setState(() => _salesperson = v ?? 'All'),
                ),
                const SizedBox(height: 12),

                // Port dropdown
                _FilterDropdown(
                  label: 'Port',
                  icon: Icons.anchor_rounded,
                  selectedValue: _port,
                  items: widget.userRole == 'port_admin' && AppSession.isLoggedIn
                      ? ['All', ...AppSession.instance.assignedPorts]
                      : ['All', ...AppConstants.ports],
                  onChanged: (v) => setState(() => _port = v ?? 'All'),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: _pdfLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.picture_as_pdf_rounded, size: 16),
                    label: Text(_pdfLoading ? 'Generating...' : 'Download Report PDF'),
                    onPressed: _pdfLoading || filtered.isEmpty ? null : _downloadPdf,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Summary cards ─────────────────────────────────────────
          _SectionLabel('Summary', '${filtered.length} orders'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.1,
            children: [
              _MetricCard(
                label: 'Total Revenue',
                value: _fmtNoSymbol(_revenue),
                icon: Icons.currency_rupee_rounded,
                color: AppColors.success,
              ),
              _MetricCard(
                label: 'Total Orders',
                value: '${filtered.length}',
                icon: Icons.receipt_long_rounded,
                color: AppColors.info,
              ),
              _MetricCard(
                label: 'Total Quantity',
                value: '${_qty.toStringAsFixed(0)} MT',
                icon: Icons.scale_rounded,
                color: const Color(0xFF9B59B6),
              ),
              _MetricCard(
                label: 'Pending Approval',
                value: '$_pendingApproval',
                icon: Icons.hourglass_top_rounded,
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Status breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status Breakdown', style: AppTextStyles.heading3),
                const SizedBox(height: 14),
                _StatusRow('Approved', _approved,
                  filtered.length, const Color(0xFF3B82F6)),
                const SizedBox(height: 8),
                _StatusRow('Dispatched', _dispatched,
                  filtered.length, const Color(0xFF14B8A6)),
                const SizedBox(height: 8),
                _StatusRow('On Hold', _onHold,
                  filtered.length, AppColors.warning),
                const SizedBox(height: 8),
                _StatusRow('Completed', _completed,
                  filtered.length, AppColors.success),
                const SizedBox(height: 8),
                _StatusRow('Pending Approval', _pendingApproval,
                  filtered.length, const Color(0xFFEAB308)),
              ],
            ),
          ),
          if (widget.userRole == 'admin' || widget.userRole == 'port_admin') ...[
            const SizedBox(height: 24),
            _SectionLabel('Port-wise Report', '${_portStats.length} ports'),
            const SizedBox(height: 12),
            ..._portStats.entries.map((e) {
              final orders = e.value['orders'] as int;
              final completed = e.value['completed'] as int;
              final dispatched = e.value['dispatched'] as int;
              final rate = orders == 0 ? 0.0 : completed / orders;
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.key, style: AppTextStyles.heading3),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.receipt_long_rounded, size: 15, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text('$orders Orders', style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.local_shipping_rounded, size: 15, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text('$dispatched Dispatched', style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_outline_rounded, size: 15, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text('$completed Completed', style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.currency_rupee_rounded, size: 15, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text('${_fmtNoSymbol(e.value['revenue'] as double)} Revenue', style: AppTextStyles.caption, overflow: TextOverflow.ellipsis),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Completion Rate', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                                Text(
                                  '${(rate * 100).toStringAsFixed(0)}%',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: rate,
                                minHeight: 4,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 24),

          // ── Invoice list ──────────────────────────────────────────
          _SectionLabel('Invoices', '${filtered.length} records'),
          const SizedBox(height: 12),

          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.receipt_outlined,
              title: 'No invoices found',
              subtitle: 'Adjust your filters to see invoices',
            )
          else
            ...filtered.map((o) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _InvoiceCard(order: o, total: _total(o), fmt: _fmt),
            )),
        ],
      ),
      ),
      ),
    );
  }
}

// ── Status row with progress bar ──────────────────────────────────────────────
class _StatusRow extends StatelessWidget {
  final String label;
  final int count, total;
  final Color color;
  const _StatusRow(this.label, this.count, this.total, this.color);

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : count / total;
    return Row(children: [
      SizedBox(width: 80,
        child: Text(label, style: AppTextStyles.caption)),
      Expanded(child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: pct, minHeight: 6,
          backgroundColor: AppColors.bgBase,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      )),
      const SizedBox(width: 8),
      Text('$count', style: AppTextStyles.caption.copyWith(color: color)),
    ]);
  }
}

// ── Invoice card ──────────────────────────────────────────────────────────────
class _InvoiceCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final double total;
  final String Function(double) fmt;

  const _InvoiceCard({
    required this.order, required this.total, required this.fmt});

  Color _statusColor(String s) {
    switch (s) {
      case 'confirmed': return const Color(0xFF9B59B6);
      case 'completed': return AppColors.success;
      case 'processed': return AppColors.info;
      default:          return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = order['status'] as String;
    final color  = _statusColor(status);
    final dateStr = (order['date_iso'] ?? '') as String;
    final dateParts = dateStr.contains('-') ? dateStr.split('-') : [];
    final displayDate = dateParts.length >= 3
        ? '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}'
        : (order['date'] as String? ?? 'Unknown');

    return GestureDetector(
      onTap: () => _showInvoice(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(order['id'] as String,
              style: AppTextStyles.label.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withValues(alpha: 0.35)),
              ),
              child: Text(status.toUpperCase(),
                style: AppTextStyles.badge.copyWith(color: color, fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 12),
          Text(order['buyer_name'] as String, 
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            )),
          const SizedBox(height: 10),
          
          // Salesperson, Port & Date Grid Layout
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(order['sales_person_name'] as String, 
                        style: AppTextStyles.bodySecondary, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.anchor_rounded, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(order['port_name'] as String, 
                        style: AppTextStyles.bodySecondary, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(displayDate, 
                        style: AppTextStyles.bodySecondary, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: SizedBox()),
            ],
          ),
          
          const SizedBox(height: 16),
          Divider(color: AppColors.border.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 16),
  
          Row(
            children: [
              Text(fmt(total),
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.primary, 
                  fontWeight: FontWeight.bold,
                )),
              const Spacer(),
              GestureDetector(
                onTap: () => _downloadInvoice(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.download_outlined, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Download',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void _showInvoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6, maxChildSize: 0.9,
        minChildSize: 0.4, expand: false,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Center(child: Container(
              width: 36, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2)),
            )),
            Text('Invoice', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(order['id'] as String,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary)),
            const SizedBox(height: 20),
            _InvRow('Buyer',        order['buyer_name'] as String),
            _InvRow('Salesperson',  order['sales_person_name'] as String),
            _InvRow('Product',      order['product_type'] as String),
            _InvRow('Port',         order['port_name'] as String),
            _InvRow('Quantity',     '${order['quantity']} MT'),
            _InvRow('Base Rate',    '₹${order['base_rate']}/MT'),
            _InvRow('Freight',      '₹${((order['freight'] ?? 0.0) as num).toDouble().toStringAsFixed(2)}'),
            _InvRow('GST',          '${order['gst']}%'),
            _InvRow('TCS',          '${order['tcs']}%'),
            Divider(color: AppColors.border, height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total Amount', style: AppTextStyles.heading3),
              Text(fmt(total), style: AppTextStyles.heading3.copyWith(
                color: AppColors.primary)),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadInvoice(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('SHCC',
                    style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Shree Hari Coal Corporation',
                    style: const pw.TextStyle(fontSize: 10)),
                ]),
              pw.Text('INVOICE',
                style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ]),
          pw.SizedBox(height: 4),
          pw.Divider(),
          pw.SizedBox(height: 12),
          pw.Text(order['id'] as String,
            style: pw.TextStyle(
              fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              _pRow('Buyer',        order['buyer_name'] as String),
              _pRow('Salesperson',  order['sales_person_name'] as String),
              _pRow('Product',      order['product_type'] as String),
              _pRow('Port',         order['port_name'] as String),
              _pRow('Quantity',     '${order['quantity']} MT'),
              _pRow('Base Rate',    '₹${order['base_rate']}/MT'),
              _pRow('Freight',      '₹${((order['freight'] ?? 0.0) as num).toDouble().toStringAsFixed(2)}'),
              _pRow('GST',          '${order['gst']}%'),
              _pRow('TCS',          '${order['tcs']}%'),
              _pRow('Status',       (order['status'] as String).toUpperCase()),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL AMOUNT',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(fmt(total),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold, fontSize: 12)),
              ]),
          ),
        ]),
    ));
    await Printing.layoutPdf(
      onLayout: (f) async => pdf.save(),
      name: 'Invoice_${order['id']}.pdf',
    );
  }

  pw.TableRow _pRow(String l, String v) => pw.TableRow(children: [
    pw.Padding(padding: const pw.EdgeInsets.all(6),
      child: pw.Text(l,
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9))),
    pw.Padding(padding: const pw.EdgeInsets.all(6),
      child: pw.Text(v, style: const pw.TextStyle(fontSize: 9))),
  ]);
}

class _InvRow extends StatelessWidget {
  final String label, value;
  const _InvRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      SizedBox(width: 110,
        child: Text(label, style: AppTextStyles.caption)),
      Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
    ]),
  );
}

// ignore: unused_element
class _InvBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const _InvBtn({
    required this.icon, required this.label,
    // ignore: unused_element_parameter
    required this.onTap, this.primary = false,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: primary ? AppColors.primaryMuted : AppColors.bgBase,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primary ? AppColors.primary : AppColors.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13,
          color: primary ? AppColors.primary : AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption.copyWith(
          color: primary ? AppColors.primary : AppColors.textSecondary,
          fontWeight: primary ? FontWeight.w600 : FontWeight.w400,
        )),
      ]),
    ),
  );
}

// ── Shared small widgets ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title, sub;
  const _SectionLabel(this.title, this.sub);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: AppTextStyles.heading3),
      Text(sub, style: AppTextStyles.caption.copyWith(
        color: AppColors.primary)),
    ],
  );
}

class _MetricCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _MetricCard({
    required this.label, required this.value,
    required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.04)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.caption.copyWith(
              color: isDark ? Colors.white70 : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  const _DateField({required this.label, required this.date, required this.onTap});

  String _fmt(DateTime d) =>
    '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: date != null ? AppColors.primary : AppColors.border),
      ),
      child: Row(children: [
        Icon(Icons.calendar_today_outlined, size: 15,
          color: date != null ? AppColors.primary : AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
            const SizedBox(height: 2),
            Text(date != null ? _fmt(date!) : 'Select',
              style: AppTextStyles.caption.copyWith(
                color: date != null
                  ? AppColors.textPrimary : AppColors.textMuted,
                fontWeight: date != null
                  ? FontWeight.w500 : FontWeight.w400,
              )),
          ],
        )),
      ]),
    ),
  );
}

class _FilterDropdown extends StatelessWidget {
  final String label, selectedValue;
  final IconData icon;
  final List<String> items;
  final void Function(String?)? onChanged;

  const _FilterDropdown({
    required this.label, required this.selectedValue,
    required this.icon, required this.items, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    initialValue: selectedValue,
    dropdownColor: AppColors.bgCard,
    style: AppTextStyles.body,
    icon: Icon(Icons.keyboard_arrow_down_rounded,
      color: AppColors.textMuted),
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    items: items.map((i) => DropdownMenuItem(
      value: i,
      child: Text(i, style: AppTextStyles.body),
    )).toList(),
    onChanged: onChanged,
  );
}