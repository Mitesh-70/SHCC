import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { FileText, Download, Play } from 'lucide-react';

const RECENT_REPORTS = [
  { id: 'REP-7721', name: 'FY 2026 GST Return Summary', type: 'GST Report', generatedAt: '2026-06-11 14:30', size: '1.2 MB', format: 'PDF' },
  { id: 'REP-7720', name: 'May 2026 Consolidated Sales Report', type: 'Sales Report', generatedAt: '2026-06-10 11:15', size: '4.8 MB', format: 'Excel' },
  { id: 'REP-7718', name: 'Q1 Outstanding Payments Analysis', type: 'Financial Report', generatedAt: '2026-06-05 09:00', size: '890 KB', format: 'Excel' },
];

export default function FinanceReports() {
  const [reportType, setReportType] = useState('financial');
  const [dateRange, setDateRange] = useState('this-month');
  const [format, setFormat] = useState('pdf');
  const [generating, setGenerating] = useState(false);
  const [generatedList, setGeneratedList] = useState(RECENT_REPORTS);

  const handleGenerate = (e: React.FormEvent) => {
    e.preventDefault();
    setGenerating(true);
    setTimeout(() => {
      setGenerating(false);
      const newReport = {
        id: `REP-${Math.floor(1000 + Math.random() * 9000)}`,
        name: `Generated ${reportType.charAt(0).toUpperCase() + reportType.slice(reportType.length > 3 ? 1 : 0)} Report (${dateRange.replace('-', ' ')})`,
        type: `${reportType.charAt(0).toUpperCase() + reportType.slice(1)} Report`,
        generatedAt: new Date().toISOString().replace('T', ' ').slice(0, 16),
        size: `${(Math.random() * 5 + 0.5).toFixed(1)} MB`,
        format: format.toUpperCase(),
      };
      setGeneratedList(prev => [newReport, ...prev]);
    }, 2000);
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Finance Report Generator" subtitle="Compile GST returns, revenue summaries, invoice registers, and credit ledgers." />

      <div className="px-6 grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 h-fit">
          <h3 className="text-sm font-bold text-gray-800 border-b border-gray-100 pb-3 mb-4">Generate Finance Report</h3>
          <form onSubmit={handleGenerate} className="space-y-4">
            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                Report Type
              </label>
              <select
                value={reportType}
                onChange={e => setReportType(e.target.value)}
                className="w-full text-sm bg-gray-50 border border-gray-200 rounded-lg p-2.5 text-gray-700 outline-none"
              >
                <option value="financial">Financial Analysis & Profit/Loss</option>
                <option value="gst">GST & Taxation Summary</option>
                <option value="revenue">Revenue Stream Metrics</option>
                <option value="invoice">Invoice Aging Register</option>
                <option value="credit">Customer Credit Ledger</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                Date Range
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
                Format
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
                  <span>Compiling Ledger...</span>
                </>
              ) : (
                <>
                  <Play size={14} />
                  <span>Compile Statement</span>
                </>
              )}
            </button>
          </form>
        </div>

        <div className="lg:col-span-2 bg-white rounded-xl shadow-card border border-gray-100 p-5">
          <h3 className="text-sm font-bold text-gray-800 mb-4">Export History</h3>
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
