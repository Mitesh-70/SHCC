import React from 'react';
import Topbar from '../../components/layout/Topbar';
import { ResponsiveContainer, AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip } from 'recharts';
import { Target, Award, ShieldAlert, Sparkles } from 'lucide-react';

const DATA = [
  { month: 'Jan', revenue: 10, orders: 4 },
  { month: 'Feb', revenue: 8, orders: 3 },
  { month: 'Mar', revenue: 25, orders: 10 },
  { month: 'Apr', revenue: 15, orders: 6 },
  { month: 'May', revenue: 18, orders: 7 },
  { month: 'Jun', revenue: 20, orders: 8 },
];

export default function SalespersonSalesAnalysis() {
  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="My Sales Analysis" subtitle="Review your monthly revenue trends, closed deals, and quota achievement rates." />

      <div className="px-6 space-y-6">
        {/* KPI Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><Target size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Quarter Target</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">₹ 2.00 Cr</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><Award size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Closed Revenue (YTD)</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">₹ 1.85 Cr</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><Sparkles size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Conversion Rate</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">22.4%</span>
              </div>
            </div>
          </div>
        </div>

        {/* Chart */}
        <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
          <h3 className="text-sm font-bold text-gray-800">My Revenue Generation Log (₹ in Lakhs)</h3>
          <div className="w-full h-[250px]">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={DATA} margin={{ top: 10, right: 10, left: -10, bottom: 5 }}>
                <defs>
                  <linearGradient id="colorRev" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="#f97316" stopOpacity={0.2}/>
                    <stop offset="95%" stopColor="#f97316" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
                <XAxis dataKey="month" tick={{ fontSize: 11, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
                <YAxis tick={{ fontSize: 11, fill: '#9ca3af' }} axisLine={false} tickLine={false} />
                <Tooltip
                  contentStyle={{ borderRadius: 8, borderColor: '#f3f4f6', boxShadow: '0 4px 6px rgba(0,0,0,0.05)' }}
                  labelClassName="font-semibold text-gray-700 text-xs"
                />
                <Area type="monotone" dataKey="revenue" name="Revenue" stroke="#f97316" strokeWidth={2} fillOpacity={1} fill="url(#colorRev)" />
              </AreaChart>
            </ResponsiveContainer>
          </div>
        </div>
      </div>
    </div>
  );
}
