import { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { Link } from 'react-router-dom';
import {
  ShoppingCart, Package, ArrowUpRight, ArrowDownRight, Download, Truck, AlertTriangle, FileText, ChevronRight, Weight, Search, CheckCircle2
} from 'lucide-react';
import {
  LineChart, Line, XAxis, YAxis, Tooltip,
  ResponsiveContainer, CartesianGrid
} from 'recharts';

// ─── Mock Data ─────────────────────────────────────────────────────────────

const CHART_DATA_BY_TIMEFRAME: Record<'Day' | 'Week' | 'Month' | 'Year', Array<{ month: string; qty: number; orders: number; revenue: number }>> = {
  Day: [
    { month: 'Mon', qty: 450, orders: 15, revenue: 0.6 },
    { month: 'Tue', qty: 520, orders: 18, revenue: 0.7 },
    { month: 'Wed', qty: 490, orders: 16, revenue: 0.65 },
    { month: 'Thu', qty: 600, orders: 22, revenue: 0.8 },
    { month: 'Fri', qty: 580, orders: 20, revenue: 0.75 },
    { month: 'Sat', qty: 300, orders: 10, revenue: 0.4 },
    { month: 'Sun', qty: 250, orders: 8,  revenue: 0.3 },
  ],
  Week: [
    { month: 'Week 1', qty: 2800, orders: 95,  revenue: 3.8 },
    { month: 'Week 2', qty: 3200, orders: 110, revenue: 4.2 },
    { month: 'Week 3', qty: 2900, orders: 98,  revenue: 3.9 },
    { month: 'Week 4', qty: 3500, orders: 120, revenue: 4.8 },
  ],
  Month: [
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
  ],
  Year: [
    { month: '2022', qty: 125000, orders: 4200, revenue: 160 },
    { month: '2023', qty: 142000, orders: 4800, revenue: 185 },
    { month: '2024', qty: 158000, orders: 5300, revenue: 210 },
    { month: '2025', qty: 168000, orders: 5700, revenue: 225 },
    { month: '2026', qty: 174300, orders: 5900, revenue: 235 },
  ],
};

const ALERTS = [
  { icon: <Truck size={16} className="text-orange-500" />, title: '12 Deliveries pending', desc: 'Expected within next 2 days', bg: 'bg-orange-50' },
  { icon: <AlertTriangle size={16} className="text-orange-500" />, title: 'Low stock alert', desc: 'Russian Coal (6000 GAR) is low on stock', bg: 'bg-orange-50' },
  { icon: <FileText size={16} className="text-orange-500" />, title: '8 Orders awaiting approval', desc: 'Requires your attention', bg: 'bg-orange-50' },
];

const PORT_SUMMARY = [
  { name: 'Mundra', totalOrders: 10, dispatched: 7, onHold: 1, pending: 2 },
  { name: 'Kandla', totalOrders: 8,  dispatched: 4, onHold: 1, pending: 3 },
  { name: 'Hazira', totalOrders: 6,  dispatched: 3, onHold: 0, pending: 3 },
];

// Timeframe label for stat cards
const TIMEFRAME_LABEL: Record<string, string> = {
  Day: 'from yesterday',
  Week: 'from last week',
  Month: 'from last month',
  Year: 'from last year',
};

// Port Data Dictionary — includes per-timeframe changes
// positive = increase, negative = decrease
const PORT_DATA: Record<string, any> = {
  'All Ports': {
    orders: '1,248', assigned: '85,420', dispatched: '32,745', pending: '156',
    chartTotalDisp: '174,300 MT', chartOrders: '1,248', chartGrowth: '18.4%',
    scale: 1,
    changes: {
      Day:   { ordersPct: '+3.2%', ordersUp: true,  assignedPct: '+1.8%', assignedUp: true,  dispatchedPct: '-2.4%', dispatchedUp: false, pendingPct: '+5.1%', pendingUp: true  },
      Week:  { ordersPct: '+18.2%', ordersUp: true, assignedPct: '+25.4%', assignedUp: true, dispatchedPct: '+14.7%', dispatchedUp: true, pendingPct: '+8.7%',  pendingUp: true  },
      Month: { ordersPct: '+42.6%', ordersUp: true, assignedPct: '-6.3%',  assignedUp: false, dispatchedPct: '+31.2%', dispatchedUp: true, pendingPct: '-12.4%', pendingUp: false },
      Year:  { ordersPct: '+124%',  ordersUp: true, assignedPct: '+87.5%', assignedUp: true,  dispatchedPct: '+96.3%', dispatchedUp: true, pendingPct: '-18.7%', pendingUp: false },
    }
  },
  'Mundra': {
    orders: '612', assigned: '42,500', dispatched: '16,200', pending: '74',
    chartTotalDisp: '86,400 MT', chartOrders: '612', chartGrowth: '12.4%',
    scale: 0.5,
    changes: {
      Day:   { ordersPct: '+1.4%', ordersUp: true,  assignedPct: '-0.8%', assignedUp: false, dispatchedPct: '+2.1%', dispatchedUp: true,  pendingPct: '+3.6%', pendingUp: true  },
      Week:  { ordersPct: '+12.4%', ordersUp: true, assignedPct: '+15.2%', assignedUp: true,  dispatchedPct: '+8.4%', dispatchedUp: true,  pendingPct: '+4.1%', pendingUp: true  },
      Month: { ordersPct: '+28.7%', ordersUp: true, assignedPct: '+19.4%', assignedUp: true,  dispatchedPct: '-4.2%', dispatchedUp: false, pendingPct: '-9.8%', pendingUp: false },
      Year:  { ordersPct: '+68.3%', ordersUp: true, assignedPct: '+54.1%', assignedUp: true,  dispatchedPct: '+61.5%', dispatchedUp: true, pendingPct: '-22.1%', pendingUp: false },
    }
  },
  'Kandla': {
    orders: '420', assigned: '28,100', dispatched: '11,400', pending: '52',
    chartTotalDisp: '58,200 MT', chartOrders: '420', chartGrowth: '5.8%',
    scale: 0.35,
    changes: {
      Day:   { ordersPct: '-2.1%', ordersUp: false, assignedPct: '+0.6%', assignedUp: true,  dispatchedPct: '-3.8%', dispatchedUp: false, pendingPct: '+7.2%', pendingUp: true  },
      Week:  { ordersPct: '+5.8%', ordersUp: true,  assignedPct: '+10.1%', assignedUp: true,  dispatchedPct: '+6.2%', dispatchedUp: true,  pendingPct: '+3.2%', pendingUp: true  },
      Month: { ordersPct: '+16.3%', ordersUp: true, assignedPct: '-8.7%',  assignedUp: false, dispatchedPct: '+14.9%', dispatchedUp: true,  pendingPct: '-15.3%', pendingUp: false },
      Year:  { ordersPct: '+45.2%', ordersUp: true, assignedPct: '+38.6%', assignedUp: true,  dispatchedPct: '+42.0%', dispatchedUp: true,  pendingPct: '-11.4%', pendingUp: false },
    }
  },
  'Hazira': {
    orders: '216', assigned: '14,820', dispatched: '5,145', pending: '30',
    chartTotalDisp: '29,700 MT', chartOrders: '216', chartGrowth: '2.1%',
    scale: 0.15,
    changes: {
      Day:   { ordersPct: '-4.5%', ordersUp: false, assignedPct: '-1.2%', assignedUp: false, dispatchedPct: '-5.6%', dispatchedUp: false, pendingPct: '+9.3%', pendingUp: true  },
      Week:  { ordersPct: '+2.1%', ordersUp: true,  assignedPct: '+4.5%',  assignedUp: true,  dispatchedPct: '+1.2%', dispatchedUp: true,  pendingPct: '+1.1%', pendingUp: true  },
      Month: { ordersPct: '+9.8%', ordersUp: true,  assignedPct: '-3.4%',  assignedUp: false, dispatchedPct: '+7.6%', dispatchedUp: true,  pendingPct: '-6.9%', pendingUp: false },
      Year:  { ordersPct: '+31.7%', ordersUp: true, assignedPct: '+27.9%', assignedUp: true,  dispatchedPct: '+29.4%', dispatchedUp: true,  pendingPct: '-8.2%', pendingUp: false },
    }
  }
};

const STATUS_STYLES: Record<string, { label: string; cls: string }> = {
  completed: { label: 'Completed', cls: 'bg-green-50 text-green-700 border-green-200' },
  pending: { label: 'Pending', cls: 'bg-gray-100 text-gray-600 border-gray-200' },
  on_hold: { label: 'On Hold', cls: 'bg-amber-50 text-amber-700 border-amber-200' },
};

const PORT_REPORTS_DATA: Record<string, any> = {
  Mundra: {
    orders: [
      { id: 'ORD-2241', customer: 'Tata Steel Ltd', product: 'Indonesian Coal 5000 GAR', qty: 5000, status: 'completed' },
      { id: 'ORD-2230', customer: 'NTPC Ltd', product: 'Indonesian Coal 5000 GAR', qty: 2500, status: 'completed' },
      { id: 'ORD-2212', customer: 'Adani Power', product: 'South African Coal 6000', qty: 6000, status: 'completed' },
      { id: 'ORD-2208', customer: 'JSW Energy', product: 'US Coal 6800 NAR', qty: 4500, status: 'completed' },
      { id: 'ORD-2195', customer: 'Vedanta Resources', product: 'Indonesian Coal 4200 GAR', qty: 8000, status: 'completed' },
      { id: 'ORD-2182', customer: 'Tata Steel Ltd', product: 'South African Coal 5500', qty: 4000, status: 'pending' },
    ]
  },
  Kandla: {
    orders: [
      { id: 'ORD-2238', customer: 'JSW Energy', product: 'South African Coal 6000', qty: 3000, status: 'on_hold' },
      { id: 'ORD-2225', customer: 'Vedanta Resources', product: 'South African Coal 5500', qty: 4000, status: 'completed' },
      { id: 'ORD-2210', customer: 'Tata Steel Ltd', product: 'Russian Coal 6000 NAR', qty: 4500, status: 'completed' },
      { id: 'ORD-2201', customer: 'Adani Power', product: 'Indonesian Coal 4200 GAR', qty: 3500, status: 'completed' },
      { id: 'ORD-2188', customer: 'NTPC Ltd', product: 'US Coal 6800 NAR', qty: 5000, status: 'completed' },
    ]
  },
  Hazira: {
    orders: [
      { id: 'ORD-2235', customer: 'Adani Power', product: 'Indonesian Coal 4200 GAR', qty: 8000, status: 'completed' },
      { id: 'ORD-2218', customer: 'Ultratech Cement', product: 'US Coal 6800 NAR', qty: 2000, status: 'completed' },
      { id: 'ORD-2204', customer: 'JSW Energy', product: 'South African Coal 6000', qty: 1500, status: 'completed' },
    ]
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
  const [timeframe, setTimeframe] = useState<'Day' | 'Week' | 'Month' | 'Year'>('Week');
  
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedOrder, setSelectedOrder] = useState<any | null>(null);
  const [portsData, setPortsData] = useState<Record<string, any>>(PORT_REPORTS_DATA);

  const data = PORT_DATA[selectedPort];
  const reportData = selectedPort === 'All Ports' ? portsData['Mundra'] : (portsData[selectedPort] || portsData['Mundra']);

  const markAsCompleted = (orderId: string) => {
    const portKey = selectedPort === 'All Ports' ? 'Mundra' : selectedPort;
    setPortsData(prev => {
      const updatedPortData = { ...prev[portKey] };
      updatedPortData.orders = updatedPortData.orders.map((o: any) => {
        if (o.id === orderId) {
          return { ...o, status: 'completed' };
        }
        return o;
      });
      return {
        ...prev,
        [portKey]: updatedPortData
      };
    });
    setSelectedOrder(selectedOrder ? { ...selectedOrder, status: 'completed' } : null);
  };

  const getVal = (valStr: string) => {
    const numeric = parseInt(valStr.replace(/,/g, ''), 10);
    if (isNaN(numeric)) return valStr;
    const multipliers = {
      Day: 0.15,
      Week: 1.0,
      Month: 4.2,
      Year: 52.0,
    };
    return Math.round(numeric * multipliers[timeframe]).toLocaleString();
  };

  // Scale chart data based on port and selected timeframe
  const chartDataBase = CHART_DATA_BY_TIMEFRAME[timeframe];
  const chartData = chartDataBase.map((d, index) => {
    return {
      month: d.month,
      qty: Math.round(d.qty * data.scale),
      orders: Math.round(d.orders * data.scale),
      revenue: Math.round(d.revenue * data.scale * 10) / 10
    };
  });

  const totalDispatchedSum = chartData.reduce((sum, d) => sum + d.qty, 0);
  const totalOrdersSum = chartData.reduce((sum, d) => sum + d.orders, 0);

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
                onClick={() => setTimeframe(t as any)}
                className={`px-4 py-1.5 text-xs font-semibold rounded-md transition-colors ${
                  t === timeframe ? 'bg-orange-500 text-white shadow-sm' : 'text-gray-500 hover:text-gray-900'
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
        
        <div className="bg-white rounded-xl border border-gray-100 p-6 shadow-sm relative overflow-hidden flex flex-col justify-center">
          <div className="flex items-center gap-6 py-1">
            <div className="flex items-center justify-center flex-shrink-0 text-orange-500 scale-[1.8] ml-2">
              <ShoppingCart size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Total Orders</div>
              <div className="text-2xl font-bold text-gray-900">{getVal(data.orders)}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className={`font-semibold flex items-center ${data.changes[timeframe].ordersUp ? 'text-green-500' : 'text-red-500'}`}>
                  {data.changes[timeframe].ordersUp ? <ArrowUpRight size={12}/> : <ArrowDownRight size={12}/>}
                  {data.changes[timeframe].ordersPct}
                </span>
                {TIMEFRAME_LABEL[timeframe]}
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-6 shadow-sm relative overflow-hidden flex flex-col justify-center">
          <div className="flex items-center gap-6 py-1">
            <div className="flex items-center justify-center flex-shrink-0 text-orange-500 scale-[1.8] ml-2">
              <Weight size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Assigned Quantity (MT)</div>
              <div className="text-2xl font-bold text-gray-900">{getVal(data.assigned)}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className={`font-semibold flex items-center ${data.changes[timeframe].assignedUp ? 'text-green-500' : 'text-red-500'}`}>
                  {data.changes[timeframe].assignedUp ? <ArrowUpRight size={12}/> : <ArrowDownRight size={12}/>}
                  {data.changes[timeframe].assignedPct}
                </span>
                {TIMEFRAME_LABEL[timeframe]}
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-6 shadow-sm relative overflow-hidden flex flex-col justify-center">
          <div className="flex items-center gap-6 py-1">
            <div className="flex items-center justify-center flex-shrink-0 text-gray-600 scale-[1.8] ml-2">
              <Package size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Coal Dispatched (MT)</div>
              <div className="text-2xl font-bold text-gray-900">{getVal(data.dispatched)}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className={`font-semibold flex items-center ${data.changes[timeframe].dispatchedUp ? 'text-green-500' : 'text-red-500'}`}>
                  {data.changes[timeframe].dispatchedUp ? <ArrowUpRight size={12}/> : <ArrowDownRight size={12}/>}
                  {data.changes[timeframe].dispatchedPct}
                </span>
                {TIMEFRAME_LABEL[timeframe]}
              </div>
            </div>
          </div>
        </div>

        <div className="bg-white rounded-xl border border-gray-100 p-6 shadow-sm relative overflow-hidden flex flex-col justify-center">
          <div className="flex items-center gap-6 py-1">
            <div className="flex items-center justify-center flex-shrink-0 text-orange-500 scale-[1.8] ml-2">
              <Truck size={20} />
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Pending Dispatches</div>
              <div className="text-2xl font-bold text-gray-900">{getVal(data.pending)}</div>
              <div className="flex items-center gap-1 mt-1 text-xs text-gray-400">
                <span className={`font-semibold flex items-center ${data.changes[timeframe].pendingUp ? 'text-green-500' : 'text-red-500'}`}>
                  {data.changes[timeframe].pendingUp ? <ArrowUpRight size={12}/> : <ArrowDownRight size={12}/>}
                  {data.changes[timeframe].pendingPct}
                </span>
                {TIMEFRAME_LABEL[timeframe]}
              </div>
            </div>
          </div>
        </div>

      </div>

      {/* ── Lower Section ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Left Column (Chart) */}
        <div className="lg:col-span-2 bg-white border border-gray-100 rounded-xl shadow-sm p-6 flex flex-col">
          <div className="flex items-center justify-between mb-6">
            <h3 className="font-bold text-gray-800">
              {timeframe === 'Day' ? 'Daily' : timeframe === 'Week' ? 'Weekly' : timeframe === 'Month' ? 'Monthly' : 'Yearly'} Dispatch Performance
            </h3>
          </div>

          <div className="grid grid-cols-3 gap-4 mb-8">
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Total Dispatched</div>
              <div className="text-xl font-bold text-gray-900">{totalDispatchedSum.toLocaleString()} MT</div>
              <div className="text-xs text-green-500 font-semibold mt-1">↑ 18.4% vs last month</div>
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Orders</div>
              <div className="text-xl font-bold text-gray-900">{totalOrdersSum.toLocaleString()}</div>
              <div className="text-xs text-green-500 font-semibold mt-1">↑ 16.2% vs last month</div>
            </div>
            <div>
              <div className="text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Dispatch Growth</div>
              <div className="text-xl font-bold text-gray-900">{data.chartGrowth}</div>
              <div className="text-xs text-green-500 font-semibold mt-1">↑ 2.6% vs last month</div>
            </div>
          </div>

          <div className="flex-1 flex flex-col gap-6">
            
            {/* Chart 1: Revenue & Orders */}
            <div>
              <div className="text-xs font-bold text-gray-900 uppercase tracking-wider mb-3 text-center">Revenue & Orders</div>
              <div className="h-[220px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={chartData} margin={{ top: 5, right: 0, left: -5, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis dataKey="month" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#1e293b' }} dy={10} />
                    <YAxis yAxisId="left" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#1e293b' }} tickFormatter={(v) => `${v} Cr`} />
                    <YAxis yAxisId="right" orientation="right" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#1e293b' }} />
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
              <div className="text-xs font-bold text-gray-900 uppercase tracking-wider mb-3 text-center">Dispatched vs Orders Placed</div>
              <div className="h-[220px] w-full">
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={chartData} margin={{ top: 5, right: 0, left: -5, bottom: 0 }}>
                    <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="#f1f5f9" />
                    <XAxis dataKey="month" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#1e293b' }} dy={10} />
                    <YAxis yAxisId="left" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#1e293b' }} tickFormatter={(v) => `${v/1000}k`} />
                    <YAxis yAxisId="right" orientation="right" axisLine={false} tickLine={false} tick={{ fontSize: 11, fill: '#1e293b' }} />
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
          <div className="bg-white border border-gray-100 rounded-xl shadow-sm p-5">
            <div className="flex items-center justify-between mb-5">
              <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Port Alerts</h3>
              <Link to="/port-admin/notifications" className="text-xs text-orange-500 hover:text-orange-600 font-semibold flex items-center">
                See All <ChevronRight size={14} />
              </Link>
            </div>
            <div className="space-y-3">
              {ALERTS.map((alert, i) => (
                <div key={i} className="flex items-center justify-between p-3 rounded-lg border border-gray-50 hover:bg-gray-50 transition-colors cursor-pointer group">
                  <div className="flex items-center gap-3">
                    <div className="flex items-center justify-center flex-shrink-0 scale-[1.25] pr-1">
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
          <div className="bg-white border border-gray-100 rounded-xl shadow-sm p-5">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Port Summary</h3>
              <Link to="/port-admin/orders" className="text-xs text-orange-500 hover:text-orange-600 font-semibold flex items-center">
                See All <ChevronRight size={14} />
              </Link>
            </div>

            {/* Legend */}
            <div className="flex items-center gap-4 mb-5 pb-4 border-b border-gray-50">
              <div className="flex items-center gap-1.5 text-[10px] text-gray-500 font-medium">
                <div className="w-2 h-2 rounded-full bg-green-500"></div> Dispatched
              </div>
              <div className="flex items-center gap-1.5 text-[10px] text-gray-500 font-medium">
                <div className="w-2 h-2 rounded-full bg-amber-400"></div> On Hold
              </div>
              <div className="flex items-center gap-1.5 text-[10px] text-gray-500 font-medium">
                <div className="w-2 h-2 rounded-full bg-gray-200"></div> Pending
              </div>
            </div>

            <div className="space-y-6">
              {PORT_SUMMARY.map((port, i) => (
                <div key={port.name}>
                  <div className="flex items-center justify-between mb-2">
                    <div className="text-sm font-bold text-gray-800">{port.name}</div>
                    <div className="text-xs font-semibold text-gray-700">
                      {port.totalOrders} <span className="font-normal text-gray-400">Orders</span>
                    </div>
                  </div>
                  
                  {/* Single Segmented Bar */}
                  <div className="flex h-2.5 rounded-full overflow-hidden bg-gray-50 gap-px">
                    <div title={`${port.dispatched} Dispatched`} className="bg-green-500" style={{ width: `${(port.dispatched/port.totalOrders)*100}%` }}></div>
                    <div title={`${port.onHold} On Hold`} className="bg-amber-400" style={{ width: `${(port.onHold/port.totalOrders)*100}%` }}></div>
                    <div title={`${port.pending} Pending`} className="bg-gray-200" style={{ width: `${(port.pending/port.totalOrders)*100}%` }}></div>
                  </div>
                  
                  <div className="flex gap-3 mt-1.5 flex-wrap">
                    <span className="text-[10px] text-gray-500 font-medium">{port.dispatched} Dispatched</span>
                    {port.onHold > 0 && <span className="text-[10px] text-gray-500 font-medium">{port.onHold} On Hold</span>}
                    {port.pending > 0 && <span className="text-[10px] text-gray-500 font-medium">{port.pending} Pending</span>}
                  </div>
                </div>
              ))}
            </div>
          </div>

        </div>

      </div>

      {/* ── Transactions Table ── */}
      <div className="bg-white border border-gray-100 rounded-xl shadow-sm p-6 flex flex-col gap-4 overflow-hidden mt-6">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2">
            <span>Recent Dispatches Log</span>
            <span className="text-xs text-gray-400 font-normal border-l pl-2 border-gray-200">{selectedPort === 'All Ports' ? 'Mundra (Default)' : selectedPort} Port Only</span>
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
                <th className="py-3 px-3">Sr no</th>
                <th className="py-3 px-3">Order ID</th>
                <th className="py-3 px-3">Customer</th>
                <th className="py-3 px-3">Product</th>
                <th className="py-3 px-3 text-right">Quantity</th>
                <th className="py-3 px-3 text-center">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50 text-xs">
              {reportData.orders
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
                .map((o: any, idx: number) => {
                const style = STATUS_STYLES[o.status] || STATUS_STYLES.pending;
                return (
                  <tr 
                    key={o.id} 
                    onClick={() => setSelectedOrder(o)}
                    className="hover:bg-orange-50/20 transition-colors cursor-pointer"
                  >
                    <td className="py-3 px-3 font-semibold text-gray-900">{idx + 1}</td>
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
