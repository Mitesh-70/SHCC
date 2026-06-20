import React from 'react';
import Topbar from '../../components/layout/Topbar';
import { Landmark, Layers, ArrowUpRight, ArrowDownRight } from 'lucide-react';

const STOCK_ITEMS = [
  { name: 'Indonesian Coal (5500 GAR)', type: 'Thermal Coal', quantity: 3450, valuation: 189700000, rate: 5500, status: 'healthy' },
  { name: 'South African Coal (6000 GAR)', type: 'Steam Coal', quantity: 2180, valuation: 141700000, rate: 6500, status: 'healthy' },
  { name: 'US Coal (6800 GAR)', type: 'Coking Coal', quantity: 1240, valuation: 99200000, rate: 8000, status: 'low' },
  { name: 'Russian Coal (6000 GAR)', type: 'Thermal Coal', quantity: 980, valuation: 63700000, rate: 6500, status: 'critical' },
];

export default function FinanceStockAnalysis() {
  const totalValuation = STOCK_ITEMS.reduce((sum, item) => sum + item.valuation, 0);
  const totalQty = STOCK_ITEMS.reduce((sum, item) => sum + item.quantity, 0);

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Finance Stock & Inventory Valuation" subtitle="Assess current assets value, track unit rates, and oversee inventory capital." />

      <div className="px-6 space-y-6">
        {/* Summary Row */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><Landmark size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Total Stock Valuation</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">₹{(totalValuation / 10000000).toFixed(2)} Cr</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><Layers size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Total Quantity On Hand</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">{totalQty.toLocaleString()} MT</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><ArrowUpRight size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Avg Coal Cost / MT</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">₹6,125</span>
              </div>
            </div>
          </div>
        </div>

        {/* Inventory list */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <h3 className="text-sm font-bold text-gray-800 mb-4">Stock Valuation Ledger</h3>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Sr no</th>
                  <th className="table-header py-3 px-4">Coal Specification</th>
                  <th className="table-header py-3 px-4">Category</th>
                  <th className="table-header py-3 px-4">Quantity On Hand</th>
                  <th className="table-header py-3 px-4">Valuation Rate (per MT)</th>
                  <th className="table-header py-3 px-4 text-right">Total Net Asset Value</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {STOCK_ITEMS.map((item, idx) => (
                  <tr key={idx} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{idx + 1}</td>
                    <td className="table-cell font-semibold text-gray-900">{item.name}</td>
                    <td className="table-cell text-gray-500">{item.type}</td>
                    <td className="table-cell font-bold text-gray-900">{item.quantity.toLocaleString()} MT</td>
                    <td className="table-cell font-medium text-gray-700">₹{item.rate.toLocaleString()} / MT</td>
                    <td className="table-cell text-right font-bold text-orange-600">₹{(item.valuation / 10000000).toFixed(2)} Cr</td>
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
