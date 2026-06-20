import { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import {
  FileText, Download, Anchor, Clock, Truck,
  PauseCircle, CheckCircle2, ChevronRight, Calendar, Search, Weight
} from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';

// ─── Detailed Mock Data by Port ──────────────────────────────────────────────

const PORT_REPORTS_DATA: Record<string, any> = {
  Mundra: {
    totalOrders: 10,
    assignedQty: '42,500 MT',
    dispatchedQty: '32,100 MT',
    pendingQty: '10,400 MT',
    avgQty: '4,250 MT',
    orders: [
      { id: 'ORD-2241', customer: 'Tata Steel Ltd', product: 'Indonesian Coal 5000 GAR', qty: 5000, status: 'completed' },
      { id: 'ORD-2230', customer: 'NTPC Ltd', product: 'Indonesian Coal 5000 GAR', qty: 2500, status: 'completed' },
      { id: 'ORD-2212', customer: 'Adani Power', product: 'South African Coal 6000', qty: 6000, status: 'completed' },
      { id: 'ORD-2208', customer: 'JSW Energy', product: 'US Coal 6800 NAR', qty: 4500, status: 'completed' },
      { id: 'ORD-2195', customer: 'Vedanta Resources', product: 'Indonesian Coal 4200 GAR', qty: 8000, status: 'completed' },
      { id: 'ORD-2182', customer: 'Tata Steel Ltd', product: 'South African Coal 5500', qty: 4000, status: 'pending' },
      { id: 'ORD-2170', customer: 'NTPC Ltd', product: 'Indonesian Coal 5000 GAR', qty: 5000, status: 'pending' },
      { id: 'ORD-2165', customer: 'JSW Energy', product: 'Russian Coal 6000 NAR', qty: 3000, status: 'on_hold' },
      { id: 'ORD-2150', customer: 'Ultratech Cement', product: 'US Coal 6800 NAR', qty: 2500, status: 'completed' },
      { id: 'ORD-2144', customer: 'Vedanta Resources', product: 'Indonesian Coal 5000 GAR', qty: 2000, status: 'completed' },
    ],
    chartData: [
      { month: 'Jan', qty: 4500 },
      { month: 'Feb', qty: 5200 },
      { month: 'Mar', qty: 4900 },
      { month: 'Apr', qty: 6000 },
      { month: 'May', qty: 5800 },
      { month: 'Jun', qty: 5700 },
      { month: 'Jul', qty: 6200 },
      { month: 'Aug', qty: 6500 },
      { month: 'Sep', qty: 5900 },
      { month: 'Oct', qty: 6100 },
      { month: 'Nov', qty: 6300 },
      { month: 'Dec', qty: 6800 },
    ]
  },
  Kandla: {
    totalOrders: 8,
    assignedQty: '28,100 MT',
    dispatchedQty: '18,400 MT',
    pendingQty: '9,700 MT',
    avgQty: '3,512 MT',
    orders: [
      { id: 'ORD-2238', customer: 'JSW Energy', product: 'South African Coal 6000', qty: 3000, status: 'on_hold' },
      { id: 'ORD-2225', customer: 'Vedanta Resources', product: 'South African Coal 5500', qty: 4000, status: 'completed' },
      { id: 'ORD-2210', customer: 'Tata Steel Ltd', product: 'Russian Coal 6000 NAR', qty: 4500, status: 'completed' },
      { id: 'ORD-2201', customer: 'Adani Power', product: 'Indonesian Coal 4200 GAR', qty: 3500, status: 'completed' },
      { id: 'ORD-2188', customer: 'NTPC Ltd', product: 'US Coal 6800 NAR', qty: 5000, status: 'completed' },
      { id: 'ORD-2175', customer: 'Ultratech Cement', product: 'South African Coal 6000', qty: 3000, status: 'pending' },
      { id: 'ORD-2160', customer: 'JSW Energy', product: 'Indonesian Coal 5000 GAR', qty: 2500, status: 'pending' },
      { id: 'ORD-2148', customer: 'Tata Steel Ltd', product: 'Russian Coal 6000 NAR', qty: 2600, status: 'completed' },
    ],
    chartData: [
      { month: 'Jan', qty: 2800 },
      { month: 'Feb', qty: 3200 },
      { month: 'Mar', qty: 2900 },
      { month: 'Apr', qty: 3500 },
      { month: 'May', qty: 3100 },
      { month: 'Jun', qty: 2900 },
      { month: 'Jul', qty: 3300 },
      { month: 'Aug', qty: 3400 },
      { month: 'Sep', qty: 3000 },
      { month: 'Oct', qty: 3200 },
      { month: 'Nov', qty: 3100 },
      { month: 'Dec', qty: 3600 },
    ]
  },
  Hazira: {
    totalOrders: 6,
    assignedQty: '14,820 MT',
    dispatchedQty: '9,145 MT',
    pendingQty: '5,675 MT',
    avgQty: '2,470 MT',
    orders: [
      { id: 'ORD-2235', customer: 'Adani Power', product: 'Indonesian Coal 4200 GAR', qty: 8000, status: 'completed' },
      { id: 'ORD-2218', customer: 'Ultratech Cement', product: 'US Coal 6800 NAR', qty: 2000, status: 'completed' },
      { id: 'ORD-2204', customer: 'JSW Energy', product: 'South African Coal 6000', qty: 1500, status: 'completed' },
      { id: 'ORD-2190', customer: 'Tata Steel Ltd', product: 'Russian Coal 6000 NAR', qty: 1200, status: 'pending' },
      { id: 'ORD-2178', customer: 'NTPC Ltd', product: 'Indonesian Coal 5000 GAR', qty: 1120, status: 'pending' },
      { id: 'ORD-2162', customer: 'Adani Power', product: 'South African Coal 5500', qty: 1000, status: 'pending' },
    ],
    chartData: [
      { month: 'Jan', qty: 1200 },
      { month: 'Feb', qty: 1500 },
      { month: 'Mar', qty: 1400 },
      { month: 'Apr', qty: 1800 },
      { month: 'May', qty: 1600 },
      { month: 'Jun', qty: 1645 },
      { month: 'Jul', qty: 1700 },
      { month: 'Aug', qty: 1900 },
      { month: 'Sep', qty: 1750 },
      { month: 'Oct', qty: 1850 },
      { month: 'Nov', qty: 1900 },
      { month: 'Dec', qty: 2100 },
    ]
  }
};

const STATUS_STYLES: Record<string, { label: string; cls: string }> = {
  completed: { label: 'Completed', cls: 'bg-green-50 text-green-700 border-green-200' },
  pending: { label: 'Pending', cls: 'bg-gray-100 text-gray-600 border-gray-200' },
  on_hold: { label: 'On Hold', cls: 'bg-amber-50 text-amber-700 border-amber-200' },
};

const ASSIGNED_PORTS = ['Mundra', 'Kandla', 'Hazira'];

export default function PortAdminReports() {
  const { user } = useAuth();
  const [selectedPort, setSelectedPort] = useState<string>('Mundra');
  const [portsData, setPortsData] = useState<Record<string, any>>(PORT_REPORTS_DATA);
  const [selectedOrder, setSelectedOrder] = useState<any | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  const data = portsData[selectedPort];

  const markAsCompleted = (orderId: string) => {
    setPortsData(prev => {
      const updatedPortData = { ...prev[selectedPort] };
      updatedPortData.orders = updatedPortData.orders.map((o: any) => {
        if (o.id === orderId) {
          return { ...o, status: 'completed' };
        }
        return o;
      });

      // Recalculate metrics
      let dispatchedSum = 0;
      let pendingSum = 0;
      updatedPortData.orders.forEach((o: any) => {
        if (o.status === 'completed') {
          dispatchedSum += o.qty;
        } else {
          pendingSum += o.qty;
        }
      });
      updatedPortData.dispatchedQty = dispatchedSum.toLocaleString() + " MT";
      updatedPortData.pendingQty = pendingSum.toLocaleString() + " MT";

      return {
        ...prev,
        [selectedPort]: updatedPortData
      };
    });

    setSelectedOrder(selectedOrder ? { ...selectedOrder, status: 'completed' } : null);
  };

  const handleDownload = (format: 'csv' | 'excel' | 'pdf') => {
    // Generate CSV content
    const csvContent = [
      ["SHCC Port Operations Report"],
      ["Port Name", selectedPort],
      ["Generated By", user?.name ?? "Port Admin"],
      ["Generated At", new Date().toLocaleString()],
      [],
      ["PORT SUMMARY METRICS"],
      ["Total Orders", data.totalOrders],
      ["Total Assigned Quantity", data.assignedQty],
      ["Total Dispatched Quantity", data.dispatchedQty],
      ["Total Pending Quantity", data.pendingQty],
      ["Average Order Quantity", data.avgQty],
      [],
      ["RECENT TRANSACTIONS & SHIPPINGS"],
      ["Order ID", "Customer", "Product Type", "Quantity (MT)", "Status"],
      ...data.orders.map((o: any) => [o.id, o.customer, o.product, o.qty, o.status.toUpperCase()])
    ]
      .map(row => row.map((val: any) => `"${String(val).replace(/"/g, '""')}"`).join(","))
      .join("\n");

    const blob = new Blob([csvContent], { type: format === 'csv' ? 'text/csv;charset=utf-8;' : 'text/plain;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.setAttribute("href", url);
    const ext = format === 'excel' ? 'xlsx' : format === 'pdf' ? 'pdf' : 'csv';
    link.setAttribute("download", `SHCC_${selectedPort}_Report_${new Date().toISOString().split('T')[0]}.${ext}`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div className="p-6 space-y-6 bg-[#f8fafc] min-h-screen">

      {/* ── Header ── */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Port Reports</h1>
          <p className="text-sm text-gray-500 mt-1">
            Analyze dispatch records and download reports for your assigned ports.
          </p>
        </div>
      </div>

      {/* ── Port Selector & Downloads ── */}
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div className="flex bg-white p-1 rounded-xl border border-gray-100 shadow-sm w-full max-w-[350px]">
          {ASSIGNED_PORTS.map(port => {
            const isActive = selectedPort === port;
            return (
              <button
                key={port}
                onClick={() => setSelectedPort(port)}
                className={`flex-1 flex items-center justify-center gap-2 py-1.5 text-sm font-semibold rounded-lg transition-all ${isActive
                    ? 'bg-orange-500 text-white shadow-sm'
                    : 'text-gray-500 hover:text-gray-900 hover:bg-gray-50'
                  }`}
              >
                <Anchor size={14} />
                {port}
              </button>
            );
          })}
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={() => handleDownload('csv')}
            className="flex items-center justify-center gap-1.5 bg-white text-gray-500 border border-gray-200 px-3 py-1.5 rounded-lg text-sm font-semibold hover:text-gray-900 hover:bg-gray-50 transition-colors shadow-sm"
          >
            <Download size={14} /> CSV
          </button>
          <button
            onClick={() => handleDownload('excel')}
            className="flex items-center justify-center gap-1.5 bg-white text-gray-500 border border-gray-200 px-3 py-1.5 rounded-lg text-sm font-semibold hover:text-gray-900 hover:bg-gray-50 transition-colors shadow-sm"
          >
            <Download size={14} /> Excel
          </button>
          <button
            onClick={() => handleDownload('pdf')}
            className="flex items-center justify-center gap-1.5 bg-white text-gray-500 border border-gray-200 px-3 py-1.5 rounded-lg text-sm font-semibold hover:text-gray-900 hover:bg-gray-50 transition-colors shadow-sm"
          >
            <Download size={14} /> PDF
          </button>
        </div>
      </div>

      {/* ── Summary Stats cards ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">

        <div className="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm flex items-center gap-6">
          <div className="flex items-center justify-center flex-shrink-0 text-orange-500 scale-[1.8] ml-2">
            <FileText size={20} />
          </div>
          <div>
            <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Total Port Orders</div>
            <div className="text-2xl font-bold text-gray-900">{data.totalOrders}</div>
            <div className="text-xs text-gray-400 mt-1">Active shippings logs</div>
          </div>
        </div>

        <div className="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm flex items-center gap-6">
          <div className="flex items-center justify-center flex-shrink-0 text-orange-500 scale-[1.8] ml-2">
            <Weight size={20} />
          </div>
          <div>
            <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Total Assigned Qty</div>
            <div className="text-2xl font-bold text-gray-900">{data.assignedQty}</div>
            <div className="text-xs text-gray-400 mt-1">Allocated cargo weight</div>
          </div>
        </div>

        <div className="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm flex items-center gap-6">
          <div className="flex items-center justify-center flex-shrink-0 text-green-600 scale-[1.8] ml-2">
            <Truck size={20} />
          </div>
          <div>
            <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Dispatched Quantity</div>
            <div className="text-2xl font-bold text-gray-900 text-green-600">{data.dispatchedQty}</div>
            <div className="text-xs text-gray-400 mt-1">Already shipped out</div>
          </div>
        </div>

        <div className="bg-white border border-gray-100 rounded-2xl p-6 shadow-sm flex items-center gap-6">
          <div className="flex items-center justify-center flex-shrink-0 text-blue-500 scale-[1.8] ml-2">
            <Clock size={20} />
          </div>
          <div>
            <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Pending Quantity</div>
            <div className="text-2xl font-bold text-gray-900 text-blue-500">{data.pendingQty}</div>
            <div className="text-xs text-gray-400 mt-1">Awaiting dispatch</div>
          </div>
        </div>

      </div>

      {/* ── Monthly Trend Chart ── */}
      <div className="bg-white border border-gray-100 rounded-2xl p-5 shadow-sm flex flex-col gap-4">
        <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2">
          <Calendar size={14} className="text-orange-500" />
          Monthly Dispatch Trend
        </h3>
        <div className="w-full h-[260px]">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={data.chartData} margin={{ top: 5, right: 10, left: -25, bottom: 5 }}>
              <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
              <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#1e293b' }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 11, fill: '#1e293b' }} axisLine={false} tickLine={false} />
              <Tooltip formatter={(value) => [`${value} MT`, 'Dispatched']} />
              <Bar dataKey="qty" fill="#f97316" radius={[4, 4, 0, 0]} barSize={48} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* ── Transactions Table ── */}
      <div className="bg-white border border-gray-100 rounded-2xl p-5 shadow-sm flex flex-col gap-4 overflow-hidden">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2">
            <span>Recent Dispatches Log</span>
            <span className="text-xs text-gray-400 font-normal border-l pl-2 border-gray-200">{selectedPort} Port Only</span>
          </h3>
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={14} />
            <input
              type="text"
              placeholder="Search ID, Customer, Product..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-9 pr-4 py-2 border border-gray-200 rounded-lg text-xs w-full sm:w-64 focus:outline-none focus:ring-2 focus:ring-orange-500/20 focus:border-orange-500 transition-all shadow-sm"
            />
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-gray-100 text-xs font-semibold text-gray-400 uppercase">
                <th className="py-3 px-3">Order ID</th>
                <th className="py-3 px-3">Customer</th>
                <th className="py-3 px-3">Product</th>
                <th className="py-3 px-3 text-right">Quantity</th>
                <th className="py-3 px-3 text-center">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50 text-xs">
              {data.orders
                .filter((o: any) => {
                  if (!searchTerm) return true;
                  const lower = searchTerm.toLowerCase();
                  return o.id.toLowerCase().includes(lower) || 
                         o.customer.toLowerCase().includes(lower) || 
                         o.product.toLowerCase().includes(lower);
                })
                .sort((a: any, b: any) => {
                  const getPriority = (status: string) => {
                    if (status === 'pending') return 1;
                    if (status === 'on_hold') return 2;
                    if (status === 'completed') return 3;
                    return 4;
                  };
                  return getPriority(a.status) - getPriority(b.status);
                })
                .map((o: any) => {
                const style = STATUS_STYLES[o.status] || STATUS_STYLES.pending;
                return (
                  <tr 
                    key={o.id} 
                    onClick={() => setSelectedOrder(o)}
                    className="hover:bg-orange-50/20 transition-colors cursor-pointer"
                  >
                    <td className="py-3 px-3 font-semibold text-gray-900">{o.id}</td>
                    <td className="py-3 px-3 text-gray-700">{o.customer}</td>
                    <td className="py-3 px-3 text-gray-500">{o.product}</td>
                    <td className="py-3 px-3 text-right font-medium text-gray-800">{o.qty.toLocaleString()} MT</td>
                    <td className="py-3 px-3 text-center">
                      <span className={`inline-flex px-2 py-0.5 rounded-full border text-[10px] font-semibold capitalize ${style.cls}`}>
                        {style.label}
                      </span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

      {/* ── Order Details Modal ── */}
      {selectedOrder && (
        <div className="fixed inset-0 bg-slate-900/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-xl max-w-md w-full border border-gray-100 overflow-hidden transform transition-all">
            {/* Modal Header */}
            <div className="p-6 border-b border-gray-50 flex items-center justify-between bg-gray-50/50">
              <div>
                <h3 className="text-base font-bold text-gray-900">Order {selectedOrder.id} Details</h3>
                <p className="text-[10px] text-gray-400 mt-0.5">Port Operations Log</p>
              </div>
              <button 
                onClick={() => setSelectedOrder(null)}
                className="text-gray-400 hover:text-gray-600 transition-colors text-sm font-semibold p-1 hover:bg-gray-100 rounded-lg"
              >
                ✕
              </button>
            </div>

            {/* Modal Body */}
            <div className="p-6 space-y-4">
              <div className="grid grid-cols-2 gap-4 text-xs">
                <div className="col-span-2">
                  <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block">Customer</span>
                  <span className="text-gray-700 font-semibold text-sm mt-0.5 block">{selectedOrder.customer}</span>
                </div>
                <div className="col-span-2">
                  <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block">Product</span>
                  <span className="text-gray-700 font-semibold text-sm mt-0.5 block">{selectedOrder.product}</span>
                </div>
                <div>
                  <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block">Cargo Quantity</span>
                  <span className="text-gray-700 font-bold text-sm mt-0.5 block">{selectedOrder.qty.toLocaleString()} MT</span>
                </div>
                <div>
                  <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block">Status</span>
                  <span className="mt-1 block">
                    <span className={`inline-flex px-2 py-0.5 rounded-full border text-[10px] font-semibold capitalize ${
                      STATUS_STYLES[selectedOrder.status]?.cls || STATUS_STYLES.pending.cls
                    }`}>
                      {STATUS_STYLES[selectedOrder.status]?.label || selectedOrder.status}
                    </span>
                  </span>
                </div>
              </div>
            </div>

            {/* Modal Footer */}
            <div className="p-6 border-t border-gray-50 bg-gray-50/50 flex justify-end gap-3">
              <button
                onClick={() => setSelectedOrder(null)}
                className="px-4 py-2 border border-gray-200 text-gray-500 rounded-lg text-xs font-semibold hover:bg-gray-100 transition-colors"
              >
                Close
              </button>
              {selectedOrder.status === 'pending' && (
                <button
                  onClick={() => markAsCompleted(selectedOrder.id)}
                  className="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-lg text-xs font-bold transition-colors flex items-center gap-1.5 shadow-sm"
                >
                  <CheckCircle2 size={14} />
                  Mark as Completed
                </button>
              )}
            </div>
          </div>
        </div>
      )}

    </div>
  );
}
