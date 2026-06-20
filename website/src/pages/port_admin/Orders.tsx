import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Eye, DollarSign, Download, Check, AlertCircle } from 'lucide-react';
import type { Order } from '../../types';

const INITIAL_ORDERS: Order[] = [
  { id: 'SHCC-1248', customer: 'Adani Power Ltd', product: 'Indonesian Coal (5500 GAR)', quantity: 2500, unit: 'MT', amount: 13750000, status: 'delivered', date: '2026-06-10' },
  { id: 'SHCC-1247', customer: 'Tata Power Company', product: 'South African Coal (6000 NAR)', quantity: 1800, unit: 'MT', amount: 11700000, status: 'shipped', date: '2026-06-09' },
  { id: 'SHCC-1246', customer: 'Jindal Steel & Power', product: 'US Coal (6800 NAR)', quantity: 1200, unit: 'MT', amount: 9600000, status: 'processing', date: '2026-06-08' },
  { id: 'SHCC-1245', customer: 'Vedanta Aluminium', product: 'Russian Coal (6000 NAR)', quantity: 3000, unit: 'MT', amount: 19500000, status: 'pending', date: '2026-06-07' },
];

export default function PortAdminOrders() {
  const [orders, setOrders] = useState<Order[]>(INITIAL_ORDERS);
  const [search, setSearch] = useState('');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [paymentStatus, setPaymentStatus] = useState<Record<string, 'paid' | 'unpaid'>>({
    'SHCC-1248': 'paid',
    'SHCC-1247': 'unpaid',
    'SHCC-1246': 'unpaid',
    'SHCC-1245': 'unpaid',
  });

  const filtered = orders.filter(o =>
    o.customer.toLowerCase().includes(search.toLowerCase()) ||
    o.id.toLowerCase().includes(search.toLowerCase())
  );

  const confirmPayment = (id: string) => {
    setPaymentStatus(prev => ({ ...prev, [id]: 'paid' }));
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Finance Order Billings & Payments" subtitle="Verify transactions, track customer deposits, and manage invoices." />

      <div className="px-6 grid grid-cols-1 xl:grid-cols-3 gap-6">
        <div className="xl:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
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
                  <th className="table-header py-3 px-4">Sales Order</th>
                  <th className="table-header py-3 px-4">Client</th>
                  <th className="table-header py-3 px-4">Quantity</th>
                  <th className="table-header py-3 px-4">Invoiced Amount</th>
                  <th className="table-header py-3 px-4">Receipt Status</th>
                  <th className="table-header py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(o => (
                  <tr key={o.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{o.id}</td>
                    <td className="table-cell">{o.customer}</td>
                    <td className="table-cell">{o.quantity.toLocaleString()} MT</td>
                    <td className="table-cell font-medium">₹{(o.amount / 10000000).toFixed(2)} Cr</td>
                    <td className="table-cell">
                      <span className={`text-xs font-semibold px-2 py-0.5 rounded-full inline-block ${
                        paymentStatus[o.id] === 'paid' ? 'bg-green-50 text-green-700' : 'bg-red-50 text-red-700 animate-pulse'
                      }`}>
                        {paymentStatus[o.id] === 'paid' ? 'Paid & Audited' : 'Awaiting Settlement'}
                      </span>
                    </td>
                    <td className="table-cell text-right">
                      <button
                        onClick={() => setSelectedOrder(o)}
                        className="text-orange-500 hover:text-orange-600 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
                      >
                        <Eye size={15} className="text-orange-500" />
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Action Panel */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
          {selectedOrder ? (
            <div className="space-y-6">
              <div className="flex items-center justify-between border-b border-gray-100 pb-4">
                <div>
                  <h3 className="font-bold text-gray-800 text-sm">Receipt for {selectedOrder.id}</h3>
                  <span className="text-[10px] text-gray-400 block mt-0.5">Customer Invoice</span>
                </div>
                <button className="p-1.5 border border-gray-200 hover:border-orange-200 text-gray-500 hover:text-orange-600 rounded-lg transition-all">
                  <Download size={13} />
                </button>
              </div>

              <div className="space-y-4">
                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Client</span>
                  <span className="text-sm font-semibold text-gray-800 block mt-0.5">{selectedOrder.customer}</span>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Billing</span>
                    <span className="text-sm font-bold text-orange-600 block mt-0.5">₹{(selectedOrder.amount / 10000000).toFixed(2)} Cr</span>
                  </div>
                  <div>
                    <span className="text-[10px] font-semibold text-gray-400 uppercase block">GST (18%)</span>
                    <span className="text-sm font-medium text-gray-700 block mt-0.5">₹{(selectedOrder.amount * 0.18 / 10000000).toFixed(2)} Cr</span>
                  </div>
                </div>
              </div>

              {paymentStatus[selectedOrder.id] === 'unpaid' ? (
                <div className="border-t border-gray-100 pt-5 space-y-3">
                  <div className="bg-amber-50/50 border border-amber-100 p-3 rounded-lg flex gap-2 text-xs text-amber-700">
                    <AlertCircle size={15} className="flex-shrink-0 mt-0.5" />
                    <span>Payment receipt check pending for this transaction.</span>
                  </div>
                </div>
              ) : (
                <div className="border-t border-gray-100 pt-5">
                  <div className="bg-green-50/50 border border-green-100 p-3 rounded-lg flex gap-2 text-xs text-green-700">
                    <Check size={15} className="flex-shrink-0 mt-0.5" />
                    <span>Invoice payment confirmed and archived in ledger.</span>
                  </div>
                </div>
              )}
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center text-center py-16 text-gray-400">
              <DollarSign size={40} className="stroke-1 text-gray-300 mb-3" />
              <span className="text-sm font-medium">Select a transaction to inspect outstanding credits and verify payments.</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
