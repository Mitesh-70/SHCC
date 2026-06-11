import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Plus, Eye, Phone, Mail, Building } from 'lucide-react';
import type { Customer } from '../../types';

const INITIAL_CUSTOMERS: Customer[] = [
  { id: 'CUST-001', name: 'Rajesh Adani', company: 'Adani Power Ltd', email: 'rajesh@adani.com', phone: '+91 98765 43210', totalOrders: 24, totalRevenue: 135000000, outstandingBalance: 45000000, status: 'active' },
  { id: 'CUST-002', name: 'N. Chandrasekaran', company: 'Tata Power Company', email: 'chandra@tata.com', phone: '+91 99887 76655', totalOrders: 18, totalRevenue: 98000000, outstandingBalance: 12000000, status: 'active' },
  { id: 'CUST-003', name: 'Sajjan Jindal', company: 'Jindal Steel & Power', email: 'sajjan@jsw.in', phone: '+91 95555 44444', totalOrders: 15, totalRevenue: 74000000, outstandingBalance: 0, status: 'active' },
  { id: 'CUST-004', name: 'Anil Agarwal', company: 'Vedanta Aluminium', email: 'anil@vedanta.co.in', phone: '+91 91111 22222', totalOrders: 32, totalRevenue: 185000000, outstandingBalance: 56000000, status: 'active' },
  { id: 'CUST-005', name: 'Kumar Birla', company: 'Ultratech Cement', email: 'birla@adityabirla.com', phone: '+91 93333 44444', totalOrders: 20, totalRevenue: 112000000, outstandingBalance: 18000000, status: 'active' },
];

