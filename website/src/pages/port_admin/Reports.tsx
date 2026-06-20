import { useState } from 'react';
import { FileText, Download, Play, Truck, Package, Activity, CheckCircle2 } from 'lucide-react';
import { exportReport, type ReportKey, type ExportFormat } from '../../utils/reportExporter';

const REPORT_CATALOGUE = [
  {
    key: 'dispatch' as ReportKey,
    label: 'Dispatch & Operations',
    description: 'Vehicle dispatch logs, turnaround times, delivery completion, and driver records.',
    icon: Truck,
    color: 'text-orange-500',
    bg: 'bg-orange-50',
  },
  {
    key: 'inventory' as ReportKey,
    label: 'Inventory & Stock Movement',
    description: 'Port-wise coal stock levels, valuations, receipts, dispatches, and low-stock alerts.',
    icon: Package,
    color: 'text-blue-600',
    bg: 'bg-blue-50',
  },
  {
    key: 'orders' as ReportKey,
    label: 'Orders Lifecycle Metrics',
    description: 'Order pipeline status, approval/dispatch timelines, and fulfillment rate tracking.',
    icon: Activity,
    color: 'text-green-600',
    bg: 'bg-green-50',
  },
];

const RECENT_REPORTS = [
  { id: 'REP-8901', name: 'June 2026 Mundra Port Dispatch Log', type: 'Dispatch Report', generatedAt: '2026-06-20 09:00', size: '1.8 MB', format: 'PDF' },
  { id: 'REP-8900', name: 'Stock Valuation – All Ports (Jun 2026)', type: 'Inventory Report', generatedAt: '2026-06-18 11:30', size: '2.4 MB', format: 'Excel' },
  { id: 'REP-8899', name: 'Orders Lifecycle – June 2026 MTD', type: 'Ops Report', generatedAt: '2026-06-15 16:00', size: '990 KB', format: 'PDF' },
  { id: 'REP-8898', name: 'Dispatch Turnaround Analysis – May 2026', type: 'Dispatch Report', generatedAt: '2026-06-01 10:15', size: '1.3 MB', format: 'CSV' },
];

