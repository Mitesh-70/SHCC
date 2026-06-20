import { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { FileText, Download, Play } from 'lucide-react';

const RECENT_REPORTS = [
  { id: 'REP-7731', name: 'Sales Pipeline (May)', type: 'Sales Data', generatedAt: '2026-06-11 10:15', size: '1.2 MB', format: 'PDF' },
  { id: 'REP-7730', name: 'Q1 Key Accounts Overview', type: 'Client Data', generatedAt: '2026-06-08 14:20', size: '2.4 MB', format: 'Excel' },
];

export default function SalespersonReports() {
  const [reportType, setReportType] = useState('sales');
  const [dateRange, setDateRange] = useState('this-month');
  const [format, setFormat] = useState('pdf');
  const [generating, setGenerating] = useState(false);
  const [generatedList, setGeneratedList] = useState(RECENT_REPORTS);

  const handleGenerate = (e: React.FormEvent) => {
    e.preventDefault();
    setGenerating(true);
    setTimeout(() => {
      setGenerating(false);
      const typeLabel = reportType === 'sales' ? 'Sales Data' : 'Client Data';
      const newReport = {
        id: `REP-${Math.floor(1000 + Math.random() * 9000)}`,
        name: `Generated ${typeLabel} Report (${dateRange.replace('-', ' ')})`,
        type: typeLabel,
        generatedAt: new Date().toISOString().replace('T', ' ').slice(0, 16),
        size: `${(Math.random() * 3 + 0.5).toFixed(1)} MB`,
        format: format.toUpperCase(),
      };
      setGeneratedList(prev => [newReport, ...prev]);
    }, 2000);
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="My Sales Reports" subtitle="Generate, schedule, export and view analytical reports for clients and sales data." />

      <div className="px-6 grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Report configuration form */}
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
          <h3 className="text-sm font-bold text-gray-800 border-b border-gray-100 pb-3 mb-4">Generate Custom Report</h3>
          <form onSubmit={handleGenerate} className="space-y-4">
            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                Report Module
              </label>
              <select
                value={reportType}
                onChange={e => setReportType(e.target.value)}
                className="w-full text-sm bg-gray-50 border border-gray-200 rounded-lg p-2.5 text-gray-700 outline-none"
              >
                <option value="sales">Sales & Revenue Data</option>
                <option value="clients">Client Data & Accounts</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                Time Interval
              </label>
              <select
                value={dateRange}
                onChange={e => setDateRange(e.target.value)}
                className="w-full text-sm bg-gray-50 border border-gray-200 rounded-lg p-2.5 text-gray-700 outline-none"
              >
                <option value="this-month">This Month</option>
                <option value="last-month">Last Month</option>
                <option value="this-quarter">This Quarter</option>
                <option value="last-quarter">Last Quarter</option>
                <option value="this-financial-year">This Financial Year</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                File Format
              </label>
              <div className="grid grid-cols-3 gap-2">
                {['pdf', 'excel', 'csv'].map(f => (
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
              className="w-full flex items-center justify-center gap-2 bg-orange-500 hover:bg-orange-600 disabled:bg-orange-300 text-white font-medium py-2.5 rounded-lg text-sm transition-colors shadow-sm"
            >
              {generating ? (
                <>
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                  <span>Generating Report...</span>
                </>
              ) : (
                <>
                  <Play size={14} />
                  <span>Start Report Generation</span>
                </>
              )}
            </button>
          </form>
        </div>

        {/* Generated report logs list */}
        <div className="lg:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <h3 className="text-sm font-bold text-gray-800 mb-4">Export History & Archives</h3>
          <div className="divide-y divide-gray-50">
            {generatedList.map(rep => (
              <div key={rep.id} className="flex items-center justify-between py-3.5 hover:bg-gray-50/20 px-2 rounded-lg transition-all">
                <div className="flex items-center gap-3">
                  <div className="p-2 bg-orange-50 text-orange-600 rounded-lg flex-shrink-0">
                    <FileText size={18} />
                  </div>
                  <div>
                    <span className="text-sm font-bold text-gray-800 block leading-tight">{rep.name}</span>
                    <span className="text-[10px] text-gray-400 block mt-1">
                      {rep.type} • {rep.generatedAt} • {rep.size}
                    </span>
                  </div>
                </div>

                <div className="flex items-center gap-3">
                  <span className={`text-[10px] font-bold uppercase px-2 py-0.5 rounded ${
                    rep.format === 'PDF' ? 'bg-red-50 text-red-600' : 'bg-green-50 text-green-600'
                  }`}>
                    {rep.format}
                  </span>
                  <button className="p-2 border border-gray-200 hover:border-orange-200 text-gray-500 hover:text-orange-600 hover:bg-orange-50/50 rounded-lg transition-all">
                    <Download size={14} />
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