export default function AdminCustomers() {
  const [customers, setCustomers] = useState<Customer[]>(INITIAL_CUSTOMERS);
  const [search, setSearch] = useState('');
  const [selectedCust, setSelectedCust] = useState<Customer | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState<Partial<Customer>>({});

  const filtered = customers.filter(c =>
    c.name.toLowerCase().includes(search.toLowerCase()) ||
    c.company.toLowerCase().includes(search.toLowerCase())
  );

  const startEdit = (c: Customer) => {
    setEditForm(c);
    setIsEditing(true);
  };

  const saveEdit = (e: React.FormEvent) => {
    e.preventDefault();
    setCustomers(prev => prev.map(c => c.id === editForm.id ? { ...c, ...editForm } as Customer : c));
    if (selectedCust && selectedCust.id === editForm.id) {
      setSelectedCust({ ...selectedCust, ...editForm } as Customer);
    }
    setIsEditing(false);
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Customer Management" subtitle="Oversee corporate buyer accounts, check transaction records, and inspect outstanding credit balances." />

      <div className="px-6 grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Customer List */}
        <div className="xl:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
            <div className="flex items-center gap-2 bg-gray-50 border border-gray-100 rounded-lg px-3 py-2 w-full sm:max-w-xs">
              <Search size={16} className="text-gray-400" />
              <input
                type="text"
                placeholder="Search customers..."
                value={search}
                onChange={e => setSearch(e.target.value)}
                className="bg-transparent text-sm text-gray-700 outline-none w-full placeholder-gray-400"
              />
            </div>
            <button className="btn-primary text-xs flex items-center gap-1.5 py-1.5 px-3">
              <Plus size={14} /> Add Customer
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Company</th>
                  <th className="table-header py-3 px-4">Contact Person</th>
                  <th className="table-header py-3 px-4">Total Orders</th>
                  <th className="table-header py-3 px-4">Revenue Contribution</th>
                  <th className="table-header py-3 px-4">Outstanding Credit</th>
                  <th className="table-header py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(c => (
                  <tr key={c.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell">
                      <span className="font-semibold text-gray-900 block">{c.company}</span>
                      <span className="text-[10px] text-gray-400 block mt-0.5">{c.id}</span>
                    </td>
                    <td className="table-cell">{c.name}</td>
                    <td className="table-cell">{c.totalOrders} Orders</td>
                    <td className="table-cell font-medium">₹{(c.totalRevenue / 10000000).toFixed(2)} Cr</td>
                    <td className={`table-cell font-semibold ${c.outstandingBalance > 0 ? 'text-red-500' : 'text-green-600'}`}>
                      {c.outstandingBalance > 0 ? `₹${(c.outstandingBalance / 10000000).toFixed(2)} Cr` : 'Clear'}
                    </td>
                    <td className="table-cell text-right">
                      <button
                        onClick={() => { setSelectedCust(c); setIsEditing(false); }}
                        className="text-orange-500 hover:text-orange-600 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
                        title="Quick View"
                      >
                        <Eye size={15} />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Info panel / edit form */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
          {selectedCust ? (
            isEditing ? (
              <form onSubmit={saveEdit} className="space-y-4">
                <h3 className="font-bold text-gray-800 text-sm border-b border-gray-100 pb-3 mb-2">Edit Customer Details</h3>
                <div>
                  <label className="text-[10px] font-semibold text-gray-400 block mb-1">Company Name</label>
                  <input
                    type="text"
                    value={editForm.company || ''}
                    onChange={e => setEditForm(prev => ({ ...prev, company: e.target.value }))}
                    className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  />
                </div>
                <div>
                  <label className="text-[10px] font-semibold text-gray-400 block mb-1">Contact Person</label>
                  <input
                    type="text"
                    value={editForm.name || ''}
                    onChange={e => setEditForm(prev => ({ ...prev, name: e.target.value }))}
                    className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  />
                </div>
                <div>
                  <label className="text-[10px] font-semibold text-gray-400 block mb-1">Email</label>
                  <input
                    type="email"
                    value={editForm.email || ''}
                    onChange={e => setEditForm(prev => ({ ...prev, email: e.target.value }))}
                    className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  />
                </div>
                <div>
                  <label className="text-[10px] font-semibold text-gray-400 block mb-1">Phone</label>
                  <input
                    type="text"
                    value={editForm.phone || ''}
                    onChange={e => setEditForm(prev => ({ ...prev, phone: e.target.value }))}
                    className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none"
                  />
                </div>
                <div className="flex gap-2 justify-end pt-2">
                  <button
                    type="button"
                    onClick={() => setIsEditing(false)}
                    className="text-xs font-semibold px-3 py-1.5 rounded-lg border border-gray-200 text-gray-600"
                  >
                    Cancel
                  </button>
                  <button
                    type="submit"
                    className="bg-orange-500 hover:bg-orange-600 text-white text-xs font-semibold px-3 py-1.5 rounded-lg transition-colors"
                  >
                    Save Changes
                  </button>
                </div>
              </form>
            ) : (
              <div className="space-y-5">
                <div className="flex items-center justify-between border-b border-gray-100 pb-4">
                  <div>
                    <h3 className="font-bold text-gray-800 text-sm">{selectedCust.company}</h3>
                    <span className="text-[10px] text-gray-400 block mt-0.5">{selectedCust.id}</span>
                  </div>
                  <button
                    onClick={() => startEdit(selectedCust)}
                    className="text-xs font-semibold text-orange-600 bg-orange-50 px-2.5 py-1 rounded-lg"
                  >
                    Edit Profile
                  </button>
                </div>

                <div className="space-y-3">
                  <div className="flex items-center gap-2 text-xs text-gray-600">
                    <Building size={14} className="text-gray-400" />
                    <span>Contact: {selectedCust.name}</span>
                  </div>
                  <div className="flex items-center gap-2 text-xs text-gray-600">
                    <Mail size={14} className="text-gray-400" />
                    <span>{selectedCust.email}</span>
                  </div>
                  <div className="flex items-center gap-2 text-xs text-gray-600">
                    <Phone size={14} className="text-gray-400" />
                    <span>{selectedCust.phone}</span>
                  </div>
                </div>

                <div className="border-t border-gray-50 pt-4 space-y-3.5">
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Credit & Accounts</span>
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <span className="text-[10px] text-gray-400 block">Total Revenue</span>
                      <span className="text-sm font-bold text-gray-900 block mt-0.5">₹{(selectedCust.totalRevenue / 10000000).toFixed(2)} Cr</span>
                    </div>
                    <div>
                      <span className="text-[10px] text-gray-400 block">Outstanding</span>
                      <span className={`text-sm font-bold block mt-0.5 ${selectedCust.outstandingBalance > 0 ? 'text-red-500' : 'text-green-600'}`}>
                        ₹{(selectedCust.outstandingBalance / 10000000).toFixed(2)} Cr
                      </span>
                    </div>
                  </div>
                </div>

                <div className="border-t border-gray-50 pt-4 space-y-2">
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Recent Invoices</span>
                  <div className="space-y-2">
                    <div className="flex justify-between items-center text-xs py-1.5 px-2 bg-gray-50 rounded-lg">
                      <span className="font-semibold text-gray-700">INV-2026-44</span>
                      <span className="text-gray-400">08 Jun 2026</span>
                      <span className="font-bold text-gray-900">₹4.50 L</span>
                    </div>
                    <div className="flex justify-between items-center text-xs py-1.5 px-2 bg-gray-50 rounded-lg">
                      <span className="font-semibold text-gray-700">INV-2026-38</span>
                      <span className="text-gray-400">01 Jun 2026</span>
                      <span className="font-bold text-gray-900">₹8.20 L</span>
                    </div>
                  </div>
                </div>
              </div>
            )
          ) : (
            <div className="flex flex-col items-center justify-center text-center py-16 text-gray-400">
              <Building size={40} className="stroke-1 text-gray-300 mb-3" />
              <span className="text-sm font-medium">Select a customer profile to inspect purchase logs and contact details.</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
