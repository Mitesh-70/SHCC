import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import StatCard from '../../components/ui/StatCard';
import SalesLineChart from '../../components/charts/SalesLineChart';
import { ShoppingCart, Landmark, AlertTriangle, Truck, CreditCard, ChevronRight, FileText, CheckCircle2 } from 'lucide-react';
import { Link } from 'react-router-dom';

export default function FinanceDashboard() {
  const [timeframe, setTimeframe] = useState<'day' | 'week' | 'month' | 'year'>('week');

  const TIMEFRAME_LABELS = {
    day: 'from yesterday',
    week: 'from last week',
    month: 'from last month',
    year: 'from last year',
  };

  const TIMEFRAME_CHANGES = {
    day: { c1: 2.1, c2: 1.5, c3: -1.2, c4: 2.4 },
    week: { c1: 25.4, c2: 18.2, c3: -4.5, c4: 8.7 },
    month: { c1: 34.2, c2: 28.5, c3: -12.4, c4: 15.6 },
    year: { c1: 145.0, c2: 112.5, c3: -25.4, c4: 42.1 }
  };

  const spark1 = [10, 15, 8, 20, 18, 25, 30];
  const spark2 = [5, 12, 10, 15, 20, 22, 28];
  const spark3 = [20, 25, 18, 30, 28, 32, 40];
  const spark4 = [8, 10, 9, 12, 11, 14, 16];

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

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Finance Dashboard" subtitle="Overview of company revenue streams, profit margins, invoice ledgers, and inventory valuation." />

      <div className="px-6 space-y-5">
        {/* Filters & Grid Layout */}
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-bold text-gray-800">Financial Overview</h2>
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
        {/* KPI Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard
            icon={<Landmark size={20} className="text-orange-500" />}
            label="Total Revenue"
            value={getVal("₹ 4.82 Cr")}
            change={TIMEFRAME_CHANGES[timeframe].c1}
            changeLabel={TIMEFRAME_LABELS[timeframe]}
            sparkData={spark2}
          />
          <StatCard
            icon={<CreditCard size={20} className="text-orange-500" />}
            label="Payments Received"
            value={getVal("₹ 3.62 Cr")}
            change={TIMEFRAME_CHANGES[timeframe].c2}
            changeLabel={TIMEFRAME_LABELS[timeframe]}
            sparkData={spark1}
          />
          <StatCard
            icon={<AlertTriangle size={20} className="text-red-500" />}
            iconBg="bg-red-50"
            label="Pending Invoices"
            value={getVal("₹ 1.20 Cr")}
            change={TIMEFRAME_CHANGES[timeframe].c3}
            changeLabel={TIMEFRAME_LABELS[timeframe]}
            sparkData={spark3}
            sparkColor="#ef4444"
          />
          <StatCard
            icon={<ShoppingCart size={20} className="text-orange-500" />}
            label="Active Orders"
            value={getVal("1,248")}
            change={TIMEFRAME_CHANGES[timeframe].c4}
            changeLabel={TIMEFRAME_LABELS[timeframe]}
            sparkData={spark4}
          />
        </div>

        {/* Lower layout split */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
          {/* Revenue and sales Line chart */}
          <div className="lg:col-span-2 bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <div className="flex items-center justify-between">
              <h3 className="text-sm font-bold text-gray-800">
                {timeframe === 'day' ? 'Daily' : timeframe === 'week' ? 'Weekly' : timeframe === 'month' ? 'Monthly' : 'Yearly'} Revenue & Billing
              </h3>
            </div>
             <div className="grid grid-cols-3 gap-4 border-b border-gray-100 pb-4">
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Billing</span>
                <span className="text-lg font-bold text-gray-900">{getVal("₹ 48.21 Cr")}</span>
                <span className="text-[10px] text-green-600 font-medium block mt-0.5">↑ {TIMEFRAME_CHANGES[timeframe].c1}% vs {TIMEFRAME_LABELS[timeframe].replace('from ', '')}</span>
              </div>
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Total Profit Margin</span>
                <span className="text-lg font-bold text-gray-900">{getVal("₹ 9.64 Cr")} (20%)</span>
                <span className="text-[10px] text-green-600 font-medium block mt-0.5">↑ {TIMEFRAME_CHANGES[timeframe].c2}% {TIMEFRAME_LABELS[timeframe]}</span>
              </div>
              <div>
                <span className="text-[10px] font-semibold text-gray-400 uppercase block">Receivables Ratio</span>
                <span className="text-lg font-bold text-green-600">75.1% Cleared</span>
                <span className="text-[10px] text-gray-400 font-medium block mt-0.5">Of outstanding invoices</span>
              </div>
            </div>
            <div className="w-full flex-1 min-h-[220px]">
              <SalesLineChart timeframe={timeframe} />
            </div>
          </div>

          {/* Right Panels (Finance context) */}
          <div className="space-y-4">
            {/* Outstanding Balances */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Outstanding Accounts</h3>
                <Link to="/finance/customers" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>
              <div className="space-y-2">
                {[
                  { name: 'Vedanta Aluminium', bal: '₹56.00 L', status: 'CRITICAL' },
                  { name: 'Adani Power Ltd', bal: '₹45.00 L', status: 'WARN' },
                  { name: 'Ultratech Cement', bal: '₹18.00 L', status: 'INFO' },
                  { name: 'Tata Power Company', bal: '₹12.00 L', status: 'INFO' },
                ].map((acc, idx) => (
                  <div key={idx} className="flex items-center justify-between text-xs py-1 border-b border-gray-50 last:border-0 pb-1.5 last:pb-0">
                    <div>
                      <span className="font-semibold text-gray-700 block">{acc.name}</span>
                      <span className={`text-[8px] font-bold px-1 py-0.2 rounded mt-0.5 inline-block ${
                        acc.status === 'CRITICAL' ? 'bg-red-50 text-red-600' : acc.status === 'WARN' ? 'bg-orange-50 text-orange-600' : 'bg-gray-100 text-gray-500'
                      }`}>{acc.status}</span>
                    </div>
                    <span className="font-bold text-red-500">{acc.bal}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Inventory Cost & Valuation */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Stock Valuation summary</h3>
                <Link to="/finance/stock-analysis" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>
              <div className="space-y-2">
                {[
                  { name: 'Indonesian Coal (5500 GAR)', val: '₹18.97 Cr', qty: '3,450 MT' },
                  { name: 'South African Coal (6000 NAR)', val: '₹14.17 Cr', qty: '2,180 MT' },
                  { name: 'US Coal (6800 NAR)', val: '₹9.92 Cr', qty: '1,240 MT' },
                  { name: 'Russian Coal (6000 NAR)', val: '₹6.37 Cr', qty: '980 MT' },
                ].map((st, idx) => (
                  <div key={idx} className="flex items-center justify-between text-xs py-1">
                    <div>
                      <span className="font-semibold text-gray-700 block">{st.name}</span>
                      <span className="text-[9px] text-gray-400">{st.qty} in inventory</span>
                    </div>
                    <span className="font-bold text-orange-600">{st.val}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
