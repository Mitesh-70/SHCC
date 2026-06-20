import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Eye, Download, Check, Truck, Info } from 'lucide-react';
import type { Order } from '../../types';
import OrderInfoModal from '../../components/ui/OrderInfoModal';

const INITIAL_ORDERS: Order[] = [
  { id: 'SHCC-1248', customer: 'Adani Power Ltd', product: 'Indonesian Coal (5500 GAR)', quantity: 2500, unit: 'MT', amount: 13750000, status: 'pending', date: '2026-06-10', salesperson: 'Rahul Verma', port: 'Mundra Port', baseAmount: 11500000, freight: 875000, gst: 1237500, tcs: 137500 },
  { id: 'SHCC-1249', customer: 'Reliance Industries', product: 'South African Coal (6000 NAR)', quantity: 1800, unit: 'MT', amount: 11700000, status: 'cancelled', date: '2026-06-09', salesperson: 'Neha Sharma', port: 'Mundra Port', baseAmount: 9800000, freight: 720000, rejectRemark: 'Vessel berthing slot not available.', portAdminRemarks: 'Rescheduling required.' },
  { id: 'SHCC-1250', customer: 'Tata Power Company', product: 'US Coal (6800 NAR)', quantity: 4500, unit: 'MT', amount: 20250000, status: 'processing', date: '2026-06-09', salesperson: 'Vikram Singh', port: 'Mundra Port', baseAmount: 17000000, freight: 1575000, gst: 1822500, tcs: 202500 },
  { id: 'SHCC-1247', customer: 'JSW Energy', product: 'Russian Coal (6000 NAR)', quantity: 1200, unit: 'MT', amount: 9600000, status: 'pending', date: '2026-06-08', salesperson: 'Rahul Verma', port: 'Mundra Port', baseAmount: 8100000, freight: 600000, gst: 768000, tcs: 132000 },
  { id: 'SHCC-1246', customer: 'Vedanta Aluminium', product: 'Indonesian Coal (4200 GAR)', quantity: 3000, unit: 'MT', amount: 19500000, status: 'shipped', date: '2026-06-07', updatedDate: '2026-06-10', salesperson: 'Vikram Singh', port: 'Mundra Port', baseAmount: 16500000, freight: 1200000, gst: 1575000, tcs: 225000, portAdminRemarks: 'Dispatched via 2 vessels.', dispatchDetails: [{ date: '2026-06-09', quantity: 1500, unit: 'MT', vehicleNo: 'MV-SEABIRD', remark: 'Vessel 1' }, { date: '2026-06-10', quantity: 1500, unit: 'MT', vehicleNo: 'MV-OCEAN-STAR', remark: 'Vessel 2' }] },
  { id: 'SHCC-1245', customer: 'NTPC Ltd', product: 'US Coal (6800 NAR)', quantity: 5000, unit: 'MT', amount: 35000000, status: 'delivered', date: '2026-06-05', updatedDate: '2026-06-09', salesperson: 'Rahul Verma', port: 'Mundra Port', baseAmount: 29500000, freight: 2750000, gst: 3150000, tcs: 350000, portAdminRemarks: 'Completed on schedule.' },
];

