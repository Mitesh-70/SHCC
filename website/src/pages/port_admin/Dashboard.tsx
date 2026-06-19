import { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import {
  ShoppingCart, Package, ArrowUpRight, Download, Truck, AlertTriangle, FileText, ChevronRight
} from 'lucide-react';
import {
  LineChart, Line, XAxis, YAxis, Tooltip,
  ResponsiveContainer, CartesianGrid
} from 'recharts';

// ─── Mock Data ─────────────────────────────────────────────────────────────

const DISPATCH_CHART_BASE = [
  { month: 'Jan', qty: 12000, orders: 400, revenue: 15 },
  { month: 'Feb', qty: 9800,  orders: 320, revenue: 12 },
  { month: 'Mar', qty: 18000, orders: 600, revenue: 22 },
  { month: 'Apr', qty: 11200, orders: 380, revenue: 14 },
  { month: 'May', qty: 14500, orders: 480, revenue: 18 },
  { month: 'Jun', qty: 9200,  orders: 300, revenue: 11 },
  { month: 'Jul', qty: 15000, orders: 500, revenue: 19 },
  { month: 'Aug', qty: 19000, orders: 650, revenue: 24 },
  { month: 'Sep', qty: 13000, orders: 420, revenue: 16 },
  { month: 'Oct', qty: 16500, orders: 550, revenue: 20 },
  { month: 'Nov', qty: 17200, orders: 580, revenue: 21 },
  { month: 'Dec', qty: 18900, orders: 620, revenue: 23 },
];

const ALERTS = [
  { icon: <Truck size={16} className="text-orange-500" />, title: '12 Deliveries pending', desc: 'Expected within next 2 days', bg: 'bg-orange-50' },
  { icon: <AlertTriangle size={16} className="text-orange-500" />, title: 'Low stock alert', desc: 'Hazira port is low on stock', bg: 'bg-orange-50' },
  { icon: <FileText size={16} className="text-orange-500" />, title: '8 Orders awaiting approval', desc: 'Requires your attention', bg: 'bg-orange-50' },
];

const PORT_SUMMARY = [
  { name: 'Mundra', qty: '12,450 MT' },
  { name: 'Kandla', qty: '8,180 MT' },
  { name: 'Hazira', qty: '5,240 MT' },
];

// Port Data Dictionary
const PORT_DATA: Record<string, any> = {
  'All Ports': {
    orders: '1,248', ordersPct: '18.2%',
    assigned: '85,420', assignedPct: '25.4%',
    dispatched: '32,745', dispatchedPct: '14.7%',
    pending: '156', pendingPct: '8.7%',
    chartTotalDisp: '174,300 MT', chartOrders: '1,248', chartGrowth: '18.4%',
    scale: 1
  },
  'Mundra': {
    orders: '612', ordersPct: '12.4%',
    assigned: '42,500', assignedPct: '15.2%',
    dispatched: '16,200', dispatchedPct: '8.4%',
    pending: '74', pendingPct: '4.1%',
    chartTotalDisp: '86,400 MT', chartOrders: '612', chartGrowth: '12.4%',
    scale: 0.5
  },
  'Kandla': {
    orders: '420', ordersPct: '5.8%',
    assigned: '28,100', assignedPct: '10.1%',
    dispatched: '11,400', dispatchedPct: '6.2%',
    pending: '52', pendingPct: '3.2%',
    chartTotalDisp: '58,200 MT', chartOrders: '420', chartGrowth: '5.8%',
    scale: 0.35
  },
  'Hazira': {
    orders: '216', ordersPct: '2.1%',
    assigned: '14,820', assignedPct: '4.5%',
    dispatched: '5,145', dispatchedPct: '1.2%',
    pending: '30', pendingPct: '1.1%',
    chartTotalDisp: '29,700 MT', chartOrders: '216', chartGrowth: '2.1%',
    scale: 0.15
  }
};

// ─── Sub-components ────────────────────────────────────────────────────────

const CustomTooltip = ({ active, payload, label }: any) => {
  if (active && payload && payload.length) {
    return (
      <div className="bg-white border border-gray-100 shadow-xl rounded-xl p-4 min-w-[160px]">
        <div className="font-bold text-gray-800 mb-3 text-sm">{label}</div>
        <div className="space-y-2 text-sm">
          {payload.map((entry: any, index: number) => (
            <div key={index} className="flex items-center justify-between gap-4">
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full" style={{ backgroundColor: entry.color }}></div>
                <span className="text-gray-500">{entry.name}:</span>
              </div>
              <span className="font-bold text-gray-800">
                {entry.name.includes('Revenue') ? `₹${entry.value} Cr` : entry.value.toLocaleString()}
              </span>
            </div>
          ))}
        </div>
      </div>
    );
  }
  return null;
};

function Sparkline({ scale, color, base }: { scale: number, color: string, base: number[] }) {
  const data = base.map(v => ({ v: v * scale }));
  return (
    <div className="h-10 w-full mt-4">
      <ResponsiveContainer width="100%" height="100%">
        <LineChart data={data}>
          <Line type="monotone" dataKey="v" stroke={color} strokeWidth={2} dot={false} isAnimationActive={false} />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}

// ─── Main Component ────────────────────────────────────────────────────────

export default function PortAdminDashboard() {
  const { user } = useAuth();
  const [selectedPort, setSelectedPort] = useState('All Ports');

  const data = PORT_DATA[selectedPort];
  
  // Scale chart data based on port
  const chartData = DISPATCH_CHART_BASE.map(d => ({
    month: d.month,
    qty: Math.round(d.qty * data.scale),
    orders: Math.round(d.orders * data.scale),
    revenue: Math.round(d.revenue * data.scale * 10) / 10
  }));

  return (
    <div className="p-6 space-y-6 bg-[#f8fafc] min-h-screen">
      
      {/* ── Header ── */}
      <div className="flex items-start justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
            Good evening, {user?.name?.split(' ')[0] ?? 'Admin'}! 👋
          </h1>
          <p className="text-sm text-gray-500 mt-1">
            Here's what's happening with your port operations today.
          </p>
        </div>
        <button className="flex items-center gap-2 bg-[#1e293b] text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-gray-800 transition-colors">
          <Download size={16} />
          Export Report
        </button>
      </div>

      {/* ── Title & Toggles ── */}
      <div className="flex items-center justify-between pt-2">
        <h2 className="text-lg font-bold text-gray-800">Port Performance</h2>
        <div className="flex items-center gap-3">
          <select 
            value={selectedPort}
            onChange={(e) => setSelectedPort(e.target.value)}
            className="text-sm border border-gray-200 rounded-lg px-3 py-1.5 text-gray-600 outline-none bg-white shadow-sm font-medium cursor-pointer"
          >
            <option>All Ports</option>
            <option>Mundra</option>
            <option>Kandla</option>
            <option>Hazira</option>
          </select>
          <div className="flex items-center bg-white border border-gray-200 rounded-lg p-1 shadow-sm">
            {['Day', 'Week', 'Month', 'Year'].map(t => (
              <button
                key={t}
                className={`px-4 py-1.5 text-xs font-semibold rounded-md transition-colors ${
                  t === 'Week' ? 'bg-orange-500 text-white shadow-sm' : 'text-gray-500 hover:text-gray-900'
                }`}
              >
                {t}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* ── KPI Stats (4 Cards) ── */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        
        <div className="bg-white rounded-xl border border-gray-100 p-5 shadow-sm relative overflow-hidden flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-lg bg-orange-50 flex items-center justify-center flex-shrink-0 text-orange-500">
              <ShoppingCart size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Total Orders</div>
              <div className="text-2xl font-bold text-gray-900">{data.orders}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className="text-green-500 font-semibold flex items-center"><ArrowUpRight size={12}/> {data.ordersPct}</span>
                from last week
              </div>
            </div>
          </div>
          <Sparkline scale={data.scale} color="#f97316" base={[10, 12, 11, 15, 14, 18, 20]} />
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-5 shadow-sm relative overflow-hidden flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-lg bg-orange-50 flex items-center justify-center flex-shrink-0 text-orange-500 font-bold text-lg">
              MT
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Assigned Quantity (MT)</div>
              <div className="text-2xl font-bold text-gray-900">{data.assigned}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className="text-green-500 font-semibold flex items-center"><ArrowUpRight size={12}/> {data.assignedPct}</span>
                from last week
              </div>
            </div>
          </div>
          <Sparkline scale={data.scale} color="#f97316" base={[50, 40, 60, 70, 65, 80, 90]} />
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-5 shadow-sm relative overflow-hidden flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-lg bg-gray-50 flex items-center justify-center flex-shrink-0 text-gray-600">
              <Package size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Coal Dispatched (MT)</div>
              <div className="text-2xl font-bold text-gray-900">{data.dispatched}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className="text-green-500 font-semibold flex items-center"><ArrowUpRight size={12}/> {data.dispatchedPct}</span>
                from last week
              </div>
            </div>
          </div>
          <Sparkline scale={data.scale} color="#475569" base={[100, 95, 105, 110, 115, 112, 120]} />
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-5 shadow-sm relative overflow-hidden flex flex-col justify-between">
          <div className="flex items-start gap-4">
            <div className="w-10 h-10 rounded-lg bg-orange-50 flex items-center justify-center flex-shrink-0 text-orange-500">
              <Truck size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Pending Dispatches</div>
              <div className="text-2xl font-bold text-gray-900">{data.pending}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className="text-green-500 font-semibold flex items-center"><ArrowUpRight size={12}/> {data.pendingPct}</span>
                from last week
              </div>
            </div>
          </div>
          <Sparkline scale={data.scale} color="#f97316" base={[20, 22, 21, 25, 24, 28, 30]} />
        </div>

      </div>

      {/* ── Lower Section ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Left Column (Chart) */}
        <div className="lg:col-span-2 bg-white border border-gray-100 rounded-xl shadow-sm p-6 flex flex-col">
          <div className="flex items-center justify-between mb-6">
            <h3 className="font-bold text-gray-800">Monthly Dispatch Performance</h3>
            <div className="flex items-center gap-2">
              <select 
                value={selectedPort}
                onChange={(e) => setSelectedPort(e.target.value)}
                className="text-xs border border-gray-200 rounded-md px-2 py-1 text-gray-600 outline-none bg-white cursor-pointer"
              >
                <option>All Ports</option>
                <option>Mundra</option>
                <option>Kandla</option>
                <option>Hazira</option>
              </select>
              <select className="text-xs border border-gray-200 rounded-md px-2 py-1 text-gray-600 outline-none bg-white cursor-pointer">
                <option>This Year</option>
                <option>Last Year</option>
              </select>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-4 mb-8">
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Total Dispatched</div>
              <div className="text-xl font-bold text-gray-900">{data.chartTotalDisp}</div>
              <div className="text-xs text-green-500 font-semibold mt-1">↑ 18.4% vs last year</div>
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Orders</div>
              <div className="text-xl font-bold text-gray-900">{data.chartOrders}</div>
              <div className="text-xs text-green-500 font-semibold mt-1">↑ 16.2% vs last year</div>
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Dispatch Growth</div>
              <div className="text-xl font-bold text-gray-900">{data.chartGrowth}</div>
              <div className="text-xs text-green-500 font-semibold mt-1">↑ 2.6% vs last year</div>
            </div>
          </div>

          <div className="flex-1 flex flex-col gap-6">
            
            {/* Chart 1: Revenue & Orders */}
            <div>
              <div className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 text-center">Revenue & Orders</div>
              <div className="h-[220px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={chartData} margin={{ top: 5, right: 0, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis dataKey="month" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#94a3b8' }} dy={10} />
                    <YAxis yAxisId="left" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#94a3b8' }} tickFormatter={(v) => `${v} Cr`} />
                    <YAxis yAxisId="right" orientation="right" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#94a3b8' }} />
                    <Tooltip content={<CustomTooltip />} cursor={{ stroke: '#f1f5f9', strokeWidth: 2, strokeDasharray: '4 4' }} />
                    <Line 
                      yAxisId="right"
                      name="Orders"
                      type="monotone" 
                      dataKey="orders" 
                      stroke="#cbd5e1" 
                      strokeWidth={2} 
                      strokeDasharray="4 4"
                      dot={{ r: 4, fill: '#cbd5e1', stroke: '#fff', strokeWidth: 2 }} 
                      activeDot={{ r: 6, fill: '#cbd5e1', stroke: '#fff', strokeWidth: 2 }} 
                    />
                    <Line 
                      yAxisId="left"
                      name="Revenue (₹)"
                      type="monotone" 
                      dataKey="revenue" 
                      stroke="#f97316" 
                      strokeWidth={2} 
                      dot={{ r: 4, fill: '#f97316', stroke: '#fff', strokeWidth: 2 }} 
                      activeDot={{ r: 6, fill: '#f97316', stroke: '#fff', strokeWidth: 2 }} 
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
              <div className="flex justify-center gap-6 mt-2 pt-2">
                <div className="flex items-center gap-1.5 text-xs text-gray-500 font-medium">
                  <div className="w-2.5 h-2.5 rounded-full bg-gray-300"></div> Orders
                </div>
                <div className="flex items-center gap-1.5 text-xs text-gray-500 font-medium">
                  <div className="w-2.5 h-2.5 rounded-full bg-orange-500"></div> Revenue (₹)
                </div>
              </div>
            </div>

            {/* Chart 2: Dispatched vs Orders */}
            <div className="mt-4 pt-4 border-t border-gray-100">
              <div className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 text-center">Dispatched vs Orders Placed</div>
              <div className="h-[220px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={chartData} margin={{ top: 5, right: 0, left: -20, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis dataKey="month" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#94a3b8' }} dy={10} />
                    <YAxis yAxisId="left" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#94a3b8' }} tickFormatter={(v) => `${v/1000}k`} />
                    <YAxis yAxisId="right" orientation="right" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#94a3b8' }} />
                    <Tooltip content={<CustomTooltip />} cursor={{ stroke: '#f1f5f9', strokeWidth: 2, strokeDasharray: '4 4' }} />
                    <Line 
                      yAxisId="right"
                      name="Orders Placed"
                      type="monotone" 
                      dataKey="orders" 
                      stroke="#cbd5e1" 
                      strokeWidth={2} 
                      strokeDasharray="4 4"
                      dot={{ r: 4, fill: '#cbd5e1', stroke: '#fff', strokeWidth: 2 }} 
                      activeDot={{ r: 6, fill: '#cbd5e1', stroke: '#fff', strokeWidth: 2 }} 
                    />
                    <Line 
                      yAxisId="left"
                      name="Dispatched (MT)"
                      type="monotone" 
                      dataKey="qty" 
                      stroke="#f97316" 
                      strokeWidth={2} 
                      dot={{ r: 4, fill: '#f97316', stroke: '#fff', strokeWidth: 2 }} 
                      activeDot={{ r: 6, fill: '#f97316', stroke: '#fff', strokeWidth: 2 }} 
                    />
                  </LineChart>
                </ResponsiveContainer>
              </div>
              <div className="flex justify-center gap-6 mt-2 pt-2">
                <div className="flex items-center gap-1.5 text-xs text-gray-500 font-medium">
                  <div className="w-2.5 h-2.5 rounded-full bg-gray-300"></div> Orders Placed
                </div>
                <div className="flex items-center gap-1.5 text-xs text-gray-500 font-medium">
                  <div className="w-2.5 h-2.5 rounded-full bg-orange-500"></div> Dispatched (MT)
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Right Column */}
        <div className="space-y-6 flex flex-col">
          
          {/* Port Alerts */}
          <div className="bg-white border border-gray-100 rounded-xl shadow-sm p-5 flex-1">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Port Alerts</h3>
              <button className="text-xs text-orange-500 hover:text-orange-600 font-semibold flex items-center">
                See All <ChevronRight size={14} />
              </button>
            </div>
            <div className="space-y-3">
              {ALERTS.map((alert, i) => (
                <div key={i} className="flex items-center justify-between p-3 rounded-lg border border-gray-50 hover:bg-gray-50 transition-colors cursor-pointer group">
                  <div className="flex items-center gap-3">
                    <div className={`w-10 h-10 rounded-lg ${alert.bg} flex items-center justify-center flex-shrink-0`}>
                      {alert.icon}
                    </div>
                    <div>
                      <div className="text-sm font-bold text-gray-800">{alert.title}</div>
                      <div className="text-xs text-gray-400 mt-0.5">{alert.desc}</div>
                    </div>
                  </div>
                  <ChevronRight size={14} className="text-gray-300 group-hover:text-gray-500" />
                </div>
              ))}
            </div>
          </div>

          {/* Port Summary */}
          <div className="bg-white border border-gray-100 rounded-xl shadow-sm p-5 flex-1">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Port Summary</h3>
              <button className="text-xs text-orange-500 hover:text-orange-600 font-semibold flex items-center">
                See All <ChevronRight size={14} />
              </button>
            </div>
            <div className="space-y-0 divide-y divide-gray-50">
              {PORT_SUMMARY.map((port, i) => (
                <div key={port.name} className="flex items-center justify-between py-3">
                  <div className="text-sm text-gray-600 font-medium">{port.name}</div>
                  <div className="text-sm font-bold text-orange-500">{port.qty}</div>
                </div>
              ))}
            </div>
          </div>

        </div>

      </div>

    </div>
  );
}
