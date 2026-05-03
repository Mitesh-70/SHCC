import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/shcc_app_bar.dart';
import '../../../shared/widgets/form_section.dart';
import '../../../shared/widgets/amount_summary_card.dart';
import '../../../shared/widgets/loading_overlay.dart';

class CreateOrderScreen extends StatefulWidget {
  final Map<String, dynamic>? prefill;
  final bool isAdmin;

  const CreateOrderScreen({super.key, this.prefill, this.isAdmin = false});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey      = GlobalKey<FormState>();
  final _baseRateCtrl = TextEditingController();
  final _gstCtrl      = TextEditingController(text: '18');
  final _tcsCtrl      = TextEditingController(text: '0.1');
  final _qtyCtrl      = TextEditingController();
  final _buyerCtrl    = TextEditingController();

  String  _typeOfSale   = 'Spot';
  String? _productType;
  String? _quality;
  String? _portName;
  String  _paymentTerms = 'Advance';
  bool    _loading      = false;

  final String _salesPerson = 'Raj Sharma';

  double get _baseRate => double.tryParse(_baseRateCtrl.text) ?? 0;
  double get _gst      => double.tryParse(_gstCtrl.text)      ?? 0;
  double get _tcs      => double.tryParse(_tcsCtrl.text)      ?? 0;
  double get _qty      => double.tryParse(_qtyCtrl.text)      ?? 0;
  bool   get _hasCalc  => _baseRate > 0 && _qty > 0;

