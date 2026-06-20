import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Filter, Eye, Check, Clock, Truck, XCircle, ShoppingCart, X, MessageSquare, CheckCircle2, Info } from 'lucide-react';
import type { Order, OrderStatus } from '../../types';
import OrderInfoModal from '../../components/ui/OrderInfoModal';

const INITIAL_ORDERS: Order[] = [
  { id: 'SHCC-1248', customer: 'Adani Power Ltd', product: 'Indonesian Coal (5500 GAR)', quantity: 2500, unit: 'MT', amount: 13750000, status: 'delivered', date: '2026-06-10', updatedDate: '2026-06-14', salesperson: 'Rahul Verma', port: 'Mundra Port', baseAmount: 11500000, freight: 875000, gst: 1237500, tcs: 137500, portAdminRemarks: 'Delivered in 3 batches.', dispatchDetails: [{ date: '2026-06-12', quantity: 1000, unit: 'MT', vehicleNo: 'GJ01-AB1234', remark: 'First batch' }, { date: '2026-06-13', quantity: 900, unit: 'MT', vehicleNo: 'GJ01-CD5678', remark: 'Second batch' }, { date: '2026-06-14', quantity: 600, unit: 'MT', vehicleNo: 'GJ02-EF9012', remark: 'Final batch' }] },
  { id: 'SHCC-1247', customer: 'Tata Power Company', product: 'South African Coal (6000 NAR)', quantity: 1800, unit: 'MT', amount: 11700000, status: 'shipped', date: '2026-06-09', updatedDate: '2026-06-12', salesperson: 'Rahul Verma', port: 'Kandla Port', baseAmount: 9800000, freight: 720000, gst: 1052400, tcs: 127600 },
  { id: 'SHCC-1246', customer: 'Jindal Steel & Power', product: 'US Coal (6800 NAR)', quantity: 1200, unit: 'MT', amount: 9600000, status: 'processing', date: '2026-06-08', salesperson: 'Neha Sharma', port: 'Paradip Port', baseAmount: 8100000, freight: 600000, gst: 768000, tcs: 132000 },
  { id: 'SHCC-1245', customer: 'Vedanta Aluminium', product: 'Russian Coal (6000 NAR)', quantity: 3000, unit: 'MT', amount: 19500000, status: 'pending', date: '2026-06-07', salesperson: 'Vikram Singh', port: 'Vizag Port', baseAmount: 16500000, freight: 1200000, gst: 1575000, tcs: 225000 },
  { id: 'SHCC-1244', customer: 'Ultratech Cement', product: 'Indonesian Coal (3800 GAR)', quantity: 4500, unit: 'MT', amount: 20250000, status: 'delivered', date: '2026-06-05', updatedDate: '2026-06-11', salesperson: 'Rahul Verma', port: 'Mundra Port', baseAmount: 17000000, freight: 1575000, gst: 1822500, tcs: 202500 },
  { id: 'SHCC-1243', customer: 'Ambuja Cements', product: 'South African Coal (5500 NAR)', quantity: 1500, unit: 'MT', amount: 9000000, status: 'cancelled', date: '2026-06-03', salesperson: 'Neha Sharma', port: 'Hazira Port', rejectRemark: 'Price negotiation failed. Customer requested revision.', adminRemarks: 'Escalated to accounts team for review.' },
];

