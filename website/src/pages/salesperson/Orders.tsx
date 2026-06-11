import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Eye, Filter, Check, Clock, Truck } from 'lucide-react';
import type { Order } from '../../types';

const MY_ORDERS: Order[] = [
  { id: 'SHCC-1248', customer: 'Adani Power Ltd', product: 'Indonesian Coal (5500 GAR)', quantity: 2500, unit: 'MT', amount: 13750000, status: 'delivered', date: '2026-06-10' },
  { id: 'SHCC-1247', customer: 'Tata Power Company', product: 'South African Coal (6000 NAR)', quantity: 1800, unit: 'MT', amount: 11700000, status: 'shipped', date: '2026-06-09' },
  { id: 'SHCC-1244', customer: 'Ultratech Cement', product: 'Indonesian Coal (3800 GAR)', quantity: 4500, unit: 'MT', amount: 20250000, status: 'delivered', date: '2026-06-05' },
];

export default function SalespersonOrders() {
  const [search, setSearch] = useState('');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);

  const filtered = MY_ORDERS.filter(o =>
    o.customer.toLowerCase().includes(search.toLowerCase()) ||
    o.id.toLowerCase().includes(search.toLowerCase())
  );

  const getStatusBadge = (status: Order['status']) => {
    switch (status) {
      case 'delivered':
        return <span className="badge-green flex items-center gap-1 w-fit"><Check size={12} /> Delivered</span>;
      case 'shipped':
        return <span className="badge-orange flex items-center gap-1 w-fit"><Truck size={12} /> Shipped</span>;
      default:
        return <span className="bg-yellow-50 text-yellow-700 text-xs font-medium px-2 py-0.5 rounded-full flex items-center gap-1 w-fit"><Clock size={12} /> Pending</span>;
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="My Sales Orders" subtitle="Monitor delivery pipelines, shipments, and status checks of your client bookings." />

      <div className="px-6 grid grid-cols-1 xl:grid-cols-3 gap-6">
        <div className="xl:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex items-center gap-2 bg-gray-50 border border-gray-100 rounded-lg px-3 py-2 max-w-xs mb-5">
            <Search size={16} className="text-gray-400" />
            <input
              type="text"
              placeholder="Search my orders..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="bg-transparent text-sm text-gray-700 outline-none w-full placeholder-gray-400"
            />
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Order ID</th>
                  <th className="table-header py-3 px-4">Customer</th>
                  <th className="table-header py-3 px-4">Coal Specification</th>
                  <th className="table-header py-3 px-4">Volume</th>
                  <th className="table-header py-3 px-4">Status</th>
                  <th className="table-header py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map(o => (
                  <tr key={o.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{o.id}</td>
                    <td className="table-cell">{o.customer}</td>
                    <td className="table-cell text-gray-500">{o.product}</td>
                    <td className="table-cell">{o.quantity.toLocaleString()} MT</td>
                    <td className="table-cell">{getStatusBadge(o.status)}</td>
                    <td className="table-cell text-right">
                      <button
                        onClick={() => setSelectedOrder(o)}
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
          {selectedOrder ? (
            <div className="space-y-6">
              <div className="flex items-center justify-between border-b border-gray-100 pb-4">
                <div>
                  <h3 className="font-bold text-gray-800 text-sm">Order {selectedOrder.id}</h3>
                  <span className="text-[10px] text-gray-400 block mt-0.5">Placed on {selectedOrder.date}</span>
                </div>
                {getStatusBadge(selectedOrder.status)}
              </div>

              <div className="space-y-4">
                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Buyer Client</span>
                  <span className="text-sm font-semibold text-gray-800 block mt-0.5">{selectedOrder.customer}</span>
                </div>

                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Product Specifications</span>
                  <span className="text-sm text-gray-700 block mt-0.5">{selectedOrder.product}</span>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Quantity</span>
                    <span className="text-sm font-bold text-gray-800 block mt-0.5">{selectedOrder.quantity.toLocaleString()} MT</span>
                  </div>
                  <div>
                    <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Value</span>
                    <span className="text-sm font-bold text-orange-600 block mt-0.5">₹{(selectedOrder.amount / 10000000).toFixed(2)} Cr</span>
                  </div>
                </div>
              </div>
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center text-center py-16 text-gray-400">
              <Eye size={40} className="stroke-1 text-gray-300 mb-3" />
              <span className="text-sm font-medium">Select an order shipment to inspect complete booking details.</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
