import { useAuth } from '../../context/AuthContext';
import {
  Anchor, ShoppingCart, CheckCircle2, User, Mail, Building2,
  Clock, Truck, PauseCircle, TrendingUp, Package, Calendar,
  MapPin, Phone, Shield
} from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid } from 'recharts';

// ─── Mock Data ────────────────────────────────────────────────────────────────

const ASSIGNED_PORTS = ['Mundra', 'Kandla', 'Hazira'];

const STATS = [
  { label: 'Total Orders',      value: 24, icon: <ShoppingCart size={18} />, bg: 'bg-teal-50',   text: 'text-teal-600',  border: 'border-teal-100'  },
  { label: 'Pending Dispatch',  value: 8,  icon: <Clock size={18} />,        bg: 'bg-amber-50',  text: 'text-amber-600', border: 'border-amber-100' },
  { label: 'On Hold',           value: 3,  icon: <PauseCircle size={18} />,  bg: 'bg-red-50',    text: 'text-red-500',   border: 'border-red-100'   },
  { label: 'Dispatched',        value: 9,  icon: <Truck size={18} />,        bg: 'bg-blue-50',   text: 'text-blue-600',  border: 'border-blue-100'  },
  { label: 'Completed',         value: 4,  icon: <CheckCircle2 size={18} />, bg: 'bg-green-50',  text: 'text-green-600', border: 'border-green-100' },
];

const PORT_STATS = [
  { port: 'Mundra',  total: 10, dispatched: 6, onHold: 1, completed: 2, pending: 1, color: 'bg-teal-500' },
  { port: 'Kandla',  total: 8,  dispatched: 2, onHold: 2, completed: 1, pending: 3, color: 'bg-blue-500'  },
  { port: 'Hazira',  total: 6,  dispatched: 1, onHold: 0, completed: 1, pending: 4, color: 'bg-violet-500'},
];

const RECENT_ORDERS = [
  { id: 'ORD-2241', customer: 'Tata Steel Ltd',     port: 'Mundra', product: 'Indonesian Coal 5000 GAR', qty: 5000, dispatched: 0,    status: 'approved'   },
  { id: 'ORD-2238', customer: 'JSW Energy',          port: 'Kandla', product: 'South African Coal 6000',  qty: 3000, dispatched: 500,  status: 'on_hold'    },
  { id: 'ORD-2235', customer: 'Adani Power',         port: 'Hazira', product: 'Indonesian Coal 4200 GAR', qty: 8000, dispatched: 4000, status: 'dispatched' },
  { id: 'ORD-2230', customer: 'NTPC Ltd',            port: 'Mundra', product: 'Indonesian Coal 5000 GAR', qty: 2500, dispatched: 0,    status: 'approved'   },
  { id: 'ORD-2225', customer: 'Vedanta Resources',   port: 'Kandla', product: 'South African Coal 5500',  qty: 4000, dispatched: 4000, status: 'completed'  },
];

const DISPATCH_CHART = [
  { month: 'Jan', qty: 12400 },
  { month: 'Feb', qty: 9800  },
  { month: 'Mar', qty: 15600 },
  { month: 'Apr', qty: 11200 },
  { month: 'May', qty: 18900 },
  { month: 'Jun', qty: 9200  },
];

const STATUS_STYLES: Record<string, { label: string; cls: string }> = {
  approved:   { label: 'Approved',   cls: 'bg-green-50 text-green-700 border-green-200'  },
  on_hold:    { label: 'On Hold',    cls: 'bg-amber-50 text-amber-700 border-amber-200'  },
  dispatched: { label: 'Dispatched', cls: 'bg-blue-50 text-blue-700 border-blue-200'    },
  completed:  { label: 'Completed',  cls: 'bg-teal-50 text-teal-700 border-teal-200'    },
};

// ─── Component ────────────────────────────────────────────────────────────────

