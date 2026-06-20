import Topbar from '../../components/layout/Topbar';
import {
  ResponsiveContainer, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, Legend, PieChart, Pie, Cell
} from 'recharts';
import { DollarSign, TrendingUp, Anchor, BarChart2 } from 'lucide-react';

const MONTHLY_COMPARISON = [
  { month: 'Jan', current: 22, previous: 18 },
  { month: 'Feb', current: 20, previous: 15 },
  { month: 'Mar', current: 48, previous: 35 },
  { month: 'Apr', current: 30, previous: 28 },
  { month: 'May', current: 35, previous: 30 },
  { month: 'Jun', current: 28, previous: 22 },
];

const PRODUCT_SALES = [
  { name: 'Indonesian Coal', value: 45, color: '#f97316' },
  { name: 'South African Coal', value: 25, color: '#fb923c' },
  { name: 'US Coal', value: 18, color: '#374151' },
  { name: 'Russian Coal', value: 12, color: '#9ca3af' },
];

const SALESPERSON_PERFORMANCE = [
  { name: 'Rahul Verma', sales: 18.5, orders: 420 },
  { name: 'Neha Sharma', sales: 15.2, orders: 350 },
  { name: 'Vikram Singh', sales: 12.8, orders: 280 },
  { name: 'Amit Patel', sales: 8.5, orders: 198 },
];

export default function AdminSalesAnalysis() {
  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Sales Analysis & Insights" subtitle="Track revenue trends, monthly comparisons, product performance, and team metrics." />

      <div className="px-6 space-y-6">
        {/* KPI Row */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div>
              <span className="text-xs text-gray-500 font-medium block">Total Revenue (YTD)</span>
              <span className="text-xl font-bold text-gray-900 mt-1 block">₹ 48.21 Cr</span>
              <span className="text-[10px] text-green-600 font-medium block mt-1">↑ 18.4% YoY Growth</span>
            </div>
            <div className="text-orange-500"><DollarSign size={22} /></div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div>
              <span className="text-xs text-gray-500 font-medium block">Average Deal Value</span>
              <span className="text-xl font-bold text-gray-900 mt-1 block">₹ 3.86 L</span>
              <span className="text-[10px] text-green-600 font-medium block mt-1">↑ 4.2% from last month</span>
            </div>
            <div className="text-orange-500"><TrendingUp size={22} /></div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div>
              <span className="text-xs text-gray-500 font-medium block">Top Port — Weight Delivered</span>
              <span className="text-sm font-semibold text-gray-400 mt-0.5 block">Mundra Port</span>
              <span className="text-xl font-bold text-gray-900 mt-0.5 block">86,400 MT</span>
              <span className="text-[10px] text-green-600 font-medium block mt-1">↑ 12.4% from last month</span>
            </div>
            <div className="text-orange-500"><Anchor size={22} /></div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div>
              <span className="text-xs text-gray-500 font-medium block">Top Port — Revenue Generated</span>
              <span className="text-sm font-semibold text-gray-400 mt-0.5 block">Mundra Port</span>
              <span className="text-xl font-bold text-gray-900 mt-0.5 block">₹ 22.8 Cr</span>
              <span className="text-[10px] text-green-600 font-medium block mt-1">↑ 9.8% from last month</span>
            </div>
            <div className="text-orange-500"><BarChart2 size={22} /></div>
          </div>
        </div>

        {/* Charts Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Monthly Comparison */}
          <div className="lg:col-span-2 bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">Monthly Sales Comparison (₹ in Cr)</h3>
            <div className="w-full h-[250px]">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={MONTHLY_COMPARISON} margin={{ top: 10, right: 10, left: -10, bottom: 5 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
                  <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
                  <YAxis tick={{ fontSize: 11, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
                  <Tooltip
                    contentStyle={{ borderRadius: 8, borderColor: '#f3f4f6', boxShadow: '0 4px 6px rgba(0,0,0,0.05)' }}
                    labelClassName="font-semibold text-gray-700 text-xs"
                    itemStyle={{ fontSize: 11 }}
                  />
                  <Legend iconType="circle" iconSize={8} formatter={v => <span className="text-xs text-gray-500">{v}</span>} />
                  <Bar dataKey="current" name="Current Year" fill="#f97316" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="previous" name="Previous Year" fill="#d1d5db" radius={[4, 4, 0, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Product Breakdown */}
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">Product-Wise Distribution</h3>
            <div className="w-full h-[180px] flex items-center justify-center">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Tooltip
                    contentStyle={{ borderRadius: 8, borderColor: '#f3f4f6', boxShadow: '0 4px 6px rgba(0,0,0,0.05)' }}
                    itemStyle={{ fontSize: 11 }}
                  />
                  <Pie
                    data={PRODUCT_SALES}
                    cx="50%"
                    cy="50%"
                    innerRadius={50}
                    outerRadius={70}
                    paddingAngle={3}
                    dataKey="value"
                  >
                    {PRODUCT_SALES.map((entry, idx) => (
                      <Cell key={idx} fill={entry.color} />
                    ))}
                  </Pie>
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div className="grid grid-cols-2 gap-2 mt-2">
              {PRODUCT_SALES.map((entry, idx) => (
                <div key={idx} className="flex items-center gap-1.5 text-xs text-gray-600">
                  <div className="w-2.5 h-2.5 rounded-full" style={{ backgroundColor: entry.color }} />
                  <span className="truncate">{entry.name} ({entry.value}%)</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Team performance */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <h3 className="text-sm font-bold text-gray-800 mb-4">Salesperson Performance Ranking</h3>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Sr no</th>
                  <th className="table-header py-3 px-4">Salesperson</th>
                  <th className="table-header py-3 px-4">Revenue Contribution</th>
                  <th className="table-header py-3 px-4">Orders Completed</th>
                  <th className="table-header py-3 px-4">Target Achievement</th>
                  <th className="table-header py-3 px-4 text-right">Efficiency Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {SALESPERSON_PERFORMANCE.map((sp, idx) => (
                  <tr key={idx} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{idx + 1}</td>
                    <td className="table-cell font-semibold text-gray-900">{sp.name}</td>
                    <td className="table-cell font-medium text-orange-600">₹{sp.sales} Cr</td>
                    <td className="table-cell">{sp.orders}</td>
                    <td className="table-cell">
                      <div className="w-full bg-gray-100 h-1.5 rounded-full overflow-hidden max-w-[120px]">
                        <div
                          className="bg-orange-500 h-full rounded-full"
                          style={{ width: `${Math.min(100, (sp.sales / 15) * 100)}%` }}
                        />
                      </div>
                    </td>
                    <td className="table-cell text-right">
                      <span className="badge-green">Exceeding Target</span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
