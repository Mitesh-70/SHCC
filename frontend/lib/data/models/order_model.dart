class OrderModel {
  final String uuid;
  final String salesPersonName;
  final double baseRate;
  final double gst;
  final double tcs;
  final double quantity;
  final String typeOfSale;
  final String productType;
  final String quality;
  final String portName;
  final String buyerName;
  final String paymentTerms;
  final String syncStatus;
  final String status;        // pending | processed | completed | confirmed
  final String createdAt;
  final String updatedAt;
  final List<DeliveryEntry> deliveries;

  OrderModel({
    required this.uuid,
    required this.salesPersonName,
    required this.baseRate,
    required this.gst,
    required this.tcs,
    required this.quantity,
    required this.typeOfSale,
    required this.productType,
    required this.quality,
    required this.portName,
    required this.buyerName,
    required this.paymentTerms,
    this.syncStatus = 'pending',
    this.status = 'pending',
    required this.createdAt,
    required this.updatedAt,
    this.deliveries = const [],
  });

  // ── Once admin confirms, order is locked ──────────────────────────
  bool get isLocked => status == 'confirmed';

  // ── Computed financials ───────────────────────────────────────────
  double get baseAmount  => baseRate * quantity;
  double get gstAmount   => baseAmount * (gst  / 100);
  double get tcsAmount   => baseAmount * (tcs  / 100);
  double get totalAmount => baseAmount + gstAmount + tcsAmount;

  // ── Delivery tracking ─────────────────────────────────────────────
  double get deliveredQty  => deliveries.fold(0, (s, d) => s + d.quantity);
  double get remainingQty  => quantity - deliveredQty;
  double get deliveryPct   => quantity == 0 ? 0 : (deliveredQty / quantity).clamp(0, 1);

  Map<String, dynamic> toMap() => {
    'uuid':              uuid,
    'sales_person_name': salesPersonName,
    'base_rate':         baseRate,
    'gst':               gst,
    'tcs':               tcs,
    'quantity':          quantity,
    'type_of_sale':      typeOfSale,
    'product_type':      productType,
    'quality':           quality,
    'port_name':         portName,
    'buyer_name':        buyerName,
    'payment_terms':     paymentTerms,
    'sync_status':       syncStatus,
    'status':            status,
    'created_at':        createdAt,
    'updated_at':        updatedAt,
  };

  factory OrderModel.fromMap(Map<String, dynamic> m) => OrderModel(
    uuid:            m['uuid'],
    salesPersonName: m['sales_person_name'],
    baseRate:        (m['base_rate']  as num).toDouble(),
    gst:             (m['gst']        as num).toDouble(),
    tcs:             (m['tcs']        as num).toDouble(),
    quantity:        (m['quantity']   as num).toDouble(),
    typeOfSale:      m['type_of_sale'],
    productType:     m['product_type'] ?? '',
    quality:         m['quality'],
    portName:        m['port_name'],
    buyerName:       m['buyer_name'],
    paymentTerms:    m['payment_terms'],
    syncStatus:      m['sync_status'] ?? 'pending',
    status:          m['status']      ?? 'pending',
    createdAt:       m['created_at'],
    updatedAt:       m['updated_at'],
  );

  OrderModel copyWith({String? status, List<DeliveryEntry>? deliveries}) => OrderModel(
    uuid:            uuid,
    salesPersonName: salesPersonName,
    baseRate:        baseRate,
    gst:             gst,
    tcs:             tcs,
    quantity:        quantity,
    typeOfSale:      typeOfSale,
    productType:     productType,
    quality:         quality,
    portName:        portName,
    buyerName:       buyerName,
    paymentTerms:    paymentTerms,
    syncStatus:      syncStatus,
    status:          status      ?? this.status,
    createdAt:       createdAt,
    updatedAt:       updatedAt,
    deliveries:      deliveries  ?? this.deliveries,
  );
}

// ── Delivery installment ──────────────────────────────────────────────────────
class DeliveryEntry {
  final String id;
  final double quantity;
  final String date;
  final String port;

  const DeliveryEntry({
    required this.id,
    required this.quantity,
    required this.date,
    required this.port,
  });
}
