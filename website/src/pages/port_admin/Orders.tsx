import { useState } from 'react';
import { Search, Filter, Eye, Truck, PauseCircle, CheckCircle2, Clock } from 'lucide-react';

type OrderStatus = 'approved' | 'on_hold' | 'dispatched' | 'completed';

interface PortOrder {
  id: string;
  customer: string;
  port: string;
  product: string;
  quantity: number;
  status: OrderStatus;
  date: string;
  dispatchedQty: number;
}

const MOCK_ORDERS: PortOrder[] = [
  { id: 'ORD-2241', customer: 'Tata Steel Ltd',       port: 'Mundra',  product: 'Indonesian Coal 5000 GAR', quantity: 5000, status: 'approved',   date: '2026-06-18', dispatchedQty: 0    },
  { id: 'ORD-2238', customer: 'JSW Energy',            port: 'Kandla',  product: 'South African Coal 6000',  quantity: 3000, status: 'on_hold',    date: '2026-06-17', dispatchedQty: 500  },
  { id: 'ORD-2235', customer: 'Adani Power',           port: 'Hazira',  product: 'Indonesian Coal 4200 GAR', quantity: 8000, status: 'dispatched', date: '2026-06-15', dispatchedQty: 4000 },
  { id: 'ORD-2230', customer: 'NTPC Ltd',              port: 'Mundra',  product: 'Indonesian Coal 5000 GAR', quantity: 2500, status: 'approved',   date: '2026-06-14', dispatchedQty: 0    },
  { id: 'ORD-2225', customer: 'Vedanta Resources',     port: 'Kandla',  product: 'South African Coal 5500',  quantity: 4000, status: 'completed',  date: '2026-06-10', dispatchedQty: 4000 },
  { id: 'ORD-2220', customer: 'Hindalco Industries',   port: 'Hazira',  product: 'Indonesian Coal 5000 GAR', quantity: 6000, status: 'dispatched', date: '2026-06-08', dispatchedQty: 3500 },
];

const STATUS_CONFIG: Record<OrderStatus, { label: string; className: string; icon: React.ReactNode }> = {
  approved:   { label: 'Approved',   className: 'bg-green-50 text-green-700 border-green-200',  icon: <CheckCircle2 size={11} /> },
  on_hold:    { label: 'On Hold',    className: 'bg-amber-50 text-amber-700 border-amber-200',  icon: <PauseCircle size={11} /> },
  dispatched: { label: 'Dispatched', className: 'bg-blue-50 text-blue-700 border-blue-200',    icon: <Truck size={11} /> },
  completed:  { label: 'Completed',  className: 'bg-teal-50 text-teal-700 border-teal-200',    icon: <CheckCircle2 size={11} /> },
};

export default function PortAdminOrders() {
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState<'all' | OrderStatus>('all');

  const filtered = MOCK_ORDERS.filter(o => {
    const matchesSearch = (
      o.id.toLowerCase().includes(search.toLowerCase()) ||
      o.customer.toLowerCase().includes(search.toLowerCase()) ||
      o.port.toLowerCase().includes(search.toLowerCase())
    );
    const matchesStatus = statusFilter === 'all' || o.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  return (
    <div className="p-6 space-y-5">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Port Orders</h1>
        <p className="text-sm text-gray-500 mt-0.5">Orders from your assigned ports — Mundra, Kandla, Hazira</p>
      </div>

      {/* Filters */}
      <div className="flex flex-wrap gap-3">
        <div className="flex items-center gap-2 bg-white border border-gray-200 rounded-lg px-3 py-2 flex-1 min-w-[200px]">
          <Search size={14} className="text-gray-400" />
          <input
            type="text"
            placeholder="Search by order, customer or port..."
            value={search}
            onChange={e => setSearch(e.target.value)}
            className="text-sm text-gray-700 outline-none bg-transparent w-full placeholder-gray-400"
          />
        </div>
        <div className="flex items-center gap-2 bg-white border border-gray-200 rounded-lg px-3 py-2">
          <Filter size={14} className="text-gray-400" />
          <select
            value={statusFilter}
            onChange={e => setStatusFilter(e.target.value as typeof statusFilter)}
            className="text-sm text-gray-700 outline-none bg-transparent"
          >
            <option value="all">All Status</option>
            <option value="approved">Approved</option>
            <option value="on_hold">On Hold</option>
            <option value="dispatched">Dispatched</option>
            <option value="completed">Completed</option>
          </select>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white border border-gray-100 rounded-2xl shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-100 bg-gray-50/60">
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Order ID</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Customer</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Port</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Product</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Qty (MT)</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Dispatched</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Status</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Date</th>
                <th className="text-left text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {filtered.length === 0 ? (
                <tr>
                  <td colSpan={9} className="text-center py-12 text-gray-400 text-sm">No orders found.</td>
                </tr>
              ) : (
                filtered.map(order => {
                  const cfg = STATUS_CONFIG[order.status];
                  const pct = order.quantity > 0 ? Math.round((order.dispatchedQty / order.quantity) * 100) : 0;
                  return (
                    <tr key={order.id} className="hover:bg-gray-50/50 transition-colors">
                      <td className="px-4 py-3 font-mono text-xs font-semibold text-gray-700">{order.id}</td>
                      <td className="px-4 py-3 font-medium text-gray-800">{order.customer}</td>
                      <td className="px-4 py-3">
                        <span className="inline-flex items-center gap-1 text-orange-700 bg-orange-50 border border-orange-100 text-xs font-semibold px-2 py-0.5 rounded-full">
                          {order.port}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-gray-600 text-xs">{order.product}</td>
                      <td className="px-4 py-3 text-gray-700 font-semibold">{order.quantity.toLocaleString()}</td>
                      <td className="px-4 py-3">
                        <div className="flex items-center gap-2">
                          <div className="h-1.5 w-16 bg-gray-100 rounded-full overflow-hidden">
                            <div className="h-full bg-orange-500 rounded-full" style={{ width: `${pct}%` }} />
                          </div>
                          <span className="text-xs text-gray-500">{pct}%</span>
                        </div>
                      </td>
                      <td className="px-4 py-3">
                        <span className={`inline-flex items-center gap-1 border text-xs font-semibold px-2 py-0.5 rounded-full ${cfg.className}`}>
                          {cfg.icon}
                          {cfg.label}
                        </span>
                      </td>
                      <td className="px-4 py-3 text-xs text-gray-500">{order.date}</td>
                      <td className="px-4 py-3">
                        <button className="inline-flex items-center gap-1 text-xs text-gray-600 hover:text-orange-600 font-medium transition-colors">
                          <Eye size={13} />
                          View
                        </button>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
