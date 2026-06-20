import '../core/constants/app_constants.dart';
import 'models/order_model.dart';

/// Single source of truth for all in-memory orders across the app.
class OrderStore {
  OrderStore._();

  static final List<Map<String, dynamic>> _orders = [
    {
      'id': 'ORD-2024-048',
      'buyer_name': 'JSW Steel Ltd',
      'sales_person_name': 'Raj Sharma',
      'sales_person_id': 'sp-001',
      'product_type': 'Indonesian Coal',
      'base_rate': 6200.0,
      'freight': 10000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 200.0,
      'type_of_sale': 'Spot',
      'quality': '5000 GAR',
      'port_name': 'Mundra',
      'payment_terms': 'Advance',
      'status': AppConstants.statusDispatched,
      'date': '28 Apr 2024',
      'date_iso': '2024-04-28',
      'remark': 'ASAP Delivery Needed',
      'port_admin_id': 'pa-001',
    },
    {
      'id': 'ORD-2024-047',
      'buyer_name': 'Ultratech Cement',
      'sales_person_name': 'Raj Sharma',
      'sales_person_id': 'sp-001',
      'product_type': 'South African Coal',
      'base_rate': 6100.0,
      'freight': 15000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 150.0,
      'type_of_sale': 'F.O.R.',
      'quality': '4200 GAR',
      'port_name': 'Kandla',
      'payment_terms': 'Credit Line',
      'status': AppConstants.statusRejected,
      'date': '27 Apr 2024',
      'date_iso': '2024-04-27',
      'rejection_comment': 'Quantity too high for this port. Reduce to 100 MT.',
      'remark': 'Urgent requirement',
    },
    {
      'id': 'ORD-2024-046',
      'buyer_name': 'Tata Steel',
      'sales_person_name': 'Amit Patel',
      'sales_person_id': 'sp-002',
      'product_type': 'Russian Coal',
      'base_rate': 5600.0,
      'freight': 20000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 500.0,
      'type_of_sale': 'Spot',
      'quality': '4800 GAR',
      'port_name': 'Hazira',
      'payment_terms': 'On Delivery',
      'status': AppConstants.statusDispatched,
      'date': '26 Apr 2024',
      'date_iso': '2024-04-26',
      'remark': '89012',
      'port_admin_id': 'pa-001',
    },
    {
      'id': 'ORD-2024-045',
      'buyer_name': 'JSW Steel Ltd',
      'sales_person_name': 'Raj Sharma',
      'sales_person_id': 'sp-001',
      'product_type': 'US Coal',
      'base_rate': 3500.0,
      'freight': 5000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 100.0,
      'type_of_sale': 'F.O.R.',
      'quality': '3800 GAR',
      'port_name': 'Magdalla',
      'payment_terms': 'Advance',
      'status': AppConstants.statusPendingApproval,
      'date': '25 Apr 2024',
      'date_iso': '2024-04-25',
      'remark': '',
    },
    {
      'id': 'ORD-2024-044',
      'buyer_name': 'ACC Cement',
      'sales_person_name': 'Priya Mehta',
      'sales_person_id': 'sp-003',
      'product_type': 'Indonesian Coal',
      'base_rate': 8200.0,
      'freight': 25000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 300.0,
      'type_of_sale': 'Spot',
      'quality': '4500 GAR',
      'port_name': 'Navlakhi',
      'payment_terms': 'LC',
      'status': AppConstants.statusCompleted,
      'date': '24 Apr 2024',
      'date_iso': '2024-04-24',
      'remark': 'Order #4423',
    },
    {
      'id': 'ORD-2024-043',
      'buyer_name': 'Essar Steel',
      'sales_person_name': 'Amit Patel',
      'sales_person_id': 'sp-002',
      'product_type': 'South African Coal',
      'base_rate': 7200.0,
      'freight': 16000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 420.0,
      'type_of_sale': 'Spot',
      'quality': '4800 GAR',
      'port_name': 'Hazira',
      'payment_terms': 'LC',
      'status': AppConstants.statusApproved,
      'date': '20 Apr 2024',
      'date_iso': '2024-04-20',
      'port_admin_id': 'pa-001',
    },
    {
      'id': 'ORD-2024-042',
      'buyer_name': 'Birla Cement',
      'sales_person_name': 'Priya Mehta',
      'sales_person_id': 'sp-003',
      'product_type': 'Indonesian Coal',
      'base_rate': 6800.0,
      'freight': 12000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 250.0,
      'type_of_sale': 'Spot',
      'quality': '4000 GAR',
      'port_name': 'Mundra',
      'payment_terms': 'Advance',
      'status': AppConstants.statusCompleted,
      'date': '15 Apr 2024',
      'date_iso': '2024-04-15',
    },
    {
      'id': 'ORD-2024-049',
      'buyer_name': 'Birla Cement',
      'sales_person_name': 'Raj Sharma',
      'sales_person_id': 'sp-001',
      'product_type': 'Indonesian Coal',
      'base_rate': 7100.0,
      'freight': 12000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 300.0,
      'type_of_sale': 'F.O.R.',
      'quality': '4000 GAR',
      'port_name': 'Mundra',
      'payment_terms': 'Advance',
      'status': AppConstants.statusPendingApproval,
      'date': '29 Apr 2024',
      'date_iso': '2024-04-29',
      'time': '10 min ago',
    },
    {
      'id': 'ORD-2024-050',
      'buyer_name': 'Essar Steel',
      'sales_person_name': 'Amit Patel',
      'sales_person_id': 'sp-002',
      'product_type': 'South African Coal',
      'base_rate': 6200.0,
      'freight': 18000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 450.0,
      'type_of_sale': 'Spot',
      'quality': '5000 GAR',
      'port_name': 'Hazira',
      'payment_terms': 'LC',
      'status': AppConstants.statusPendingApproval,
      'date': '29 Apr 2024',
      'date_iso': '2024-04-29',
      'time': '25 min ago',
    },
    {
      'id': 'ORD-2024-051',
      'buyer_name': 'ACC Cement',
      'sales_person_name': 'Priya Mehta',
      'sales_person_id': 'sp-003',
      'product_type': 'Russian Coal',
      'base_rate': 4800.0,
      'freight': 8000.0,
      'gst': 18.0,
      'tcs': 0.1,
      'quantity': 200.0,
      'type_of_sale': 'Spot',
      'quality': '4200 GAR',
      'port_name': 'Kandla',
      'payment_terms': 'On Delivery',
      'status': AppConstants.statusPendingApproval,
      'date': '29 Apr 2024',
      'date_iso': '2024-04-29',
      'time': '1 hr ago',
    },
  ];