export default function PortAdminReports() {
  const [selectedReport, setSelectedReport] = useState<ReportKey>('dispatch');
  const [dateRange, setDateRange] = useState('this-month');
  const [format, setFormat] = useState<ExportFormat>('pdf');
  const [generating, setGenerating] = useState(false);
  const [generatedList, setGeneratedList] = useState(RECENT_REPORTS);

  const selectedMeta = REPORT_CATALOGUE.find(r => r.key === selectedReport)!;

  const handleGenerate = (e: React.FormEvent) => {
    e.preventDefault();
    setGenerating(true);
    setTimeout(() => {
      exportReport(selectedReport, format);
      const newReport = {
        id: `REP-${Math.floor(1000 + Math.random() * 9000)}`,
        name: `${selectedMeta.label} (${dateRange.replace(/-/g, ' ')})`,
        type: selectedMeta.label,
        generatedAt: new Date().toISOString().replace('T', ' ').slice(0, 16),
        size: `${(Math.random() * 3 + 0.6).toFixed(1)} MB`,
        format: format.toUpperCase(),
      };
      setGeneratedList(prev => [newReport, ...prev]);
      setGenerating(false);
    }, 1800);
  };

  const handleDownload = (rep: typeof RECENT_REPORTS[0]) => {
    const key = REPORT_CATALOGUE.find(r =>
      rep.type.toLowerCase().includes(r.key) ||
      (rep.type.toLowerCase().includes('dispatch') && r.key === 'dispatch') ||
      (rep.type.toLowerCase().includes('inventory') && r.key === 'inventory') ||
      (rep.type.toLowerCase().includes('ops') && r.key === 'orders')
    )?.key ?? selectedReport;
    exportReport(key, rep.format.toLowerCase() as ExportFormat);
  };

  const formatBadgeColor = (fmt: string) => {
    if (fmt === 'PDF') return 'bg-red-50 text-red-600';
    if (fmt === 'EXCEL') return 'bg-green-50 text-green-700';
    return 'bg-blue-50 text-blue-600';
  };

  return (
    <div className="bg-gray-50 min-h-screen p-6 pb-10">
      {/* Header */}
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">Port Operations Reports</h1>
        <p className="text-sm text-gray-500 mt-1">
          Generate dispatch logs, stock movement reports, and order lifecycle records for your port.
        </p>
      </div>

      <div className="space-y-6">
        {/* ── Catalogue ── */}
        <div>
          <h3 className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-3">Select Report Type</h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {REPORT_CATALOGUE.map(rep => {
              const Icon = rep.icon;
              const active = selectedReport === rep.key;
              return (
                <button
                  key={rep.key}
                  onClick={() => setSelectedReport(rep.key)}
                  className={`text-left p-4 rounded-xl border transition-all ${
                    active
                      ? 'bg-orange-500 border-orange-500 shadow-md shadow-orange-200'
                      : 'bg-white border-gray-100 hover:border-orange-200 hover:shadow-sm'
                  }`}
                >
                  <div className={`w-8 h-8 rounded-lg flex items-center justify-center mb-2.5 ${active ? 'bg-white/20' : rep.bg}`}>
                    <Icon size={16} className={active ? 'text-white' : rep.color} />
                  </div>
                  <p className={`text-sm font-bold leading-tight mb-1 ${active ? 'text-white' : 'text-gray-800'}`}>
                    {rep.label}
                  </p>
                  <p className={`text-[11px] leading-relaxed ${active ? 'text-orange-100' : 'text-gray-400'}`}>
                    {rep.description}
                  </p>
                  {active && (
                    <div className="flex items-center gap-1 mt-2 text-[10px] font-bold text-white">
                      <CheckCircle2 size={11} /> Selected
                    </div>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* ── Config ── */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-5 h-fit">
            <h3 className="text-sm font-bold text-gray-800 border-b border-gray-100 pb-3 mb-4">
              Export Configuration
            </h3>
            <form onSubmit={handleGenerate} className="space-y-4">
              <div className={`flex items-start gap-3 p-3 rounded-lg ${selectedMeta.bg}`}>
                <selectedMeta.icon size={15} className={`${selectedMeta.color} mt-0.5 flex-shrink-0`} />
                <div>
                  <p className="text-xs font-bold text-gray-800">{selectedMeta.label}</p>
                  <p className="text-[10px] text-gray-500 mt-0.5 leading-relaxed">{selectedMeta.description}</p>
                </div>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                  Time Interval
                </label>
                <select
                  value={dateRange}
                  onChange={e => setDateRange(e.target.value)}
                  className="w-full text-sm bg-gray-50 border border-gray-200 rounded-lg p-2.5 text-gray-700 outline-none focus:border-orange-300"
                >
                  <option value="this-month">This Month (June 2026)</option>
                  <option value="last-month">Last Month (May 2026)</option>
                  <option value="this-quarter">This Quarter (Q1 FY 2026-27)</option>
                  <option value="last-quarter">Last Quarter (Q4 FY 2025-26)</option>
                  <option value="this-financial-year">This Financial Year (FY 2026-27)</option>
                </select>
              </div>

              <div>
                <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                  File Format
                </label>
                <div className="grid grid-cols-3 gap-2">
                  {(['pdf', 'excel', 'csv'] as ExportFormat[]).map(f => (
                    <button
                      key={f}
                      type="button"
                      onClick={() => setFormat(f)}
                      className={`py-2 text-xs font-semibold rounded-lg border uppercase transition-all ${
                        format === f
                          ? 'bg-orange-500 text-white border-orange-500 shadow-sm'
                          : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'
                      }`}
                    >
                      {f}
                    </button>
                  ))}
                </div>
              </div>

              <button
                type="submit"
                disabled={generating}
                className="w-full flex items-center justify-center gap-2 bg-orange-500 hover:bg-orange-600 disabled:bg-orange-300 text-white font-semibold py-2.5 rounded-lg text-sm transition-colors shadow-sm"
              >
                {generating ? (
                  <>
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    <span>Generating…</span>
                  </>
                ) : (
                  <>
                    <Play size={14} />
                    <span>Generate & Download {format.toUpperCase()}</span>
                  </>
                )}
              </button>
            </form>
          </div>

          {/* ── History ── */}
          <div className="lg:col-span-2 bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-bold text-gray-800">Export History & Archives</h3>
              <span className="text-[10px] text-gray-400 bg-gray-50 px-2 py-1 rounded-full border border-gray-100">
                {generatedList.length} reports
              </span>
            </div>
            <div className="divide-y divide-gray-50">
              {generatedList.map(rep => (
                <div key={rep.id} className="flex items-center justify-between py-3.5 hover:bg-gray-50/20 px-2 rounded-lg transition-all">
                  <div className="flex items-center gap-3 min-w-0">
                    <div className="p-2 bg-orange-50 text-orange-600 rounded-lg flex-shrink-0">
                      <FileText size={16} />
                    </div>
                    <div className="min-w-0">
                      <span className="text-sm font-semibold text-gray-800 block leading-tight truncate">{rep.name}</span>
                      <span className="text-[10px] text-gray-400 block mt-0.5">
                        {rep.type} · {rep.generatedAt} · {rep.size}
                      </span>
                    </div>
                  </div>
                  <div className="flex items-center gap-2 flex-shrink-0 ml-3">
                    <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${formatBadgeColor(rep.format)}`}>
                      {rep.format}
                    </span>
                    <button
                      onClick={() => handleDownload(rep)}
                      className="p-1.5 border border-gray-200 hover:border-orange-200 text-gray-500 hover:text-orange-600 hover:bg-orange-50/50 rounded-lg transition-all"
                      title="Re-download"
                    >
                      <Download size={13} />
                    </button>
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
