import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Key, ToggleLeft, ToggleRight, Check, X, Shield, Plus } from 'lucide-react';

const INITIAL_USERS = [
  { id: 'usr-101', name: 'Mitesh Patel', email: 'admin@shcc.co.in', role: 'admin', status: 'active', permissions: ['all'] },
  { id: 'usr-102', name: 'Sanjay Shah', email: 'finance@shcc.co.in', role: 'finance', status: 'active', permissions: ['financial_mgmt', 'sales_analysis', 'stock_analysis', 'reports'] },
  { id: 'usr-103', name: 'Rahul Verma', email: 'salesperson@shcc.co.in', role: 'salesperson', status: 'active', permissions: ['my_orders', 'personal_analytics', 'notifications'] },
  { id: 'usr-104', name: 'Neha Sharma', email: 'neha@shcc.co.in', role: 'salesperson', status: 'active', permissions: ['my_orders', 'personal_analytics'] },
  { id: 'usr-105', name: 'Vikram Singh', email: 'vikram@shcc.co.in', role: 'salesperson', status: 'inactive', permissions: ['my_orders'] },
];

const ACCESS_REQUESTS = [
  { id: 'req-201', name: 'Amit Patel', email: 'amit@shcc.co.in', requestedRole: 'salesperson', date: '2026-06-11 11:20' },
  { id: 'req-202', name: 'Priya Joshi', email: 'priya@shcc.co.in', requestedRole: 'finance', date: '2026-06-10 16:30' },
];

