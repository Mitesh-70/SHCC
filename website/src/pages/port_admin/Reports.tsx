import { FileText } from 'lucide-react';

export default function PortAdminReports() {
  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold text-gray-900">Port Reports</h1>
      <p className="text-sm text-gray-500 mt-1">Reports scoped to your assigned ports — Mundra, Kandla, Hazira.</p>
      <div className="mt-8 flex flex-col items-center justify-center text-gray-300 gap-3">
        <FileText size={48} strokeWidth={1} />
        <p className="text-sm text-gray-400">Port-wise reports coming soon.</p>
      </div>
    </div>
  );
}
