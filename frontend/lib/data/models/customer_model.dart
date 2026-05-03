class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String city;
  final String? gst;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    this.gst,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'],
    name: json['name'],
    phone: json['phone'],
    city: json['city'],
    gst: json['gst'],
  );

  factory CustomerModel.fromMap(Map<String, dynamic> map) => CustomerModel(
    id: map['remote_id'] ?? '',
    name: map['name'],
    phone: map['phone'],
    city: map['city'],
  );
}