export default function AdminUserPermissions() {
  const [users, setUsers] = useState(INITIAL_USERS);
  const [requests, setRequests] = useState(ACCESS_REQUESTS);
  const [showAddForm, setShowAddForm] = useState(false);
  const [newName, setNewName] = useState('');
  const [newEmail, setNewEmail] = useState('');
  const [newRole, setNewRole] = useState<'admin' | 'finance' | 'salesperson'>('salesperson');

  const toggleStatus = (id: string) => {
    setUsers(prev => prev.map(u => u.id === id ? { ...u, status: u.status === 'active' ? 'inactive' : 'active' } : u));
  };

  const handleApprove = (reqId: string, action: 'approve' | 'reject') => {
    if (action === 'approve') {
      const req = requests.find(r => r.id === reqId);
      if (req) {
        const newUser = {
          id: `usr-${Math.floor(100 + Math.random() * 900)}`,
          name: req.name,
          email: req.email,
          role: req.requestedRole,
          status: 'active',
          permissions: req.requestedRole === 'finance'
            ? ['financial_mgmt', 'sales_analysis', 'stock_analysis', 'reports']
            : ['my_orders', 'personal_analytics']
        };
        setUsers(prev => [...prev, newUser]);
      }
    }
    setRequests(prev => prev.filter(r => r.id !== reqId));
  };

  const handleCreateUser = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName || !newEmail) return;
    const newUser = {
      id: `usr-${Math.floor(100 + Math.random() * 900)}`,
      name: newName,
      email: newEmail,
      role: newRole,
      status: 'active',
      permissions: newRole === 'admin'
        ? ['all']
        : newRole === 'finance'
          ? ['financial_mgmt', 'sales_analysis', 'stock_analysis', 'reports']
          : ['my_orders', 'personal_analytics']
    };
    setUsers(prev => [...prev, newUser]);
    setNewName('');
    setNewEmail('');
    setShowAddForm(false);
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="User & Permission Management" subtitle="Manage accounts, allocate access modules, reset credentials, and oversee sign-up approvals." />

      <div className="px-6 space-y-6">
        {/* Top Split Layout */}
        <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
          {/* User Management List */}
          <div className="xl:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-sm font-bold text-gray-800">Assigned Portal Accounts</h3>
              <button
                onClick={() => setShowAddForm(!showAddForm)}
                className="btn-primary text-xs py-1.5 px-3"
              >
                <Plus size={14} /> Create User Account
              </button>
            </div>

            {showAddForm && (
              <form onSubmit={handleCreateUser} className="mb-6 p-4 border border-orange-100 bg-orange-50/20 rounded-xl space-y-3">
                <span className="text-xs font-bold text-gray-800 block">Add New Team Member</span>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                  <input
                    type="text"
                    required
                    placeholder="Full Name"
                    value={newName}
                    onChange={e => setNewName(e.target.value)}
                    className="text-xs bg-white border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  />
                  <input
                    type="email"
                    required
                    placeholder="Email Address"
                    value={newEmail}
                    onChange={e => setNewEmail(e.target.value)}
                    className="text-xs bg-white border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  />
                  <select
                    value={newRole}
                    onChange={e => setNewRole(e.target.value as any)}
                    className="text-xs bg-white border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  >
                    <option value="admin">Administrator</option>
                    <option value="finance">Finance Manager</option>
                    <option value="salesperson">Salesperson</option>
                  </select>
                </div>
                <div className="flex justify-end gap-2 mt-2">
                  <button
                    type="button"
                    onClick={() => setShowAddForm(false)}
                    className="text-xs font-semibold px-3 py-1.5 rounded-lg border border-gray-200 hover:bg-gray-50 text-gray-600"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="bg-orange-500 hover:bg-orange-600 text-white text-xs font-semibold px-3 py-1.5 rounded-lg transition-colors"
                  >
                    Save Account
                  </button>
                </div>
              </form>
            )}

            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b border-gray-100">
                    <th className="table-header py-3 px-4">User</th>
                    <th className="table-header py-3 px-4">Portal Role</th>
                    <th className="table-header py-3 px-4">Active Modules</th>
                    <th className="table-header py-3 px-4">Status</th>
                    <th className="table-header py-3 px-4 text-right">Actions</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-50">
                  {users.map(u => (
                    <tr key={u.id} className="hover:bg-gray-50/50 transition-colors">
                      <td className="table-cell">
                        <span className="font-semibold text-gray-900 block">{u.name}</span>
                        <span className="text-[10px] text-gray-400 block mt-0.5">{u.email}</span>
                      </td>
                      <td className="table-cell">
                        <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${
                          u.role === 'admin' ? 'bg-orange-50 text-orange-700' : u.role === 'finance' ? 'bg-blue-50 text-blue-700' : 'bg-green-50 text-green-700'
                        }`}>
                          {u.role}
                        </span>
                      </td>
                      <td className="table-cell">
                        <div className="flex flex-wrap gap-1 max-w-[250px]">
                          {u.permissions.map((p, i) => (
                            <span key={i} className="text-[9px] bg-gray-100 text-gray-500 font-semibold px-1.5 py-0.5 rounded uppercase">
                              {p.replace('_', ' ')}
                            </span>
                          ))}
                        </div>
                      </td>
                      <td className="table-cell">
                        <button
                          onClick={() => toggleStatus(u.id)}
                          className={`flex items-center gap-1 text-xs font-semibold ${
                            u.status === 'active' ? 'text-green-600' : 'text-gray-400'
                          }`}
                        >
                          {u.status === 'active' ? <ToggleRight size={20} /> : <ToggleLeft size={20} />}
                          <span className="capitalize">{u.status}</span>
                        </button>
                      </td>
                      <td className="table-cell text-right">
                        <button
                          onClick={() => alert(`Password reset link dispatched to ${u.email}`)}
                          className="text-gray-400 hover:text-orange-500 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
                          title="Reset Password"
                        >
                          <Key size={14} />
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Pending Sign-Ups Approvals */}
          <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
            <h3 className="text-sm font-bold text-gray-800 border-b border-gray-100 pb-3 mb-4">Pending Access Requests</h3>
            {requests.length > 0 ? (
              <div className="space-y-4">
                {requests.map(req => (
                  <div key={req.id} className="p-3 bg-gray-50 rounded-xl border border-gray-100 space-y-2">
                    <div className="flex justify-between items-start">
                      <div>
                        <span className="font-semibold text-xs text-gray-800 block">{req.name}</span>
                        <span className="text-[9px] text-gray-400 block mt-0.5">{req.email}</span>
                      </div>
                      <span className="text-[9px] font-bold uppercase bg-orange-50 text-orange-700 px-1.5 py-0.5 rounded">
                        {req.requestedRole}
                      </span>
                    </div>
                    <div className="flex justify-between items-center text-[10px] text-gray-400">
                      <span>Requested: {req.date}</span>
                      <div className="flex gap-1">
                        <button
                          onClick={() => handleApprove(req.id, 'reject')}
                          className="p-1 border border-red-200 hover:bg-red-50 text-red-600 rounded-lg transition-colors"
                        >
                          <X size={12} />
                        </button>
                        <button
                          onClick={() => handleApprove(req.id, 'approve')}
                          className="p-1 border border-green-200 hover:bg-green-50 text-green-600 rounded-lg transition-colors"
                        >
                          <Check size={12} />
                        </button>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center text-center py-8 text-gray-400">
                <Shield size={32} className="stroke-1 text-gray-300 mb-2" />
                <span className="text-xs">No pending registration approvals.</span>
              </div>
            )}
          </div>
        </div>

        {/* Security Logs activities */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <h3 className="text-sm font-bold text-gray-800 mb-4">Security & Authentication Audit logs</h3>
          <div className="space-y-3 text-xs">
            <div className="flex items-center gap-3 py-1">
              <span className="text-gray-400 font-semibold min-w-[120px]">2026-06-11 15:40</span>
              <span className="bg-green-50 text-green-700 font-bold px-2 py-0.5 rounded text-[10px]">SUCCESS</span>
              <span className="text-gray-700 font-medium">User admin@shcc.co.in authenticated from IP 192.168.1.45</span>
            </div>
            <div className="flex items-center gap-3 py-1">
              <span className="text-gray-400 font-semibold min-w-[120px]">2026-06-11 14:15</span>
              <span className="bg-red-50 text-red-700 font-bold px-2 py-0.5 rounded text-[10px]">FAILED</span>
              <span className="text-gray-700 font-medium">Authentication attempt failed for finance@shcc.co.in (Invalid signature)</span>
            </div>
            <div className="flex items-center gap-3 py-1">
              <span className="text-gray-400 font-semibold min-w-[120px]">2026-06-11 11:32</span>
              <span className="bg-orange-50 text-orange-700 font-bold px-2 py-0.5 rounded text-[10px]">CONFIG</span>
              <span className="text-gray-700 font-medium">Permission node 'reports' assigned to account: Sanjay Shah</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
