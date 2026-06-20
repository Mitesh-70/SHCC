import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { AlertTriangle, Plus, ArrowUpRight, ArrowDownRight, RefreshCw, Layers, Edit2, X, Save } from 'lucide-react';
import type { StockItem } from '../../types';

const INITIAL_STOCK: StockItem[] = [
  { id: 'ST-001', name: 'Indonesian Coal (5500 GAR)', type: 'Thermal Coal', quantity: 3450, unit: 'MT', location: 'Warehouse A (Navlakhi)', lastUpdated: '2026-06-11 10:30', status: 'healthy' },
  { id: 'ST-002', name: 'South African Coal (6000 GAR)', type: 'Steam Coal', quantity: 2180, unit: 'MT', location: 'Warehouse B (Kandla)', lastUpdated: '2026-06-11 09:15', status: 'healthy' },
  { id: 'ST-003', name: 'US Coal (6800 GAR)', type: 'Coking Coal', quantity: 1240, unit: 'MT', location: 'Warehouse A (Navlakhi)', lastUpdated: '2026-06-10 16:45', status: 'low' },
  { id: 'ST-004', name: 'Russian Coal (6000 GAR)', type: 'Thermal Coal', quantity: 980, unit: 'MT', location: 'Warehouse C (Mundra)', lastUpdated: '2026-06-11 11:00', status: 'critical' },
  { id: 'ST-005', name: 'Indonesian Coal (3800 GAR)', type: 'Thermal Coal', quantity: 5120, unit: 'MT', location: 'Warehouse B (Kandla)', lastUpdated: '2026-06-11 08:00', status: 'healthy' },
];

const MOVEMENTS = [
  { id: 'MOV-901', product: 'Indonesian Coal (5500 GAR)', quantity: 1200, type: 'incoming', date: '2026-06-11 10:15', warehouse: 'Warehouse A (Navlakhi)' },
  { id: 'MOV-900', product: 'US Coal (6800 GAR)', quantity: 500, type: 'outgoing', date: '2026-06-11 09:30', warehouse: 'Warehouse A (Navlakhi)' },
  { id: 'MOV-899', product: 'South African Coal (6000 GAR)', quantity: 800, type: 'incoming', date: '2026-06-10 14:00', warehouse: 'Warehouse B (Kandla)' },
  { id: 'MOV-898', product: 'Russian Coal (6000 GAR)', quantity: 1500, type: 'outgoing', date: '2026-06-10 11:30', warehouse: 'Warehouse C (Mundra)' },
];

const WAREHOUSES = ['Warehouse A (Navlakhi)', 'Warehouse B (Kandla)', 'Warehouse C (Mundra)'];
const COAL_TYPES = ['Thermal Coal', 'Steam Coal', 'Coking Coal'];

const emptyForm = { name: '', type: 'Thermal Coal', quantity: 0, location: WAREHOUSES[0] };

