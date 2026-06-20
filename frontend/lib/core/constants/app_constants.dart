class AppConstants {
  // ── Product Types ─────────────────────────────────────────────────
  static const List<String> productTypes = [
    'Indonesian Coal',
    'South African Coal',
    'US Coal',
    'Russian Coal',
  ];

  // ── Quality Options ───────────────────────────────────────────────
  static const List<String> qualityOptions = [
    '3000 GAR',
    '3200 GAR',
    '3400 GAR',
    '3800 GAR',
    '4000 GAR',
    '4200 GAR',
    '4500 GAR',
    '4800 GAR',
    '5000 GAR',
  ];

  // ── Ports ─────────────────────────────────────────────────────────
  static const List<String> ports = [
    'Magdalla',
    'Hazira',
    'Kribhco',
    'Kandla',
    'Navlakhi',
    'Mundra',
    'Tuna',
  ];

  // ── Payment Terms ─────────────────────────────────────────────────
  static const List<String> paymentTerms = [
    'Advance',
    'On Delivery',
    'Credit Line',
    'LC',
  ];

  // ── Sale Types ────────────────────────────────────────────────────
  static const List<String> saleTypes = ['Spot', 'F.O.R.'];

  // ── Order Status Workflow ─────────────────────────────────────────
  static const String statusPendingApproval = 'pending_approval';
  static const String statusRejected        = 'rejected';
  static const String statusApproved        = 'approved';
  static const String statusOnHold          = 'on_hold';
  static const String statusDispatched      = 'dispatched';
  static const String statusCompleted       = 'completed';

  static const List<String> orderStatuses = [
    statusPendingApproval,
    statusRejected,
    statusApproved,
    statusOnHold,
    statusDispatched,
    statusCompleted,
  ];
}

// ── Port Admin user store ─────────────────────────────────────────────────────
class PortAdminUser {
  final String id;
  final String name;
  final String username;
  final List<String> assignedPorts;
  bool isActive;

  PortAdminUser({
    required this.id,
    required this.name,
    required this.username,
    required this.assignedPorts,
    this.isActive = true,
  });
}

class PortAdminStore {
  static final List<PortAdminUser> users = [
    PortAdminUser(
      id: 'pa-001',
      name: 'Vikram Singh',
      username: 'portadmin',
      assignedPorts: ['Mundra', 'Hazira', 'Kandla'],
    ),
    PortAdminUser(
      id: 'pa-002',
      name: 'Anita Desai',
      username: 'anitadesai',
      assignedPorts: ['Magdalla', 'Navlakhi', 'Tuna'],
    ),
  ];

  static PortAdminUser? findByUsername(String username) {
    try {
      return users.firstWhere((u) => u.username == username);
    } catch (_) {
      return null;
    }
  }

  static PortAdminUser? findById(String id) {
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  static Set<String> getActiveAssignedPorts({String? excludeUserId}) {
    final activePorts = <String>{};
    for (final u in users) {
      if (u.isActive && u.id != excludeUserId) {
        activePorts.addAll(u.assignedPorts);
      }
    }
    return activePorts;
  }
}