export default function PortAdminProfile() {
  const { user } = useAuth();

  return (
    <div className="p-6 space-y-6">

      {/* ── Header ── */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">My Profile</h1>
        <p className="text-sm text-gray-500 mt-0.5">Your account details, port assignments, and performance overview.</p>
      </div>

      {/* ── Top Row: Profile Card + Permissions ── */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4">

        {/* Profile Info */}
        <div className="lg:col-span-2 bg-white border border-gray-100 rounded-2xl p-6 shadow-sm">
          <div className="flex items-start gap-5">
            <div className="w-20 h-20 rounded-2xl bg-gradient-to-br from-teal-400 to-teal-600 flex items-center justify-center flex-shrink-0 shadow-md">
              <User size={32} className="text-white" />
            </div>
            <div className="flex-1 min-w-0">
              <div className="flex items-center gap-3 flex-wrap">
                <h2 className="text-xl font-bold text-gray-900">{user?.name ?? 'Port Admin'}</h2>
                <span className="bg-teal-50 text-teal-700 border border-teal-200 text-xs font-bold px-2.5 py-1 rounded-full">Port Admin</span>
              </div>
              <div className="mt-3 grid grid-cols-1 sm:grid-cols-2 gap-y-2 gap-x-6">
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <Mail size={13} className="text-gray-400 flex-shrink-0" />
                  <span className="truncate">{user?.email ?? 'portadmin@shcc.co.in'}</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <Building2 size={13} className="text-gray-400 flex-shrink-0" />
                  <span>{user?.department ?? 'Port Operations'}</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <Phone size={13} className="text-gray-400 flex-shrink-0" />
                  <span>+91 98765 43210</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <MapPin size={13} className="text-gray-400 flex-shrink-0" />
                  <span>Gujarat, India</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <Calendar size={13} className="text-gray-400 flex-shrink-0" />
                  <span>Joined: Jan 2024</span>
                </div>
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <Shield size={13} className="text-gray-400 flex-shrink-0" />
                  <span>ID: USR-0004</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Permissions Summary */}
        <div className="bg-white border border-gray-100 rounded-2xl p-5 shadow-sm">
          <h3 className="text-sm font-bold text-gray-800 mb-3 flex items-center gap-2">
            <Shield size={14} className="text-teal-600" />
            Role Permissions
          </h3>
          <ul className="space-y-2">
            {[
              { label: 'View assigned port orders', allowed: true  },
              { label: 'Manage dispatch entries',   allowed: true  },
              { label: 'Place orders on hold',      allowed: true  },
              { label: 'Mark orders completed',     allowed: true  },
              { label: 'Edit commercial details',   allowed: false },
              { label: 'Approve / reject orders',   allowed: false },
              { label: 'View all ports',            allowed: false },
            ].map(p => (
              <li key={p.label} className="flex items-center gap-2.5 text-xs">
                <span className={`w-4 h-4 rounded-full flex items-center justify-center flex-shrink-0 ${p.allowed ? 'bg-green-100 text-green-600' : 'bg-red-100 text-red-400'}`}>
                  {p.allowed ? '✓' : '✕'}
                </span>
                <span className={p.allowed ? 'text-gray-700' : 'text-gray-400'}>{p.label}</span>
              </li>
            ))}
          </ul>
        </div>
      </div>

      {/* ── Stats Row ── */}
      <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3">
        {STATS.map(s => (
          <div key={s.label} className={`bg-white border ${s.border} rounded-2xl p-4 shadow-sm flex flex-col gap-3`}>
            <div className={`w-9 h-9 rounded-xl flex items-center justify-center ${s.bg} ${s.text}`}>
              {s.icon}
            </div>
            <div>
              <div className="text-2xl font-bold text-gray-900">{s.value}</div>
              <div className="text-[11px] text-gray-500 leading-tight">{s.label}</div>
            </div>
          </div>
        ))}
      </div>

      {/* ── Middle Row: Port Breakdown + Dispatch Chart ── */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">

        {/* Per-Port Breakdown */}
        <div className="bg-white border border-gray-100 rounded-2xl p-5 shadow-sm">
          <h3 className="text-sm font-bold text-gray-800 mb-4 flex items-center gap-2">
            <Anchor size={14} className="text-teal-600" />
            Assigned Ports — Order Breakdown
          </h3>
          <div className="space-y-5">
            {PORT_STATS.map(p => (
              <div key={p.port}>
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <div className={`w-2 h-2 rounded-full ${p.color}`} />
                    <span className="text-sm font-semibold text-gray-800">{p.port}</span>
                  </div>
                  <span className="text-xs text-gray-400">{p.total} total</span>
                </div>
                {/* Segmented progress bar */}
                <div className="flex h-2.5 rounded-full overflow-hidden bg-gray-100 gap-px">
                  <div title="Dispatched"  className="bg-blue-500"   style={{ width: `${(p.dispatched / p.total) * 100}%` }} />
                  <div title="On Hold"     className="bg-amber-400"  style={{ width: `${(p.onHold / p.total) * 100}%` }} />
                  <div title="Completed"   className="bg-green-500"  style={{ width: `${(p.completed / p.total) * 100}%` }} />
                  <div title="Pending"     className="bg-gray-200"   style={{ width: `${(p.pending / p.total) * 100}%` }} />
                </div>
                <div className="flex gap-4 mt-1.5 flex-wrap">
                  <span className="text-[10px] text-blue-600 font-medium">{p.dispatched} Dispatched</span>
                  <span className="text-[10px] text-amber-600 font-medium">{p.onHold} On Hold</span>
                  <span className="text-[10px] text-green-600 font-medium">{p.completed} Completed</span>
                  <span className="text-[10px] text-gray-400 font-medium">{p.pending} Pending</span>
                </div>
              </div>
            ))}
          </div>

          {/* Port Legend Badges */}
          <div className="mt-4 pt-4 border-t border-gray-50 flex flex-wrap gap-2">
            {ASSIGNED_PORTS.map(port => (
              <span key={port} className="inline-flex items-center gap-1 bg-teal-50 text-teal-700 border border-teal-100 text-xs font-semibold px-2.5 py-1 rounded-full">
                <Anchor size={10} />{port}
              </span>
            ))}
          </div>
        </div>

        {/* Monthly Dispatch Chart */}
        <div className="bg-white border border-gray-100 rounded-2xl p-5 shadow-sm">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2">
              <TrendingUp size={14} className="text-teal-600" />
              Monthly Dispatch Volume (MT)
            </h3>
            <span className="text-xs text-gray-400">2026</span>
          </div>
          <ResponsiveContainer width="100%" height={180}>
            <BarChart data={DISPATCH_CHART} barSize={22}>
              <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" vertical={false} />
              <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#94a3b8' }} axisLine={false} tickLine={false} />
              <YAxis tick={{ fontSize: 10, fill: '#94a3b8' }} axisLine={false} tickLine={false} tickFormatter={v => `${(v/1000).toFixed(0)}k`} />
              <Tooltip
                contentStyle={{ borderRadius: 10, border: '1px solid #e2e8f0', fontSize: 12 }}
                formatter={(v: number) => [`${v.toLocaleString()} MT`, 'Dispatched']}
              />
              <Bar dataKey="qty" fill="#14b8a6" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
          <div className="mt-2 text-xs text-gray-400 text-center">Total dispatched this year: <span className="font-semibold text-gray-600">77,100 MT</span></div>
        </div>
      </div>

      {/* ── Recent Orders Table ── */}
      <div className="bg-white border border-gray-100 rounded-2xl shadow-sm overflow-hidden">
        <div className="px-5 py-4 border-b border-gray-50 flex items-center justify-between">
          <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2">
            <Package size={14} className="text-teal-600" />
            Recent Orders
          </h3>
          <span className="text-xs text-gray-400">Last 5 orders across assigned ports</span>
        </div>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-50 bg-gray-50/50">
                <th className="text-left text-xs font-semibold text-gray-400 uppercase tracking-wider px-5 py-2.5">Order ID</th>
                <th className="text-left text-xs font-semibold text-gray-400 uppercase tracking-wider px-5 py-2.5">Customer</th>
                <th className="text-left text-xs font-semibold text-gray-400 uppercase tracking-wider px-5 py-2.5">Port</th>
                <th className="text-left text-xs font-semibold text-gray-400 uppercase tracking-wider px-5 py-2.5">Qty (MT)</th>
                <th className="text-left text-xs font-semibold text-gray-400 uppercase tracking-wider px-5 py-2.5">Dispatched</th>
                <th className="text-left text-xs font-semibold text-gray-400 uppercase tracking-wider px-5 py-2.5">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-50">
              {RECENT_ORDERS.map(order => {
                const pct = order.qty > 0 ? Math.round((order.dispatched / order.qty) * 100) : 0;
                const s = STATUS_STYLES[order.status];
                return (
                  <tr key={order.id} className="hover:bg-gray-50/40 transition-colors">
                    <td className="px-5 py-3 font-mono text-xs font-semibold text-gray-700">{order.id}</td>
                    <td className="px-5 py-3 font-medium text-gray-800 text-xs">{order.customer}</td>
                    <td className="px-5 py-3">
                      <span className="inline-flex items-center gap-1 bg-teal-50 text-teal-700 border border-teal-100 text-xs font-semibold px-2 py-0.5 rounded-full">
                        <Anchor size={9} />{order.port}
                      </span>
                    </td>
                    <td className="px-5 py-3 text-xs font-semibold text-gray-700">{order.qty.toLocaleString()}</td>
                    <td className="px-5 py-3">
                      <div className="flex items-center gap-2">
                        <div className="h-1.5 w-14 bg-gray-100 rounded-full overflow-hidden">
                          <div className="h-full bg-teal-500 rounded-full" style={{ width: `${pct}%` }} />
                        </div>
                        <span className="text-xs text-gray-500">{pct}%</span>
                      </div>
                    </td>
                    <td className="px-5 py-3">
                      <span className={`inline-flex items-center border text-xs font-semibold px-2 py-0.5 rounded-full ${s.cls}`}>
                        {s.label}
                      </span>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>
      </div>

    </div>
  );
}
