import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Building, CreditCard, Mail, Phone, Eye } from 'lucide-react';
import type { Customer } from '../../types';

const INITIAL_CUSTOMERS: Customer[] = [
  { id: 'CUST-001', name: 'Rajesh Adani', company: 'Adani Power Ltd', email: 'rajesh@adani.com', phone: '+91 98765 43210', totalOrders: 24, totalRevenue: 135000000, outstandingBalance: 45000000, status: 'active' },
  { id: 'CUST-002', name: 'N. Chandrasekaran', company: 'Tata Power Company', email: 'chandra@tata.com', phone: '+91 99887 76655', totalOrders: 18, totalRevenue: 98000000, outstandingBalance: 12000000, status: 'active' },
  { id: 'CUST-003', name: 'Sajjan Jindal', company: 'Jindal Steel & Power', email: 'sajjan@jsw.in', phone: '+91 95555 44444', totalOrders: 15, totalRevenue: 74000000, outstandingBalance: 0, status: 'active' },
  { id: 'CUST-004', name: 'Anil Agarwal', company: 'Vedanta Aluminium', email: 'anil@vedanta.co.in', phone: '+91 91111 22222', totalOrders: 32, totalRevenue: 185000000, outstandingBalance: 56000000, status: 'active' },
  { id: 'CUST-005', name: 'Kumar Birla', company: 'Ultratech Cement', email: 'birla@adityabirla.com', phone: '+91 93333 44444', totalOrders: 20, totalRevenue: 112000000, outstandingBalance: 18000000, status: 'active' },
];

export default function FinanceCustomers() {
  const [customers, setCustomers] = useState<Customer[]>(INITIAL_CUSTOMERS);
  const [search, setSearch] = useState('');
  const [selectedCust, setSelectedCust] = useState<Customer | null>(null);

  const filtered = customers.filter(c =>
    c.name.toLowerCase().includes(search.toLowerCase()) ||
    c.company.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Customer Financial Ledger" subtitle="Review client credit profiles, transaction volumes, and aging receivables accounts." />

      <div className="px-6 grid grid-cols-1 xl:grid-cols-3 gap-6">
        <div className="xl:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex items-center gap-2 bg-gray-50 border border-gray-100 rounded-lg px-3 py-2 max-w-xs mb-5">
            <Search size={16} className="text-gray-400" />
            <input
              type="text"
              placeholder="Search clients..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="bg-transparent text-sm text-gray-700 outline-none w-full placeholder-gray-400"
            />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Client Firm</th>
                  <th className="table-header py-3 px-4">Credit Limit</th>
                  <th className="table-header py-3 px-4">Net Revenue</th>
                  <th className="table-header py-3 px-4">Outstanding Balances</th>
                  <th className="table-header py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(c => (
                  <tr key={c.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell">
                      <span className="font-semibold text-gray-900 block">{c.company}</span>
                      <span className="text-[10px] text-gray-400 block mt-0.5">{c.name}</span>
                    </td>
                    <td className="table-cell font-medium text-gray-700">₹2.00 Cr</td>
                    <td className="table-cell font-medium">₹{(c.totalRevenue / 10000000).toFixed(2)} Cr</td>
                    <td className={`table-cell font-bold ${c.outstandingBalance > 0 ? 'text-red-500 animate-pulse' : 'text-green-600'}`}>
                      {c.outstandingBalance > 0 ? `₹${(c.outstandingBalance / 10000000).toFixed(2)} Cr` : 'Clear'}
                    </td>
                    <td className="table-cell text-right">
                      <button
                        onClick={() => setSelectedCust(c)}
                        className="text-orange-500 hover:text-orange-600 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
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

        {/* Info panel */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
          {selectedCust ? (
            <div className="space-y-5">
              <div className="flex items-center justify-between border-b border-gray-100 pb-4">
                <div>
                  <h3 className="font-bold text-gray-800 text-sm">{selectedCust.company}</h3>
                  <span className="text-[10px] text-gray-400 block mt-0.5">{selectedCust.id}</span>
                </div>
                <span className={`text-[10px] font-bold px-2 py-0.5 rounded ${
                  selectedCust.outstandingBalance > 30000000 ? 'bg-red-50 text-red-700' : 'bg-green-50 text-green-700'
                }`}>
                  {selectedCust.outstandingBalance > 30000000 ? 'Risk Account' : 'Active Account'}
                </span>
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
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Receivables & Balance</span>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <span className="text-[10px] text-gray-400 block">Total Invoiced</span>
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
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Pending Settlement Bills</span>
                <div className="space-y-2">
                  <div className="flex justify-between items-center text-xs py-1.5 px-2 bg-red-50/20 rounded-lg border border-red-50">
                    <span className="font-semibold text-red-800">INV-2026-44</span>
                    <span className="text-gray-400">08 Jun 2026</span>
                    <span className="font-bold text-red-600">₹4.50 L</span>
                  </div>
                  <div className="flex justify-between items-center text-xs py-1.5 px-2 bg-red-50/20 rounded-lg border border-red-50">
                    <span className="font-semibold text-red-800">INV-2026-38</span>
                    <span className="text-gray-400">01 Jun 2026</span>
                    <span className="font-bold text-red-600">₹8.20 L</span>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center text-center py-16 text-gray-400">
              <CreditCard size={40} className="stroke-1 text-gray-300 mb-3" />
              <span className="text-sm font-medium">Select a customer profile to inspect purchase logs and check credit health.</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
