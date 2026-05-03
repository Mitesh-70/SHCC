class ProductModel {
  final String id;
  final String name;
  final String grade;
  final String gcv;
  final double price;
  final String unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.gcv,
    required this.price,
    required this.unit,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    name: json['name'],
    grade: json['grade'],
    gcv: json['gcv'],
    price: (json['price'] as num).toDouble(),
    unit: json['unit'] ?? 'MT',
  );

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['remote_id'] ?? '',
    name: map['name'],
    grade: map['grade'],
    gcv: map['gcv'],
    price: map['price'],
    unit: map['unit'] ?? 'MT',
  );

  String get displayName => '$name · $grade · GCV $gcv';
}