  static final Map<String, List<DeliveryEntry>> _dispatchCache = {
    'ORD-2024-048': [
      const DeliveryEntry(id: 'D-001', quantity: 80, date: '20 Apr 2024', port: 'Mundra'),
      const DeliveryEntry(id: 'D-002', quantity: 60, date: '24 Apr 2024', port: 'Mundra'),
    ],
  };

  static List<Map<String, dynamic>> getAllOrders() =>
      List.unmodifiable(_orders);

  static List<Map<String, dynamic>> getOrdersForPort(String port) =>
      _orders.where((o) => o['port_name'] == port).toList();

  static List<Map<String, dynamic>> getOrdersForPorts(List<String> ports) =>
      _orders.where((o) => ports.contains(o['port_name'])).toList();

  static List<Map<String, dynamic>> getOrdersForSalesPerson(String name) =>
      _orders.where((o) => o['sales_person_name'] == name).toList();

  static List<Map<String, dynamic>> getPendingApproval() =>
      _orders.where((o) => o['status'] == AppConstants.statusPendingApproval).toList();

  static Map<String, dynamic>? getOrderById(String id) {
    final idx = _orders.indexWhere((o) => o['id'] == id);
    return idx == -1 ? null : _orders[idx];
  }

  static String _nextOrderId() {
    final nums = _orders
        .map((o) => int.tryParse((o['id'] as String).split('-').last) ?? 0)
        .toList();
    final next = (nums.isEmpty ? 52 : nums.reduce((a, b) => a > b ? a : b) + 1);
    return 'ORD-2024-${next.toString().padLeft(3, '0')}';
  }

  static Map<String, dynamic> addOrder(Map<String, dynamic> order) {
    final id = order['id'] as String? ?? _nextOrderId();
    final now = DateTime.now();
    final entry = {
      ...order,
      'id': id,
      'status': order['status'] ?? AppConstants.statusPendingApproval,
      'date': order['date'] ?? '${now.day} ${_month(now.month)} ${now.year}',
      'date_iso': order['date_iso'] ??
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    };
    _orders.insert(0, entry);
    _dispatchCache[id] = [];
    return entry;
  }

  static void updateOrder(String id, Map<String, dynamic> updates) {
    final idx = _orders.indexWhere((o) => o['id'] == id);
    if (idx != -1) {
      _orders[idx] = {..._orders[idx], ...updates};
    }
  }

  static void updateOrderStatus(String id, String status, {String? comment, String? holdReason}) {
    final updates = <String, dynamic>{'status': status};
    if (comment != null) updates['rejection_comment'] = comment;
    if (holdReason != null) updates['hold_reason'] = holdReason;
    if (status == AppConstants.statusApproved) {
      updates.remove('hold_reason');
    }
    updateOrder(id, updates);
  }

  static List<DeliveryEntry> getDispatchEntries(String orderId) =>
      List.unmodifiable(_dispatchCache[orderId] ??= []);

  static void addDispatchEntry(String orderId, DeliveryEntry entry) {
    _dispatchCache.putIfAbsent(orderId, () => []).add(entry);
    final order = getOrderById(orderId);
    if (order != null && order['status'] == AppConstants.statusApproved) {
      updateOrderStatus(orderId, AppConstants.statusDispatched);
    }
  }

  static void removeDispatchEntry(String orderId, int index) {
    final list = _dispatchCache[orderId];
    if (list != null && index >= 0 && index < list.length) {
      list.removeAt(index);
    }
  }

  static String _month(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];
}
