/// Central singleton holding the active user's session context.
class AppSession {
  final String role; // 'admin' | 'port_admin' | 'sales_person'
  final String name;
  final String id;
  final List<String> assignedPorts;

  AppSession._({
    required this.role,
    required this.name,
    required this.id,
    this.assignedPorts = const [],
  });

  static AppSession? _instance;

  static AppSession get instance {
    assert(_instance != null, 'AppSession not initialized — user must log in first');
    return _instance!;
  }

  static bool get isLoggedIn => _instance != null;

  static void setSalesPerson({required String name, required String id}) {
    _instance = AppSession._(role: 'sales_person', name: name, id: id);
  }

  static void setAdmin({required String name, required String id}) {
    _instance = AppSession._(role: 'admin', name: name, id: id);
  }

  static void setPortAdmin({
    required String name,
    required String id,
    required List<String> assignedPorts,
  }) {
    _instance = AppSession._(
      role: 'port_admin',
      name: name,
      id: id,
      assignedPorts: assignedPorts,
    );
  }

  static void clear() => _instance = null;

  bool get isAdmin => role == 'admin';
  bool get isPortAdmin => role == 'port_admin';
  bool get isSalesPerson => role == 'sales_person';

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
