import '../core/constants/app_constants.dart';

class StockTransaction {
  final String id;
  final String port;
  final String coalType;
  final double quantity; // positive or negative
  final String type; // 'manual_add' | 'manual_adjust' | 'dispatch_reduction' | 'dispatch_restore'
  final String operator;
  final String date;
  final String time;
  final String remark;

  const StockTransaction({
    required this.id,
    required this.port,
    required this.coalType,
    required this.quantity,
    required this.type,
    required this.operator,
    required this.date,
    required this.time,
    required this.remark,
  });
}

class StockStore {
  StockStore._();

  static const double lowStockThreshold = 1000.0;

  // Port -> Coal Type -> Quantity
  static final Map<String, Map<String, double>> _stock = {
    'Mundra': {
      'Indonesian Coal': 3500.0,
      'South African Coal': 1200.0,
      'US Coal': 400.0,
      'Russian Coal': 2200.0,
    },
    'Hazira': {
      'Indonesian Coal': 1500.0,
      'South African Coal': 2800.0,
      'US Coal': 300.0,
      'Russian Coal': 800.0,
    },
    'Kandla': {
      'Indonesian Coal': 500.0,
      'South African Coal': 1600.0,
      'US Coal': 1500.0,
      'Russian Coal': 600.0,
    },
    'Magdalla': {
      'Indonesian Coal': 2000.0,
      'South African Coal': 900.0,
      'US Coal': 1100.0,
      'Russian Coal': 100.0,
    },
    'Navlakhi': {
      'Indonesian Coal': 4500.0,
      'South African Coal': 300.0,
      'US Coal': 1200.0,
      'Russian Coal': 1800.0,
    },
    'Tuna': {
      'Indonesian Coal': 1200.0,
      'South African Coal': 600.0,
      'US Coal': 800.0,
      'Russian Coal': 1000.0,
    },
    'Kribhco': {
      'Indonesian Coal': 800.0,
      'South African Coal': 1000.0,
      'US Coal': 1400.0,
      'Russian Coal': 500.0,
    },
  };

  static final List<StockTransaction> _transactions = [
    StockTransaction(
      id: 'TXN-1718873400000',
      port: 'Mundra',
      coalType: 'Indonesian Coal',
      quantity: 500.0,
      type: 'manual_add',
      operator: 'Vikram Singh',
      date: '20 Jun 2026',
      time: '14:30',
      remark: 'Stock replenishment from Vessel V-224',
    ),
    StockTransaction(
      id: 'TXN-1718787000000',
      port: 'Hazira',
      coalType: 'South African Coal',
      quantity: -200.0,
      type: 'manual_adjust',
      operator: 'Vikram Singh',
      date: '19 Jun 2026',
      time: '11:15',
      remark: 'Dampness degradation adjustment',
    ),
  ];

  static double getStock(String port, String coalType) {
    return _stock[port]?[coalType] ?? 0.0;
  }

  static Map<String, double> getStockForPort(String port) {
    return _stock[port] != null ? Map.from(_stock[port]!) : {};
  }

  static List<StockTransaction> getTransactions() {
    return List.unmodifiable(_transactions);
  }

  static List<StockTransaction> getTransactionsForPorts(List<String> ports) {
    return _transactions.where((tx) => ports.contains(tx.port)).toList();
  }

  static void addStockManual(String port, String coalType, double qty, String remark, String operator) {
    if (qty <= 0) return;
    _stock.putIfAbsent(port, () => {})[coalType] = (_stock[port]?[coalType] ?? 0.0) + qty;
    final now = DateTime.now();
    _transactions.insert(0, StockTransaction(
      id: 'TXN-${now.millisecondsSinceEpoch}',
      port: port,
      coalType: coalType,
      quantity: qty,
      type: 'manual_add',
      operator: operator,
      date: '${now.day} ${_month(now.month)} ${now.year}',
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      remark: remark,
    ));
  }

  static void adjustStockManual(String port, String coalType, double qty, String remark, String operator) {
    final current = _stock[port]?[coalType] ?? 0.0;
    if (current + qty < 0) {
      throw Exception('Stock cannot become negative');
    }
    _stock.putIfAbsent(port, () => {})[coalType] = current + qty;
    final now = DateTime.now();
    _transactions.insert(0, StockTransaction(
      id: 'TXN-${now.millisecondsSinceEpoch}',
      port: port,
      coalType: coalType,
      quantity: qty,
      type: 'manual_adjust',
      operator: operator,
      date: '${now.day} ${_month(now.month)} ${now.year}',
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      remark: remark,
    ));
  }

  static void reduceStock(String port, String coalType, double qty, {required String remark, required String operator}) {
    final current = _stock[port]?[coalType] ?? 0.0;
    _stock.putIfAbsent(port, () => {})[coalType] = (current - qty).clamp(0, double.infinity);
    final now = DateTime.now();
    _transactions.insert(0, StockTransaction(
      id: 'TXN-${now.millisecondsSinceEpoch}',
      port: port,
      coalType: coalType,
      quantity: -qty,
      type: 'dispatch_reduction',
      operator: operator,
      date: '${now.day} ${_month(now.month)} ${now.year}',
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      remark: remark,
    ));
  }

  static void increaseStock(String port, String coalType, double qty, {required String remark, required String operator}) {
    final current = _stock[port]?[coalType] ?? 0.0;
    _stock.putIfAbsent(port, () => {})[coalType] = current + qty;
    final now = DateTime.now();
    _transactions.insert(0, StockTransaction(
      id: 'TXN-${now.millisecondsSinceEpoch}',
      port: port,
      coalType: coalType,
      quantity: qty,
      type: 'dispatch_restore',
      operator: operator,
      date: '${now.day} ${_month(now.month)} ${now.year}',
      time: '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      remark: remark,
    ));
  }

  static String _month(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];
}
