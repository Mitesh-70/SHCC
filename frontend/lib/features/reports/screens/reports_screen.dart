import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/empty_state.dart';

// ── Static sample orders (replace with real data layer) ───────────────────────
const _allOrders = [
  {
    'id': 'ORD-2024-048', 'buyer_name': 'JSW Steel Ltd',
    'sales_person_name': 'Raj Sharma', 'product_type': 'Indonesian Coal',
    'base_rate': 6200.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 200.0,
    'port_name': 'Mundra', 'payment_terms': 'Advance',
    'status': 'confirmed', 'date': '2024-04-28',
  },
  {
    'id': 'ORD-2024-047', 'buyer_name': 'Ultratech Cement',
    'sales_person_name': 'Raj Sharma', 'product_type': 'South African Coal',
    'base_rate': 6100.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 150.0,
    'port_name': 'Kandla', 'payment_terms': 'Credit Line',
    'status': 'pending', 'date': '2024-04-27',
  },
  {
    'id': 'ORD-2024-046', 'buyer_name': 'Tata Steel',
    'sales_person_name': 'Amit Patel', 'product_type': 'Russian Coal',
    'base_rate': 5600.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 500.0,
    'port_name': 'Hazira', 'payment_terms': 'On Delivery',
    'status': 'processed', 'date': '2024-04-26',
  },
  {
    'id': 'ORD-2024-045', 'buyer_name': 'JSW Steel Ltd',
    'sales_person_name': 'Raj Sharma', 'product_type': 'US Coal',
    'base_rate': 3500.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 100.0,
    'port_name': 'Magdalla', 'payment_terms': 'Advance',
    'status': 'pending', 'date': '2024-04-25',
  },
  {
    'id': 'ORD-2024-044', 'buyer_name': 'ACC Cement',
    'sales_person_name': 'Priya Mehta', 'product_type': 'Indonesian Coal',
    'base_rate': 8200.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 300.0,
    'port_name': 'Navlakhi', 'payment_terms': 'LC',
    'status': 'completed', 'date': '2024-04-24',
  },
  {
    'id': 'ORD-2024-043', 'buyer_name': 'Essar Steel',
    'sales_person_name': 'Amit Patel', 'product_type': 'South African Coal',
    'base_rate': 7200.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 420.0,
    'port_name': 'Hazira', 'payment_terms': 'LC',
    'status': 'confirmed', 'date': '2024-04-20',
  },
  {
    'id': 'ORD-2024-042', 'buyer_name': 'Birla Cement',
    'sales_person_name': 'Priya Mehta', 'product_type': 'Indonesian Coal',
    'base_rate': 6800.0, 'gst': 18.0, 'tcs': 0.1, 'quantity': 250.0,
    'port_name': 'Mundra', 'payment_terms': 'Advance',
    'status': 'completed', 'date': '2024-04-15',
  },
];

