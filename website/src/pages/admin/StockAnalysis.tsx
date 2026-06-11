import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { AlertTriangle, Plus, ArrowUpRight, ArrowDownRight, RefreshCw, Layers } from 'lucide-react';
import type { StockItem } from '../../types';

const INITIAL_STOCK: StockItem[] = [
  { id: 'ST-001', name: 'Indonesian Coal (5500 GAR)', type: 'Thermal Coal', quantity: 3450, unit: 'MT', location: 'Warehouse A (Navlakhi)', lastUpdated: '2026-06-11 10:30', status: 'healthy' },
  { id: 'ST-002', name: 'South African Coal (6000 NAR)', type: 'Steam Coal', quantity: 2180, unit: 'MT', location: 'Warehouse B (Kandla)', lastUpdated: '2026-06-11 09:15', status: 'healthy' },
  { id: 'ST-003', name: 'US Coal (6800 NAR)', type: 'Coking Coal', quantity: 1240, unit: 'MT', location: 'Warehouse A (Navlakhi)', lastUpdated: '2026-06-10 16:45', status: 'low' },
  { id: 'ST-004', name: 'Russian Coal (6000 NAR)', type: 'Thermal Coal', quantity: 980, unit: 'MT', location: 'Warehouse C (Mundra)', lastUpdated: '2026-06-11 11:00', status: 'critical' },
  { id: 'ST-005', name: 'Indonesian Coal (3800 GAR)', type: 'Thermal Coal', quantity: 5120, unit: 'MT', location: 'Warehouse B (Kandla)', lastUpdated: '2026-06-11 08:00', status: 'healthy' },
];

const MOVEMENTS = [
  { id: 'MOV-901', product: 'Indonesian Coal (5500 GAR)', quantity: 1200, type: 'incoming', date: '2026-06-11 10:15', warehouse: 'Warehouse A (Navlakhi)' },
  { id: 'MOV-900', product: 'US Coal (6800 NAR)', quantity: 500, type: 'outgoing', date: '2026-06-11 09:30', warehouse: 'Warehouse A (Navlakhi)' },
  { id: 'MOV-899', product: 'South African Coal (6000 NAR)', quantity: 800, type: 'incoming', date: '2026-06-10 14:00', warehouse: 'Warehouse B (Kandla)' },
  { id: 'MOV-898', product: 'Russian Coal (6000 NAR)', quantity: 1500, type: 'outgoing', date: '2026-06-10 11:30', warehouse: 'Warehouse C (Mundra)' },
];

export default function AdminStockAnalysis() {
  const [stock] = useState<StockItem[]>(INITIAL_STOCK);

  const getStatusBadge = (status: StockItem['status']) => {
    switch (status) {
      case 'healthy':
        return <span className="badge-green">Healthy Stock</span>;
      case 'low':
        return <span className="badge-orange">Low Stock Alert</span>;
      case 'critical':
        return <span className="badge-red">Critical Alert</span>;
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Stock Analysis & Inventory" subtitle="Monitor current levels, warehouse distributions, and trace stock movements." />

      <div className="px-6 space-y-6">
        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><Layers size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Total Stock Available</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">12,970 MT</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-red-50 text-red-600 rounded-xl"><AlertTriangle size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Low Stock Alerts</span>
                <span className="text-xl font-bold text-red-600 mt-0.5">2 Coal Types</span>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="p-3 bg-orange-50 text-orange-600 rounded-xl"><RefreshCw size={20} /></div>
              <div>
                <span className="text-xs text-gray-500 font-medium block">Daily Turnover Volume</span>
                <span className="text-xl font-bold text-gray-900 mt-0.5">1,700 MT</span>
              </div>
            </div>
          </div>
        </div>

        {/* Stock Status Table */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex items-center justify-between mb-5">
            <h3 className="text-sm font-bold text-gray-800">Current Stock Levels</h3>
            <button className="btn-primary text-xs flex items-center gap-1.5 py-1.5 px-3">
              <Plus size={14} /> Add Stock Record
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Coal Name</th>
                  <th className="table-header py-3 px-4">Coal Type</th>
                  <th className="table-header py-3 px-4">Quantity (MT)</th>
                  <th className="table-header py-3 px-4">Warehouse Location</th>
                  <th className="table-header py-3 px-4">Last Updated</th>
                  <th className="table-header py-3 px-4 text-right">Status</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {stock.map(item => (
                  <tr key={item.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{item.name}</td>
                    <td className="table-cell text-gray-500">{item.type}</td>
                    <td className={`table-cell font-bold ${item.status === 'critical' ? 'text-red-600' : item.status === 'low' ? 'text-orange-600' : 'text-gray-900'}`}>
                      {item.quantity.toLocaleString()} MT
                    </td>
                    <td className="table-cell">{item.location}</td>
                    <td className="table-cell text-xs text-gray-400">{item.lastUpdated}</td>
                    <td className="table-cell text-right">{getStatusBadge(item.status)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Movements & Warehouses */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Movements list */}
          <div className="lg:col-span-2 bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">Recent Inventory Movement Logs</h3>
            <div className="divide-y divide-gray-50">
              {MOVEMENTS.map(mov => (
                <div key={mov.id} className="flex items-center justify-between py-3">
                  <div className="flex items-center gap-3">
                    <div className={`p-1.5 rounded-lg ${mov.type === 'incoming' ? 'bg-green-50 text-green-600' : 'bg-red-50 text-red-600'}`}>
                      {mov.type === 'incoming' ? <ArrowDownRight size={15} /> : <ArrowUpRight size={15} />}
                    </div>
                    <div>
                      <span className="text-xs font-semibold text-gray-800 block">{mov.product}</span>
                      <span className="text-[10px] text-gray-400 block mt-0.5">{mov.warehouse} • {mov.date}</span>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className={`text-xs font-bold block ${mov.type === 'incoming' ? 'text-green-600' : 'text-red-600'}`}>
                      {mov.type === 'incoming' ? '+' : '-'}{mov.quantity.toLocaleString()} MT
                    </span>
                    <span className="text-[9px] text-gray-300 font-medium block">{mov.id}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Warehouse summaries */}
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">Warehouse Stocks Summary</h3>
            <div className="space-y-4">
              {[
                { name: 'Warehouse A (Navlakhi)', cap: 10000, current: 4690, color: 'bg-orange-500' },
                { name: 'Warehouse B (Kandla)', cap: 15000, current: 7300, color: 'bg-amber-500' },
                { name: 'Warehouse C (Mundra)', cap: 8000, current: 980, color: 'bg-red-500' },
              ].map((wh, idx) => (
                <div key={idx} className="space-y-1.5">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-gray-800">{wh.name}</span>
                    <span className="text-gray-500 font-medium">{wh.current.toLocaleString()} / {wh.cap.toLocaleString()} MT</span>
                  </div>
                  <div className="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                    <div
                      className={`${wh.color} h-full rounded-full`}
                      style={{ width: `${(wh.current / wh.cap) * 100}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
