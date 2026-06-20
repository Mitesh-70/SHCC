import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import StatCard from '../../components/ui/StatCard';
import SalesLineChart from '../../components/charts/SalesLineChart';
import {
  ShoppingCart, FileText, AlertTriangle, Truck, CheckCircle2,
  Package, UserCheck, ChevronRight
} from 'lucide-react';
import { Link } from 'react-router-dom';

export default function AdminDashboard() {
  const [timeframe, setTimeframe] = useState<'day' | 'week' | 'month' | 'year'>('week');
  const [selectedYear, setSelectedYear] = useState<'This Year' | 'Last Year'>('This Year');

  const getVal = (valStr: string) => {
    const cleanStr = valStr.replace(/₹|Cr|MT| |,/g, '');
    const numeric = parseFloat(cleanStr);
    if (isNaN(numeric)) return valStr;
    const multipliers = {
      day: 0.15,
      week: 1.0,
      month: 4.2,
      year: 52.0,
    };
    const scaledVal = numeric * multipliers[timeframe];
    
    if (valStr.includes('Cr')) {
      return `₹ ${scaledVal.toFixed(2)} Cr`;
    } else if (valStr.includes('MT')) {
      return `${Math.round(scaledVal).toLocaleString()} MT`;
    } else if (valStr.includes('₹')) {
      return `₹ ${scaledVal.toFixed(2)} Cr`;
    } else {
      return Math.round(scaledVal).toLocaleString();
    }
  };

  const totalRevenue = selectedYear === 'This Year' ? '48.21' : (48.21 * 0.82).toFixed(2);
  const totalOrders = selectedYear === 'This Year' ? '1,248' : Math.round(1248 * 0.85).toLocaleString();
  const salesGrowth = selectedYear === 'This Year' ? '18.4%' : '15.1%';

  const spark1 = [10, 15, 8, 20, 18, 25, 30];
  const spark2 = [5, 12, 10, 15, 20, 22, 28];
  const spark3 = [12, 11, 15, 14, 18, 17, 21];
  const spark4 = [8, 10, 9, 12, 11, 14, 16];

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar />

      <div className="px-6 space-y-5">
        {/* Banner removed per request */}

        {/* Filters & Grid Layout */}
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-bold text-gray-800">Business Performance</h2>
          <div className="flex bg-white rounded-lg p-0.5 border border-gray-100 shadow-sm">
            {(['day', 'week', 'month', 'year'] as const).map(tf => (
              <button
                key={tf}
                onClick={() => setTimeframe(tf)}
                className={`text-[11px] font-semibold px-3 py-1 rounded-md capitalize transition-all ${
                  timeframe === tf ? 'bg-orange-500 text-white shadow-sm' : 'text-gray-500 hover:text-gray-800'
                }`}
              >
                {tf}
              </button>
            ))}
          </div>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard
            icon={<ShoppingCart size={20} className="text-orange-500" />}
            label="Total Orders"
            value={getVal("1,248")}
            change={18.2}
            sparkData={spark1}
          />
          <StatCard
            icon={<span className="text-orange-600 font-bold text-lg leading-none">₹</span>}
            label="Total Revenue"
            value={getVal("₹ 4.82 Cr")}
            change={25.4}
            sparkData={spark2}
          />
          <StatCard
            icon={<Package size={20} className="text-gray-700" />}
            iconBg="bg-gray-100"
            label="Coal Sold (MT)"
            value={getVal("8,745 MT")}
            change={14.7}
            sparkData={spark3}
            sparkColor="#374151"
          />
          <StatCard
            icon={<UserCheck size={20} className="text-orange-500" />}
            label="Active Customers"
            value={getVal("356")}
            change={8.7}
            sparkData={spark4}
          />
        </div>

        {/* Lower Grid (Chart + Side panels) */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
          {/* Main Chart Card */}
          <div className="lg:col-span-2 bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-bold text-gray-800">Monthly Sales Performance</h3>
              <select 
                value={selectedYear}
                onChange={(e) => setSelectedYear(e.target.value as any)}
                className="text-xs bg-gray-50 border border-gray-200 rounded-lg px-2.5 py-1.5 font-medium text-gray-600 outline-none cursor-pointer"
              >
                <option value="This Year">This Year</option>
                <option value="Last Year">Last Year</option>
              </select>
            </div>

            {/* Performance Mini-Stats */}
            <div className="grid grid-cols-3 gap-4 border-b border-gray-100 pb-4">
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Revenue</span>
                <span className="text-lg font-bold text-gray-900">₹ {totalRevenue} Cr</span>
                <span className="text-[10px] text-green-600 font-medium block mt-0.5">↑ 18.4% vs last year</span>
              </div>
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Orders</span>
                <span className="text-lg font-bold text-gray-900">{totalOrders}</span>
                <span className="text-[10px] text-green-600 font-medium block mt-0.5">↑ 16.2% vs last year</span>
              </div>
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Sales Growth</span>
                <span className="text-lg font-bold text-gray-900">{salesGrowth}</span>
                <span className="text-[10px] text-green-600 font-medium block mt-0.5">↑ 2.6% vs last year</span>
              </div>
            </div>

            <div className="w-full flex-1 min-h-[220px]">
              <SalesLineChart timeframe={timeframe} year={selectedYear} />
            </div>
          </div>

          {/* Right Panels container */}
          <div className="space-y-4">
            {/* Business Alerts */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Business Alerts</h3>
                <Link to="/admin/settings" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>

              <div className="space-y-2.5">
                <div className="flex items-center justify-between p-2.5 bg-orange-50/50 hover:bg-orange-50 border border-orange-100/30 rounded-lg cursor-pointer transition-all">
                  <div className="flex items-center gap-3">
                    <div className="p-1.5 bg-orange-100 rounded-lg text-orange-600">
                      <Truck size={15} />
                    </div>
                    <div>
                      <span className="text-xs font-bold text-gray-800 block">12 Deliveries pending</span>
                      <span className="text-[10px] text-gray-400">Expected within next 2 days</span>
                    </div>
                  </div>
                  <ChevronRight size={12} className="text-gray-400" />
                </div>

                <div className="flex items-center justify-between p-2.5 bg-orange-50/50 hover:bg-orange-50 border border-orange-100/30 rounded-lg cursor-pointer transition-all">
                  <div className="flex items-center gap-3">
                    <div className="p-1.5 bg-orange-100 rounded-lg text-orange-600">
                      <AlertTriangle size={15} />
                    </div>
                    <div>
                      <span className="text-xs font-bold text-gray-800 block">Low stock alert</span>
                      <span className="text-[10px] text-gray-400">3 coal types are low in stock</span>
                    </div>
                  </div>
                  <ChevronRight size={12} className="text-gray-400" />
                </div>

                <div className="flex items-center justify-between p-2.5 bg-orange-50/50 hover:bg-orange-50 border border-orange-100/30 rounded-lg cursor-pointer transition-all">
                  <div className="flex items-center gap-3">
                    <div className="p-1.5 bg-orange-100 rounded-lg text-orange-600">
                      <FileText size={15} />
                    </div>
                    <div>
                      <span className="text-xs font-bold text-gray-800 block">8 Orders awaiting approval</span>
                      <span className="text-[10px] text-gray-400">Requires your attention</span>
                    </div>
                  </div>
                  <ChevronRight size={12} className="text-gray-400" />
                </div>
              </div>
            </div>

            {/* Stock Summary */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Stock Summary</h3>
                <Link to="/admin/stock-analysis" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>

              <div className="space-y-2">
                {[
                  { name: 'Indonesian Coal', qty: '3,450 MT' },
                  { name: 'South African Coal', qty: '2,180 MT' },
                  { name: 'US Coal', qty: '1,240 MT' },
                  { name: 'Russian Coal', qty: '980 MT' },
                ].map((s, idx) => (
                  <div key={idx} className="flex items-center justify-between text-xs py-1">
                    <span className="font-medium text-gray-600">{s.name}</span>
                    <span className="font-bold text-orange-600 bg-orange-50 px-2 py-0.5 rounded">{s.qty}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Recent Activities */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Recent Activities</h3>
                <Link to="/admin/notifications" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>

              <div className="space-y-3.5">
                <div className="flex items-start gap-3">
                  <div className="p-1 bg-green-50 rounded-full text-green-600 mt-0.5">
                    <CheckCircle2 size={13} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-gray-700 font-medium">Order #SHCC-1248 approved</p>
                    <span className="text-[10px] text-gray-400">10 mins ago</span>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="p-1 bg-blue-50 rounded-full text-blue-600 mt-0.5">
                    <Package size={13} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-gray-700 font-medium">Stock updated for Indonesian Coal</p>
                    <span className="text-[10px] text-gray-400">25 mins ago</span>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="p-1 bg-orange-50 rounded-full text-orange-600 mt-0.5">
                    <FileText size={13} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-gray-700 font-medium">Sales report generated</p>
                    <span className="text-[10px] text-gray-400">45 mins ago</span>
                  </div>
                </div>

                <div className="flex items-start gap-3">
                  <div className="p-1 bg-purple-50 rounded-full text-purple-600 mt-0.5">
                    <UserCheck size={13} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-xs text-gray-700 font-medium">User permission granted: Rahul Verma</p>
                    <span className="text-[10px] text-gray-400">1 hr ago</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