const _salesPersons = ['All', 'Raj Sharma', 'Amit Patel', 'Priya Mehta'];

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});
  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ── Filter state ───────────────────────────────────────────────────
  DateTime? _fromDate;
  DateTime? _toDate;
  String _salesperson = 'All';
  String _port        = 'All';
  bool   _filtersApplied = false;
  bool   _pdfLoading     = false;

  // ── Filtered orders ────────────────────────────────────────────────
  List<Map<String, dynamic>> get _filtered {
    return _allOrders.where((o) {
      // Date range
      if (_fromDate != null || _toDate != null) {
        final parts = (o['date'] as String).split('-');
        final d = DateTime(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
        if (_fromDate != null && d.isBefore(_fromDate!)) return false;
        if (_toDate   != null && d.isAfter(_toDate!))    return false;
      }
      // Salesperson
      if (_salesperson != 'All' &&
          o['sales_person_name'] != _salesperson) return false;
      // Port
      if (_port != 'All' && o['port_name'] != _port) return false;
      return true;
    }).toList();
  }

  // ── Metrics ────────────────────────────────────────────────────────
  double _total(Map<String, dynamic> o) {
    final b = (o['base_rate'] as num).toDouble()
      * (o['quantity'] as num).toDouble();
    return b + b * ((o['gst'] as num) / 100)
             + b * ((o['tcs'] as num) / 100);
  }

  double get _revenue  => _filtered.fold(0, (s, o) => s + _total(o));
  double get _qty      => _filtered.fold(
    0, (s, o) => s + (o['quantity'] as num).toDouble());
  int    get _pending  => _filtered.where((o) => o['status'] == 'pending').length;
  int    get _completed =>
    _filtered.where((o) => o['status'] == 'completed').length;
  int    get _processed =>
    _filtered.where((o) => o['status'] == 'processed').length;
  int    get _confirmed =>
    _filtered.where((o) => o['status'] == 'confirmed').length;

  String _fmt(double v) {
    if (v >= 10000000) return '₹${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '₹${(v / 100000).toStringAsFixed(2)} L';
    return '₹${v.toStringAsFixed(0)}';
  }

  // Format without ₹ symbol (for metric cards that already show a rupee icon)
  String _fmtNoSymbol(double v) {
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(2)} Cr';
    if (v >= 100000)   return '${(v / 100000).toStringAsFixed(2)} L';
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
            _pdfRow(['Confirmed',     '$_confirmed']),
            _pdfRow(['Completed',     '$_completed']),
            _pdfRow(['Processed',     '$_processed']),
            _pdfRow(['Pending',       '$_pending']),
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
    return showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.primary)),
        child: child!,
      ),
    );
  }

  void _applyFilters() {
    if (_fromDate != null && _toDate != null &&
        _fromDate!.isAfter(_toDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('From date cannot be after To date'),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    setState(() => _filtersApplied = true);
  }

  void _clearFilters() => setState(() {
    _fromDate = null; _toDate = null;
    _salesperson = 'All'; _port = 'All';
    _filtersApplied = false;
  });

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: ShccAppBar(
        logoAsset: 'assets/images/logo.png',
        userInitials: 'AD',
        onProfileTap: () {},
        actions: [
          if (_pdfLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.primary))),
            )
          else
            IconButton(
              tooltip: 'Download PDF',
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.picture_as_pdf_rounded,
                  color: AppColors.primary, size: 20),
              ),
              onPressed: filtered.isEmpty ? null : _downloadPdf,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        children: [

          // ── Header ───────────────────────────────────────────────
          Text('Sales Reports', style: AppTextStyles.heading1),
          const SizedBox(height: 4),
          Text('Filter, analyse and export order data',
            style: AppTextStyles.bodySecondary),
          const SizedBox(height: 24),

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
                  if (_filtersApplied)
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
                  items: _salesPersons,
                  onChanged: (v) => setState(() => _salesperson = v ?? 'All'),
                ),
                const SizedBox(height: 12),

                // Port dropdown
                _FilterDropdown(
                  label: 'Port',
                  icon: Icons.anchor_rounded,
                  selectedValue: _port,
                  items: ['All', ...AppConstants.ports],
                  onChanged: (v) => setState(() => _port = v ?? 'All'),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search_rounded, size: 16),
                    label: const Text('Apply Filters'),
                    onPressed: _applyFilters,
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
                label: 'Pending',
                value: '$_pending',
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
                _StatusRow('Confirmed', _confirmed,
                  filtered.length, const Color(0xFF9B59B6)),
                const SizedBox(height: 8),
                _StatusRow('Completed', _completed,
                  filtered.length, AppColors.success),
                const SizedBox(height: 8),
                _StatusRow('Processed', _processed,
                  filtered.length, AppColors.info),
                const SizedBox(height: 8),
                _StatusRow('Pending', _pending,
                  filtered.length, AppColors.warning),
              ],
            ),
          ),
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
    final dateParts = (order['date'] as String).split('-');
    final displayDate =
      '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';

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
          
          // Salesperson, Port & Date Row with Icons
          Wrap(
            spacing: 12,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(order['sales_person_name'] as String, style: AppTextStyles.bodySecondary),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.anchor_rounded, size: 16, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(order['port_name'] as String, style: AppTextStyles.bodySecondary),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(displayDate, style: AppTextStyles.bodySecondary),
                ],
              ),
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

class _InvBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;
  const _InvBtn({
    required this.icon, required this.label,
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
  final void Function(String?) onChanged;

  const _FilterDropdown({
    required this.label, required this.selectedValue,
    required this.icon, required this.items, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    value: selectedValue,
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