  @override
  void initState() {
    super.initState();
    final p = widget.prefill;
    if (p != null) {
      _baseRateCtrl.text = p['base_rate']?.toString()  ?? '';
      _gstCtrl.text      = p['gst']?.toString()        ?? '18';
      _tcsCtrl.text      = p['tcs']?.toString()        ?? '0.1';
      _qtyCtrl.text      = p['quantity']?.toString()   ?? '';
      _buyerCtrl.text    = p['buyer_name']             ?? '';
      _typeOfSale        = p['type_of_sale']            ?? 'Spot';
      _productType       = p['product_type'];
      _quality           = p['quality'];
      _portName          = p['port_name'];
      _paymentTerms      = p['payment_terms']          ?? 'Advance';
    }
    for (final c in [_baseRateCtrl, _gstCtrl, _tcsCtrl, _qtyCtrl]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_baseRateCtrl, _gstCtrl, _tcsCtrl, _qtyCtrl, _buyerCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.prefill != null;

    return Stack(children: [
      Scaffold(
        appBar: ShccAppBar(
          logoAsset: 'assets/images/logo.png',
          showBranding: false,
          title: isEdit ? 'Edit Order' : 'New Sales Order',
          showProfileIcon: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 140),
            children: [

              FormSection(
                title: 'Sales Information',
                icon: Icons.person_outline_rounded,
                children: [
                  _ReadOnlyField(
                    label: 'Sales Person',
                    fieldValue: _salesPerson,
                    icon: Icons.badge_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 28),

              FormSection(
                title: 'Product Details',
                icon: Icons.inventory_2_outlined,
                children: [
                  _AppDropdown<String>(
                    label: 'Product Type (Coal)',
                    icon: Icons.local_fire_department_rounded,
                    selectedValue: _productType,
                    items: AppConstants.productTypes,
                    onChanged: (v) => setState(() => _productType = v),
                    validator: (v) => v == null ? 'Select a product type' : null,
                  ),
                  const SizedBox(height: 14),
                  _AppDropdown<String>(
                    label: 'Quality (GAR)',
                    icon: Icons.grade_outlined,
                    selectedValue: _quality,
                    items: AppConstants.qualityOptions,
                    onChanged: (v) => setState(() => _quality = v),
                    validator: (v) => v == null ? 'Select quality' : null,
                  ),
                  const SizedBox(height: 14),
                  _AppDropdown<String>(
                    label: 'Port Name',
                    icon: Icons.anchor_rounded,
                    selectedValue: _portName,
                    items: AppConstants.ports,
                    onChanged: (v) => setState(() => _portName = v),
                    validator: (v) => v == null ? 'Select a port' : null,
                  ),
                  const SizedBox(height: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Type of Sale',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    Row(children: AppConstants.saleTypes.map((t) =>
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _SelectChip(
                          label: t,
                          selected: _typeOfSale == t,
                          onTap: () => setState(() => _typeOfSale = t),
                          filled: true,
                        ),
                      )).toList(),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 28),

              FormSection(
                title: 'Pricing',
                icon: Icons.currency_rupee_rounded,
                children: [
                  _NumField(
                    ctrl: _baseRateCtrl,
                    label: 'Base Rate (₹ per MT)',
                    icon: Icons.price_change_outlined,
                    hint: 'e.g. 6200',
                    validator: Validators.positiveNumber,
                  ),
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: _NumField(
                      ctrl: _gstCtrl,
                      label: 'GST (%)',
                      icon: Icons.percent_rounded,
                      hint: '18',
                      validator: Validators.required,
                    )),
                    const SizedBox(width: 14),
                    Expanded(child: _NumField(
                      ctrl: _tcsCtrl,
                      label: 'TCS (%)',
                      icon: Icons.account_balance_outlined,
                      hint: '0.1',
                      validator: Validators.required,
                    )),
                  ]),
                  const SizedBox(height: 14),
                  _NumField(
                    ctrl: _qtyCtrl,
                    label: 'Quantity (MT)',
                    icon: Icons.scale_rounded,
                    hint: 'e.g. 200',
                    validator: Validators.positiveNumber,
                    suffix: 'MT',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 280),
                child: _hasCalc
                  ? Padding(
                      key: const ValueKey('on'),
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AmountSummaryCard(
                        baseRate: _baseRate,
                        quantity: _qty,
                        gst: _gst,
                        tcs: _tcs,
                      ),
                    )
                  : const SizedBox(key: ValueKey('off')),
              ),

              FormSection(
                title: 'Buyer Information',
                icon: Icons.business_rounded,
                children: [
                  TextFormField(
                    controller: _buyerCtrl,
                    validator: Validators.required,
                    style: AppTextStyles.body,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Buyer Name / Company',
                      prefixIcon: Icon(Icons.business_outlined,
                        size: 18, color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Payment Terms',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.paymentTerms.map((t) =>
                        _SelectChip(
                          label: t,
                          selected: _paymentTerms == t,
                          onTap: () => setState(() => _paymentTerms = t),
                        )).toList(),
                    ),
                  ]),
                ],
              ),
            ],
          ),
        ),

        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          decoration: const BoxDecoration(
            color: AppColors.bgSurface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                ? const SizedBox(width: 22, height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(isEdit ? Icons.save_rounded : Icons.send_rounded,
                      size: 18),
                    const SizedBox(width: 10),
                    Text(isEdit ? 'Save Changes' : 'Submit Order',
                      style: AppTextStyles.button),
                  ]),
            ),
          ),
        ),
      ),
      if (_loading) const LoadingOverlay(message: 'Submitting order…'),
    ]);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.check_circle_outline,
          color: AppColors.success, size: 18),
        const SizedBox(width: 10),
        Text(widget.prefill != null
          ? 'Order updated' : 'Order submitted. Admin notified.',
          style: AppTextStyles.body),
      ]),
      backgroundColor: AppColors.bgCard,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
    if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _ReadOnlyField extends StatelessWidget {
  final String label, fieldValue;
  final IconData icon;
  const _ReadOnlyField({
    required this.label,
    required this.fieldValue,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.bgInput,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            Text(fieldValue, style: AppTextStyles.bodyMedium),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.bgBase,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('Auto', style: AppTextStyles.caption.copyWith(
            fontSize: 10, color: AppColors.textMuted)),
        ),
      ]),
    );
  }
}

class _AppDropdown<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? selectedValue;
  final List<T> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

  const _AppDropdown({
    required this.label,
    required this.icon,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: selectedValue,
      validator: validator,
      dropdownColor: AppColors.bgCard,
      style: AppTextStyles.body,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
        color: AppColors.textMuted),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
      ),
      items: items.map((i) => DropdownMenuItem<T>(
        value: i,
        child: Text(i.toString(), style: AppTextStyles.body),
      )).toList(),
      onChanged: onChanged,
    );
  }
}

class _NumField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final String? suffix;

  const _NumField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      style: AppTextStyles.body,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 18, color: AppColors.textMuted),
        suffixText: suffix,
        suffixStyle: AppTextStyles.caption.copyWith(
          color: AppColors.textMuted),
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  final String label;
  final bool selected, filled;
  final VoidCallback onTap;

  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: filled ? 20 : 14,
          vertical: filled ? 10 : 8,
        ),
        decoration: BoxDecoration(
          color: selected
            ? (filled ? AppColors.primary : AppColors.primaryMuted)
            : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(label, style: AppTextStyles.caption.copyWith(
          color: selected
            ? (filled ? Colors.white : AppColors.primary)
            : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        )),
      ),
    );
  }
}
