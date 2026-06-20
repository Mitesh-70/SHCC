import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Search, Filter, Eye, Check, Clock, Truck, XCircle, ShoppingCart } from 'lucide-react';
import type { Order, OrderStatus } from '../../types';

const INITIAL_ORDERS: Order[] = [
  { id: 'SHCC-1248', customer: 'Adani Power Ltd', product: 'Indonesian Coal (5500 GAR)', quantity: 2500, unit: 'MT', amount: 13750000, status: 'delivered', date: '2026-06-10', salesperson: 'Rahul Verma' },
  { id: 'SHCC-1247', customer: 'Tata Power Company', product: 'South African Coal (6000 NAR)', quantity: 1800, unit: 'MT', amount: 11700000, status: 'shipped', date: '2026-06-09', salesperson: 'Rahul Verma' },
  { id: 'SHCC-1246', customer: 'Jindal Steel & Power', product: 'US Coal (6800 NAR)', quantity: 1200, unit: 'MT', amount: 9600000, status: 'processing', date: '2026-06-08', salesperson: 'Neha Sharma' },
  { id: 'SHCC-1245', customer: 'Vedanta Aluminium', product: 'Russian Coal (6000 NAR)', quantity: 3000, unit: 'MT', amount: 19500000, status: 'pending', date: '2026-06-07', salesperson: 'Vikram Singh' },
  { id: 'SHCC-1244', customer: 'Ultratech Cement', product: 'Indonesian Coal (3800 GAR)', quantity: 4500, unit: 'MT', amount: 20250000, status: 'delivered', date: '2026-06-05', salesperson: 'Rahul Verma' },
  { id: 'SHCC-1243', customer: 'Ambuja Cements', product: 'South African Coal (5500 NAR)', quantity: 1500, unit: 'MT', amount: 9000000, status: 'cancelled', date: '2026-06-03', salesperson: 'Neha Sharma' },
];

export default function AdminOrders() {
  const [orders, setOrders] = useState<Order[]>(INITIAL_ORDERS);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);

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
        return <span className="badge-red flex items-center gap-1 w-fit"><XCircle size={12} /> Cancelled</span>;
    }
  };

  const updateStatus = (id: string, newStatus: OrderStatus) => {
    setOrders(prev => prev.map(o => o.id === id ? { ...o, status: newStatus } : o));
    if (selectedOrder && selectedOrder.id === id) {
      setSelectedOrder(prev => prev ? { ...prev, status: newStatus } : null);
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Order Management" subtitle="Track and manage customer coal shipments and sales orders." />

      <div className="px-6 grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Table list */}
        <div className="xl:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
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
                <option value="processing">Processing</option>
                <option value="shipped">Shipped</option>
                <option value="delivered">Delivered</option>
                <option value="cancelled">Cancelled</option>
              </select>
            </div>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
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
                {filteredOrders.map(o => (
                  <tr
                    key={o.id}
                    onClick={() => setSelectedOrder(o)}
                    className={`transition-colors cursor-pointer ${
                      selectedOrder?.id === o.id
                        ? 'bg-orange-50/50 hover:bg-orange-50/70'
                        : 'hover:bg-gray-50/50'
                    }`}
                  >
                    <td className="table-cell font-semibold text-gray-900">{o.id}</td>
                    <td className="table-cell">{o.customer}</td>
                    <td className="table-cell">{o.product}</td>
                    <td className="table-cell">{o.quantity.toLocaleString()} {o.unit}</td>
                    <td className="table-cell font-medium">₹{(o.amount / 10000000).toFixed(2)} Cr</td>
                    <td className="table-cell">{getStatusBadge(o.status)}</td>
                    <td className="table-cell text-right">
                      <button
                        onClick={(e) => {
                          e.stopPropagation();
                          setSelectedOrder(o);
                        }}
                        className="text-orange-500 hover:text-orange-600 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
                        title="View Details"
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

        {/* Details card */}
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
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Customer</span>
                  <span className="text-sm font-semibold text-gray-800 block mt-0.5">{selectedOrder.customer}</span>
                </div>

                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Product Details</span>
                  <span className="text-sm text-gray-700 block mt-0.5">{selectedOrder.product}</span>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <span className="text-[10px] font-semibold text-gray-400 uppercase block">Volume</span>
                    <span className="text-sm font-bold text-gray-800 block mt-0.5">{selectedOrder.quantity.toLocaleString()} {selectedOrder.unit}</span>
                  </div>
                  <div>
                    <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Value</span>
                    <span className="text-sm font-bold text-orange-600 block mt-0.5">₹{(selectedOrder.amount / 10000000).toFixed(2)} Cr</span>
                  </div>
                </div>

                <div>
                  <span className="text-[10px] font-semibold text-gray-400 uppercase block">Assigned Salesperson</span>
                  <span className="text-sm text-gray-700 block mt-0.5">{selectedOrder.salesperson}</span>
                </div>
              </div>

              <div className="border-t border-gray-100 pt-5 space-y-3">
                <span className="text-xs font-semibold text-gray-800 block">Update Order Lifecycle</span>
                <div className="grid grid-cols-2 gap-2">
                  <button
                    onClick={() => updateStatus(selectedOrder.id, 'processing')}
                    className="flex items-center justify-center gap-1.5 py-2 border border-gray-200 hover:border-orange-200 text-xs font-medium text-gray-700 hover:bg-orange-50/50 rounded-lg transition-all"
                  >
                    <Clock size={12} />
                    Process
                  </button>
                  <button
                    onClick={() => updateStatus(selectedOrder.id, 'shipped')}
                    className="flex items-center justify-center gap-1.5 py-2 border border-gray-200 hover:border-orange-200 text-xs font-medium text-gray-700 hover:bg-orange-50/50 rounded-lg transition-all"
                  >
                    <Truck size={12} />
                    Ship
                  </button>
                  <button
                    onClick={() => updateStatus(selectedOrder.id, 'delivered')}
                    className="flex items-center justify-center gap-1.5 py-2 border border-green-200 hover:border-green-300 text-xs font-medium text-green-700 hover:bg-green-50/50 rounded-lg transition-all col-span-2 mt-1"
                  >
                    <Check size={12} />
                    Mark Delivered
                  </button>
                </div>
              </div>
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center text-center py-16 text-gray-400">
              <ShoppingCart size={40} className="stroke-1 text-gray-300 mb-3" />
              <span className="text-sm font-medium">Select an order to view full lifecycle details and update status.</span>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