export default function PortAdminStockAnalysis() {
  const [stock, setStock] = useState<StockItem[]>(INITIAL_STOCK);
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState<StockItem | null>(null);
  const [form, setForm] = useState<{ name: string; type: string; quantity: number; location: string }>(emptyForm);

  const [limits, setLimits] = useState<Record<string, { low: number, critical: number }>>({});

  const deriveStatus = (qty: number, name: string): StockItem['status'] => {
    const lim = limits[name] || { low: 1500, critical: 500 };
    if (qty <= lim.critical) return 'critical';
    if (qty <= lim.low) return 'low';
    return 'healthy';
  };

  const openAdd = () => {
    setEditingItem(null);
    setForm(emptyForm);
    setShowModal(true);
  };

  const openEdit = (item: StockItem) => {
    setEditingItem(item);
    setForm({ name: item.name, type: item.type, quantity: item.quantity, location: item.location });
    setShowModal(true);
  };

  const saveRecord = () => {
    const now = new Date().toISOString().slice(0, 16).replace('T', ' ');
    if (editingItem) {
      setStock(prev => prev.map(s =>
        s.id === editingItem.id
          ? { ...s, name: form.name, type: form.type, quantity: Number(form.quantity), location: form.location, status: deriveStatus(Number(form.quantity), form.name), lastUpdated: now }
          : s
      ));
    } else {
      const newId = `ST-${String(stock.length + 1).padStart(3, '0')}`;
      setStock(prev => [...prev, {
        id: newId,
        name: form.name,
        type: form.type,
        quantity: Number(form.quantity),
        unit: 'MT',
        location: form.location,
        lastUpdated: now,
        status: deriveStatus(Number(form.quantity), form.name),
      }]);
    }
    setShowModal(false);
  };

  const getStatusBadge = (status: StockItem['status']) => {
    switch (status) {
      case 'healthy': return <span className="badge-green">Healthy Stock</span>;
      case 'low':     return <span className="badge-orange">Low Stock Alert</span>;
      case 'critical': return <span className="badge-red">Critical Alert</span>;
    }
  };

  const totalStock = stock.reduce((s, i) => s + i.quantity, 0);
  const alertCount = stock.filter(i => deriveStatus(i.quantity, i.name) !== 'healthy').length;
  const uniqueCoalNames = Array.from(new Set(stock.map(s => s.name)));

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Stock Analysis & Inventory" subtitle="Monitor current levels, warehouse distributions, and trace stock movements." />

      <div className="px-6 space-y-6">
        {/* KPI Cards — no icon box border */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center gap-4">
            <div className="text-orange-500"><Layers size={22} /></div>
            <div>
              <span className="text-xs text-gray-500 font-medium block">Total Stock Available</span>
              <span className="text-xl font-bold text-gray-900 mt-0.5">{totalStock.toLocaleString()} MT</span>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center gap-4">
            <div className="text-red-500"><AlertTriangle size={22} /></div>
            <div>
              <span className="text-xs text-gray-500 font-medium block">Low Stock Alerts</span>
              <span className="text-xl font-bold text-red-600 mt-0.5">{alertCount} Coal {alertCount === 1 ? 'Type' : 'Types'}</span>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex items-center gap-4">
            <div className="text-orange-500"><RefreshCw size={22} /></div>
            <div>
              <span className="text-xs text-gray-500 font-medium block">Daily Turnover Volume</span>
              <span className="text-xl font-bold text-gray-900 mt-0.5">1,700 MT</span>
            </div>
          </div>
        </div>


        {/* Stock Status Table */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <div className="flex items-center justify-between mb-5">
            <h3 className="text-sm font-bold text-gray-800">Current Stock Levels</h3>
            <button onClick={openAdd} className="btn-primary text-xs flex items-center gap-1.5 py-1.5 px-3">
              <Plus size={14} /> Add Stock Record
            </button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-gray-100">
                  <th className="table-header py-3 px-4">Sr no</th>
                  <th className="table-header py-3 px-4">Coal Name</th>
                  <th className="table-header py-3 px-4">Coal Type</th>
                  <th className="table-header py-3 px-4">Quantity (MT)</th>
                  <th className="table-header py-3 px-4">Warehouse Location</th>
                  <th className="table-header py-3 px-4">Last Updated</th>
                  <th className="table-header py-3 px-4">Status</th>
                  <th className="table-header py-3 px-4 text-right">Edit</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {stock.map((item, idx) => {
                  const currentStatus = deriveStatus(item.quantity, item.name);
                  return (
                  <tr key={item.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="table-cell font-semibold text-gray-900">{idx + 1}</td>
                    <td className="table-cell font-semibold text-gray-900">{item.name}</td>
                    <td className="table-cell text-gray-500">{item.type}</td>
                    <td className={`table-cell font-bold ${currentStatus === 'critical' ? 'text-red-600' : currentStatus === 'low' ? 'text-orange-600' : 'text-gray-900'}`}>
                      {item.quantity.toLocaleString()} MT
                    </td>
                    <td className="table-cell">{item.location}</td>
                    <td className="table-cell text-xs text-gray-400">{item.lastUpdated}</td>
                    <td className="table-cell">{getStatusBadge(currentStatus)}</td>
                    <td className="table-cell text-right">
                      <button
                        onClick={() => openEdit(item)}
                        className="text-gray-400 hover:text-orange-500 p-1.5 hover:bg-orange-50 rounded-lg transition-all"
                        title="Edit Record"
                      >
                        <Edit2 size={14} />
                      </button>
                    </td>
                  </tr>
                )})}
              </tbody>
            </table>
          </div>
        </div>

        {/* Movements & Warehouses */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div className="lg:col-span-2 bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">Recent Inventory Movement Logs</h3>
            <div className="divide-y divide-gray-50">
              {MOVEMENTS.map(mov => (
                <div key={mov.id} className="flex items-center justify-between py-3">
                  <div className="flex items-center gap-3">
                    <div className={`p-1.5 rounded-lg ${mov.type === 'incoming' ? 'bg-green-50 text-green-600' : 'bg-red-50 text-red-600'}`}>
                      {mov.type === 'incoming' ? <ArrowUpRight size={15} /> : <ArrowDownRight size={15} />}
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

          <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">Warehouse Stocks Summary</h3>
            <div className="space-y-4">
              {[
                { name: 'Warehouse A (Navlakhi)', cap: 10000, current: stock.filter(s => s.location.includes('Navlakhi')).reduce((a, b) => a + b.quantity, 0), color: 'bg-orange-500' },
                { name: 'Warehouse B (Kandla)', cap: 15000, current: stock.filter(s => s.location.includes('Kandla')).reduce((a, b) => a + b.quantity, 0), color: 'bg-amber-500' },
                { name: 'Warehouse C (Mundra)', cap: 8000, current: stock.filter(s => s.location.includes('Mundra')).reduce((a, b) => a + b.quantity, 0), color: 'bg-red-500' },
              ].map((wh, idx) => (
                <div key={idx} className="space-y-1.5">
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-gray-800">{wh.name}</span>
                    <span className="text-gray-500 font-medium">{wh.current.toLocaleString()} / {wh.cap.toLocaleString()} MT</span>
                  </div>
                  <div className="w-full bg-gray-100 h-2 rounded-full overflow-hidden">
                    <div className={`${wh.color} h-full rounded-full`} style={{ width: `${Math.min(100, (wh.current / wh.cap) * 100)}%` }} />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Coal Name Alert Limits */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <h3 className="text-sm font-bold text-gray-800 mb-4">Alert Settings by Coal Name</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {uniqueCoalNames.map(name => (
              <div key={name} className="border border-gray-100 rounded-lg p-3 bg-gray-50/50">
                <span className="text-xs font-bold text-gray-700 block mb-2">{name}</span>
                <div className="flex items-center gap-2 mb-2">
                  <label className="text-[10px] font-semibold text-gray-500 w-12">Low:</label>
                  <input 
                    type="number" 
                    value={limits[name]?.low || 1500} 
                    onChange={e => setLimits(prev => ({ ...prev, [name]: { ...prev[name], low: Number(e.target.value) } }))}
                    className="text-xs border border-gray-200 rounded px-2 py-1 w-full outline-none focus:border-orange-300"
                  />
                </div>
                <div className="flex items-center gap-2">
                  <label className="text-[10px] font-semibold text-gray-500 w-12">Critical:</label>
                  <input 
                    type="number" 
                    value={limits[name]?.critical || 500} 
                    onChange={e => setLimits(prev => ({ ...prev, [name]: { ...prev[name], critical: Number(e.target.value) } }))}
                    className="text-xs border border-gray-200 rounded px-2 py-1 w-full outline-none focus:border-orange-300"
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Add / Edit Stock Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden">
            <div className="p-5 border-b border-gray-100 flex items-center justify-between bg-orange-50/40">
              <div>
                <h3 className="font-bold text-gray-900 text-base">{editingItem ? 'Edit Stock Record' : 'Add New Stock Record'}</h3>
                {editingItem && <p className="text-xs text-gray-400 mt-0.5">{editingItem.id}</p>}
              </div>
              <button onClick={() => setShowModal(false)} className="text-gray-400 hover:text-gray-600 p-1 hover:bg-gray-100 rounded-lg"><X size={18} /></button>
            </div>
            <div className="p-5 space-y-4">
              <div>
                <label className="text-xs font-semibold text-gray-700 block mb-1.5">Coal Name</label>
                <input
                  type="text"
                  value={form.name}
                  onChange={e => setForm(f => ({ ...f, name: e.target.value }))}
                  placeholder="e.g. Indonesian Coal (5500 GAR)"
                  className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-orange-200 focus:border-orange-400 transition-all"
                />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className="text-xs font-semibold text-gray-700 block mb-1.5">Coal Type</label>
                  <select
                    value={form.type}
                    onChange={e => setForm(f => ({ ...f, type: e.target.value }))}
                    className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-orange-200 focus:border-orange-400"
                  >
                    {COAL_TYPES.map(t => <option key={t}>{t}</option>)}
                  </select>
                </div>
                <div>
                  <label className="text-xs font-semibold text-gray-700 block mb-1.5">Quantity (MT)</label>
                  <input
                    type="number"
                    min={0}
                    value={form.quantity}
                    onChange={e => setForm(f => ({ ...f, quantity: Number(e.target.value) }))}
                    className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-orange-200 focus:border-orange-400 transition-all"
                  />
                </div>
              </div>
              <div>
                <label className="text-xs font-semibold text-gray-700 block mb-1.5">Warehouse Location</label>
                <select
                  value={form.location}
                  onChange={e => setForm(f => ({ ...f, location: e.target.value }))}
                  className="w-full border border-gray-200 rounded-xl px-3 py-2.5 text-sm text-gray-700 outline-none focus:ring-2 focus:ring-orange-200 focus:border-orange-400"
                >
                  {WAREHOUSES.map(w => <option key={w}>{w}</option>)}
                </select>
              </div>
              <p className="text-[10px] text-gray-400">Status is auto-calculated: &gt;1500 MT = Healthy, 500–1500 = Low, &lt;500 = Critical</p>
            </div>
            <div className="p-5 border-t border-gray-100 flex justify-end gap-3">
              <button onClick={() => setShowModal(false)} className="px-4 py-2 border border-gray-200 text-gray-600 rounded-lg text-xs font-semibold hover:bg-gray-50">Cancel</button>
              <button
                onClick={saveRecord}
                disabled={!form.name.trim()}
                className="px-4 py-2 bg-orange-500 hover:bg-orange-600 disabled:bg-orange-300 text-white rounded-lg text-xs font-bold transition-colors flex items-center gap-1.5"
              >
                <Save size={13} /> {editingItem ? 'Save Changes' : 'Add Record'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
