import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import {
  FileText, Download, Play, DollarSign, Receipt,
  TrendingUp, BookOpen, Users, CheckCircle2,
} from 'lucide-react';
import { exportReport, type ReportKey, type ExportFormat } from '../../utils/reportExporter';

const REPORT_CATALOGUE = [
  {
    key: 'financial' as ReportKey,
    label: 'Financial Analysis & P&L',
    description: 'Gross revenue, COGS, EBITDA, net profit, operating expenses, and quarterly comparison.',
    icon: DollarSign,
    color: 'text-green-600',
    bg: 'bg-green-50',
  },
  {
    key: 'gst' as ReportKey,
    label: 'GST & Taxation Summary',
    description: 'GSTR-1 invoice register, IGST liability, ITC credit, and net GST payable.',
    icon: Receipt,
    color: 'text-purple-600',
    bg: 'bg-purple-50',
  },
  {
    key: 'revenue' as ReportKey,
    label: 'Revenue Stream Metrics',
    description: 'Coal sales revenue, freight recovery, channel-wise breakdown, and collection efficiency.',
    icon: TrendingUp,
    color: 'text-orange-500',
    bg: 'bg-orange-50',
  },
  {
    key: 'invoice' as ReportKey,
    label: 'Invoice Aging Register',
    description: 'Outstanding invoices grouped by aging buckets, overdue flags, and expected collection.',
    icon: BookOpen,
    color: 'text-amber-600',
    bg: 'bg-amber-50',
  },
  {
    key: 'credit' as ReportKey,
    label: 'Customer Credit Ledger',
    description: 'Customer-wise billing, payments received, outstanding balances, and credit limits.',
    icon: Users,
    color: 'text-rose-600',
    bg: 'bg-rose-50',
  },
];

const RECENT_REPORTS = [
  { id: 'REP-7721', name: 'FY 2026-27 Q1 GST Return Summary', type: 'GST Report', generatedAt: '2026-06-18 14:30', size: '1.4 MB', format: 'PDF' },
  { id: 'REP-7720', name: 'Q1 FY 2026-27 P&L Statement', type: 'Financial Report', generatedAt: '2026-06-15 11:15', size: '2.2 MB', format: 'Excel' },
  { id: 'REP-7718', name: 'Outstanding Payments & Invoice Aging', type: 'Invoice Report', generatedAt: '2026-06-10 09:00', size: '890 KB', format: 'Excel' },
  { id: 'REP-7717', name: 'Revenue Stream Breakdown – Q1', type: 'Revenue Report', generatedAt: '2026-06-08 15:20', size: '760 KB', format: 'PDF' },
  { id: 'REP-7716', name: 'Customer Credit Ledger – June 2026', type: 'Credit Report', generatedAt: '2026-06-05 10:00', size: '1.1 MB', format: 'CSV' },
];

export default function FinanceReports() {
  const [selectedReport, setSelectedReport] = useState<ReportKey>('financial');
  const [dateRange, setDateRange] = useState('this-quarter');
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
      rep.type.toLowerCase().includes('gst') && r.key === 'gst' ||
      rep.type.toLowerCase().includes('revenue') && r.key === 'revenue' ||
      rep.type.toLowerCase().includes('invoice') && r.key === 'invoice' ||
      rep.type.toLowerCase().includes('credit') && r.key === 'credit' ||
      rep.type.toLowerCase().includes('financial') && r.key === 'financial'
    )?.key ?? selectedReport;
    exportReport(key, rep.format.toLowerCase() as ExportFormat);
  };

  const formatBadgeColor = (fmt: string) => {
    if (fmt === 'PDF') return 'bg-red-50 text-red-600';
    if (fmt === 'EXCEL') return 'bg-green-50 text-green-700';
    return 'bg-blue-50 text-blue-600';
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar
        title="Finance Report Generator"
        subtitle="Compile GST returns, revenue summaries, P&L statements, invoice registers, and customer credit ledgers."
      />

      <div className="px-6 space-y-6">
        {/* ── Report Catalogue ── */}
        <div>
          <h3 className="text-xs font-bold text-gray-500 uppercase tracking-widest mb-3">
            Select Report Type
          </h3>
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-3">
            {REPORT_CATALOGUE.map(rep => {
              const Icon = rep.icon;
              const active = selectedReport === rep.key;
              return (
                <button
                  key={rep.key}
                  onClick={() => setSelectedReport(rep.key)}
                  className={`text-left p-3.5 rounded-xl border transition-all ${
                    active
                      ? 'bg-orange-500 border-orange-500 text-white shadow-md shadow-orange-200'
                      : 'bg-white border-gray-100 hover:border-orange-200 hover:shadow-sm'
                  }`}
                >
                  <div className={`w-7 h-7 rounded-lg flex items-center justify-center mb-2 ${active ? 'bg-white/20' : rep.bg}`}>
                    <Icon size={14} className={active ? 'text-white' : rep.color} />
                  </div>
                  <p className={`text-[11px] font-bold leading-tight mb-1 ${active ? 'text-white' : 'text-gray-800'}`}>
                    {rep.label}
                  </p>
                  <p className={`text-[10px] leading-relaxed ${active ? 'text-orange-100' : 'text-gray-400'}`}>
                    {rep.description}
                  </p>
                  {active && (
                    <div className="flex items-center gap-1 mt-1.5 text-[10px] font-bold text-white">
                      <CheckCircle2 size={10} /> Selected
                    </div>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* ── Config Panel ── */}
          <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
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
                  Date Range
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
                  Format
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
                    <span>Compiling Statement…</span>
                  </>
                ) : (
                  <>
                    <Play size={14} />
                    <span>Compile & Download {format.toUpperCase()}</span>
                  </>
                )}
              </button>
            </form>
          </div>

          {/* ── Export History ── */}
          <div className="lg:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-sm font-bold text-gray-800">Export History</h3>
              <span className="text-[10px] text-gray-400 bg-gray-50 px-2 py-1 rounded-full border border-gray-100">
                {generatedList.length} reports
              </span>
            </div>
            <div className="divide-y divide-gray-50">
              {generatedList.map(rep => (
                <div key={rep.id} className="flex items-center justify-between py-3.5 hover:bg-gray-50/30 px-2 rounded-lg transition-all">
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
