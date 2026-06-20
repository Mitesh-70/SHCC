import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search } from 'lucide-react';
import type { Order } from '../../types';

const INITIAL_ORDERS: Order[] = [
  { id: 'SHCC-1248', customer: 'Adani Power Ltd', product: 'Indonesian Coal (5500 GAR)', quantity: 2500, unit: 'MT', amount: 13750000, status: 'delivered', date: '2026-06-10' },
  { id: 'SHCC-1247', customer: 'Tata Power Company', product: 'South African Coal (6000 NAR)', quantity: 1800, unit: 'MT', amount: 11700000, status: 'shipped', date: '2026-06-09' },
  { id: 'SHCC-1246', customer: 'Jindal Steel & Power', product: 'US Coal (6800 NAR)', quantity: 1200, unit: 'MT', amount: 9600000, status: 'processing', date: '2026-06-08' },
  { id: 'SHCC-1245', customer: 'Vedanta Aluminium', product: 'Russian Coal (6000 NAR)', quantity: 3000, unit: 'MT', amount: 19500000, status: 'pending', date: '2026-06-07' },
];

export default function FinanceOrders() {
  const [orders, setOrders] = useState<Order[]>(INITIAL_ORDERS);
  const [search, setSearch] = useState('');

  const filtered = orders.filter(o =>
    o.customer.toLowerCase().includes(search.toLowerCase()) ||
    o.id.toLowerCase().includes(search.toLowerCase())
  );

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'bg-yellow-50 text-yellow-700 border border-yellow-200';
      case 'processing': return 'bg-blue-50 text-blue-700 border border-blue-200';
      case 'shipped': return 'bg-purple-50 text-purple-700 border border-purple-200';
      case 'delivered': return 'bg-green-50 text-green-700 border border-green-200';
      case 'cancelled': return 'bg-red-50 text-red-700 border border-red-200';
      default: return 'bg-gray-50 text-gray-700';
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Finance Order Billings & Payments" subtitle="Verify transactions, track customer deposits, and manage invoices." />

      <div className="px-6">
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex items-center gap-2 bg-gray-50 border border-gray-100 rounded-lg px-3 py-2 max-w-xs mb-5">
            <Search size={16} className="text-gray-400" />
            <input
              type="text"
              placeholder="Search sales..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="bg-transparent text-sm text-gray-700 outline-none w-full placeholder-gray-400"
            />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Sr no</th>
                  <th className="table-header py-3 px-4">Sales Order</th>
                  <th className="table-header py-3 px-4">Date</th>
                  <th className="table-header py-3 px-4">Client</th>
                  <th className="table-header py-3 px-4">Product</th>
                  <th className="table-header py-3 px-4">Quantity</th>
                  <th className="table-header py-3 px-4">Invoiced Amount</th>
                  <th className="table-header py-3 px-4">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map((o, idx) => (
                  <tr key={o.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{idx + 1}</td>
                    <td className="table-cell font-semibold text-gray-900">{o.id}</td>
                    <td className="table-cell text-gray-500">{o.date}</td>
                    <td className="table-cell">{o.customer}</td>
                    <td className="table-cell">{o.product}</td>
                    <td className="table-cell">{o.quantity.toLocaleString()} MT</td>
                    <td className="table-cell font-medium">₹{(o.amount / 10000000).toFixed(2)} Cr</td>
                    <td className="table-cell">
                      <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded-md ${getStatusColor(o.status)}`}>
                        {o.status}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