export default function PortAdminOrders() {
  const [orders, setOrders] = useState<Order[]>(INITIAL_ORDERS);
  const [search, setSearch] = useState('');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);
  const [infoOrder, setInfoOrder] = useState<Order | null>(null);

  const filtered = orders.filter(o =>
    o.customer.toLowerCase().includes(search.toLowerCase()) ||
    o.id.toLowerCase().includes(search.toLowerCase())
  );

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'Pending Approval': return 'bg-gray-100 text-gray-700';
      case 'Rejected': return 'bg-red-50 text-red-700';
      case 'Approved': return 'bg-blue-50 text-blue-700';
      case 'On Hold': return 'bg-amber-50 text-amber-700';
      case 'Dispatched': return 'bg-purple-50 text-purple-700';
      case 'Completed': return 'bg-green-50 text-green-700';
      default: return 'bg-gray-100 text-gray-700';
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Order Dispatch & Delivery Logging" subtitle="Track orders and log partial coal deliveries for dispatch." />

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
                  <th className="table-header py-3 px-4">Client</th>
                  <th className="table-header py-3 px-4">Quantity</th>
                  <th className="table-header py-3 px-4">Invoiced Amount</th>
                  <th className="table-header py-3 px-4">Status</th>
                  <th className="table-header py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filtered.map((o, idx) => (
                  <tr key={o.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{idx + 1}</td>
                    <td className="table-cell font-semibold text-gray-900">{o.id}</td>
                    <td className="table-cell">{o.customer}</td>
                    <td className="table-cell">{o.quantity.toLocaleString()} MT</td>
                    <td className="table-cell font-medium">₹{(o.amount / 10000000).toFixed(2)} Cr</td>
                    <td className="table-cell">
                      <span className={`text-xs font-semibold px-2 py-0.5 rounded-full inline-block ${getStatusColor(o.status)}`}>
                        {o.status}
                      </span>
                    </td>
                    <td className="table-cell text-right">
                      <div className="flex items-center justify-end gap-1">
                        {/* Info button */}
                        <button
                          onClick={() => setInfoOrder(o)}
                          className="text-gray-400 hover:text-blue-600 hover:bg-blue-50 p-1.5 rounded-lg transition-all"
                          title="View Order Details"
                          aria-label={`View details for ${o.id}`}
                        >
                          <Info size={15} />
                        </button>
                        {/* Dispatch button */}
                        <button
                          onClick={() => setSelectedOrder(o)}
                          className="text-orange-500 hover:text-orange-600 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
                          title="Log Dispatch"
                        >
                          <Eye size={15} className="text-orange-500" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Action Modal */}
      {selectedOrder && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-xl max-w-md w-full border border-gray-100 overflow-hidden transform transition-all">
            <div className="p-6 border-b border-gray-50 flex items-center justify-between bg-gray-50/50">
              <div>
                <h3 className="text-base font-bold text-gray-900">Weight Delivery Logging</h3>
                <p className="text-[10px] text-gray-400 mt-0.5">Order {selectedOrder.id}</p>
              </div>
              <button 
                onClick={() => setSelectedOrder(null)}
                className="text-gray-400 hover:text-gray-600 transition-colors text-sm font-semibold p-1 hover:bg-gray-100 rounded-lg"
              >
                ✕
              </button>
            </div>

            <div className="p-6 space-y-4">
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Client</span>
                <span className="text-sm font-semibold text-gray-800 block mt-0.5">{selectedOrder.customer}</span>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Ordered</span>
                  <span className="text-sm font-bold text-gray-800 block mt-0.5">{selectedOrder.quantity.toLocaleString()} MT</span>
                </div>
                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Product</span>
                  <span className="text-sm font-medium text-gray-700 block mt-0.5">{selectedOrder.product}</span>
                </div>
              </div>

              <div className="border-t border-gray-100 pt-5 space-y-4">
                <div>
                  <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-2">
                    Add Partial Amount (MT)
                  </label>
                  <input 
                    type="number" 
                    placeholder="e.g. 500"
                    className="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500 transition-all shadow-sm"
                  />
                </div>
                
                <button
                  onClick={() => alert(`Successfully added delivery log for ${selectedOrder.id}`)}
                  className="w-full bg-orange-500 hover:bg-orange-600 text-white font-medium py-2 rounded-lg text-sm shadow-sm transition-colors flex items-center justify-center gap-2"
                >
                  <Check size={16} />
                  Add Delivery Log
                </button>
              </div>
            </div>
            <div className="p-6 border-t border-gray-50 bg-gray-50/50 flex justify-end gap-3">
              <button
                onClick={() => setSelectedOrder(null)}
                className="px-4 py-2 border border-gray-200 text-gray-500 rounded-lg text-xs font-semibold hover:bg-gray-100 transition-colors"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
      {/* Order Info Modal */}
      <OrderInfoModal order={infoOrder} onClose={() => setInfoOrder(null)} />
    </div>
  );
}