export default function AdminOrders() {
  const [orders, setOrders] = useState<Order[]>(INITIAL_ORDERS);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [rejectRemark, setRejectRemark] = useState('');
  const [orderToReject, setOrderToReject] = useState<Order | null>(null);
  const [infoOrder, setInfoOrder] = useState<Order | null>(null);

  const filteredOrders = orders.filter(o => {
    const matchesSearch = o.customer.toLowerCase().includes(search.toLowerCase()) ||
                          o.id.toLowerCase().includes(search.toLowerCase()) ||
                          o.product.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === 'all' || o.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const getStatusBadge = (status: OrderStatus) => {
    switch (status) {
      case 'delivered':
        return <span className="badge-green flex items-center gap-1 w-fit"><Check size={12} /> Delivered</span>;
      case 'shipped':
        return <span className="badge-orange flex items-center gap-1 w-fit"><Truck size={12} /> Shipped</span>;
      case 'processing':
        return <span className="bg-blue-50 text-blue-700 text-xs font-medium px-2 py-0.5 rounded-full flex items-center gap-1 w-fit"><Clock size={12} /> Processing</span>;
      case 'pending':
        return <span className="bg-yellow-50 text-yellow-700 text-xs font-medium px-2 py-0.5 rounded-full flex items-center gap-1 w-fit"><Clock size={12} /> Pending</span>;
      case 'cancelled':
        return <span className="badge-red flex items-center gap-1 w-fit"><XCircle size={12} /> Rejected</span>;
    }
  };

  const updateStatus = (id: string, newStatus: OrderStatus) => {
    setOrders(prev => prev.map(o => o.id === id ? { ...o, status: newStatus } : o));
  };

  const handleAccept = (order: Order) => {
    updateStatus(order.id, 'processing');
  };

  const openRejectModal = (order: Order) => {
    setOrderToReject(order);
    setRejectRemark('');
    setShowRejectModal(true);
  };

  const confirmReject = () => {
    if (!orderToReject) return;
    setOrders(prev => prev.map(o =>
      o.id === orderToReject.id
        ? { ...o, status: 'cancelled', rejectRemark }
        : o
    ));
    setShowRejectModal(false);
    setOrderToReject(null);
    setRejectRemark('');
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Order Management" subtitle="Review, accept or reject salesperson orders with remarks." />

      <div className="px-6">
        {/* Table list */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
            <div className="flex items-center gap-2 bg-gray-50 border border-gray-100 rounded-lg px-3 py-2 w-full md:max-w-xs">
              <Search size={16} className="text-gray-400" />
              <input
                type="text"
                placeholder="Search orders..."
                value={search}
                onChange={e => setSearch(e.target.value)}
                className="bg-transparent text-sm text-gray-700 outline-none w-full placeholder-gray-400"
              />
            </div>
            <div className="flex items-center gap-2">
              <Filter size={14} className="text-gray-400" />
              <select
                value={statusFilter}
                onChange={e => setStatusFilter(e.target.value)}
                className="text-xs bg-gray-50 border border-gray-100 rounded-lg px-2.5 py-2 text-gray-600 outline-none"
              >
                <option value="all">All Statuses</option>
                <option value="pending">Pending</option>
                <option value="processing">Accepted</option>
                <option value="shipped">Shipped</option>
                <option value="delivered">Delivered</option>
                <option value="cancelled">Rejected</option>
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Sr no</th>
                  <th className="table-header py-3 px-4">Order ID</th>
                  <th className="table-header py-3 px-4">Customer</th>
                  <th className="table-header py-3 px-4">Coal Type</th>
                  <th className="table-header py-3 px-4">Quantity</th>
                  <th className="table-header py-3 px-4">Amount</th>
                  <th className="table-header py-3 px-4">Status</th>
                  <th className="table-header py-3 px-4 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {filteredOrders.map((o, idx) => (
                  <tr
                    key={o.id}
                    className="hover:bg-gray-50/50 transition-colors"
                  >
                    <td className="table-cell font-semibold text-gray-900">{idx + 1}</td>
                    <td className="table-cell font-semibold text-gray-900">{o.id}</td>
                    <td className="table-cell">{o.customer}</td>
                    <td className="table-cell">{o.product}</td>
                    <td className="table-cell">{o.quantity.toLocaleString()} {o.unit}</td>
                    <td className="table-cell font-medium">₹{(o.amount / 10000000).toFixed(2)} Cr</td>
                    <td className="table-cell">{getStatusBadge(o.status)}</td>
                    <td className="table-cell text-right">
                      <div className="flex items-center justify-end gap-1.5">
                        {/* Info button — always visible */}
                        <button
                          onClick={() => setInfoOrder(o)}
                          className="p-1.5 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-lg transition-all"
                          title="View Order Details"
                          aria-label={`View details for ${o.id}`}
                        >
                          <Info size={15} />
                        </button>
                        {/* Action buttons — only for pending */}
                        {o.status === 'pending' ? (
                          <>
                            <button
                              onClick={() => openRejectModal(o)}
                              className="flex items-center gap-1.5 px-3 py-1.5 text-red-600 bg-red-50 hover:bg-red-100 rounded-lg text-xs font-semibold transition-colors"
                              title="Reject Order"
                            >
                              <X size={14} /> Reject
                            </button>
                            <button
                              onClick={() => handleAccept(o)}
                              className="flex items-center gap-1.5 px-3 py-1.5 text-green-700 bg-green-50 hover:bg-green-100 rounded-lg text-xs font-bold transition-colors shadow-sm"
                              title="Accept Order"
                            >
                              <Check size={14} /> Accept
                            </button>
                          </>
                        ) : (
                          <span className="text-[10px] text-gray-400 font-medium">No actions</span>
                        )}
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>

      {/* Reject Remarks Modal */}
      {showRejectModal && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden">
            <div className="p-5 border-b border-gray-100 flex items-center justify-between bg-red-50/50">
              <div>
                <h3 className="font-bold text-gray-900 text-base">Reject Order</h3>
                <p className="text-xs text-gray-500 mt-0.5">Order {orderToReject?.id} — {orderToReject?.customer}</p>
              </div>
              <button onClick={() => setShowRejectModal(false)} className="text-gray-400 hover:text-gray-600 p-1 hover:bg-gray-100 rounded-lg">
                <X size={18} />
              </button>
            </div>
            <div className="p-5 space-y-4">
              <div>
                <label className="text-xs font-semibold text-gray-700 block mb-2">
                  Rejection Reason / Remark <span className="text-red-500">*</span>
                </label>
                <textarea
                  rows={4}
                  value={rejectRemark}
                  onChange={e => setRejectRemark(e.target.value)}
                  placeholder="Enter the reason for rejection (visible to salesperson)..."
                  className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-red-200 focus:border-red-400 resize-none transition-all"
                />
                <p className="text-[10px] text-gray-400 mt-1 flex items-center gap-1">
                  <MessageSquare size={10} /> This remark will be visible to the salesperson who placed the order.
                </p>
              </div>
            </div>
            <div className="p-5 border-t border-gray-100 flex justify-end gap-3">
              <button
                onClick={() => setShowRejectModal(false)}
                className="px-4 py-2 border border-gray-200 text-gray-600 rounded-lg text-xs font-semibold hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                onClick={confirmReject}
                disabled={!rejectRemark.trim()}
                className="px-4 py-2 bg-red-500 hover:bg-red-600 disabled:bg-red-300 text-white rounded-lg text-xs font-bold transition-colors flex items-center gap-1.5"
              >
                <X size={13} /> Confirm Rejection
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
