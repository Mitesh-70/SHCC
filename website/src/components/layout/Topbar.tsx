import { Bell, Calendar, Download } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';

interface TopbarProps {
  title?: string;
  subtitle?: string;
}

export default function Topbar({ title, subtitle }: TopbarProps) {
  const { user } = useAuth();

  const today = new Date();
  const fmt = (d: Date) => d.toLocaleDateString('en-IN', { month: 'short', day: 'numeric', year: 'numeric' });
  const weekAgo = new Date(today);
  weekAgo.setDate(weekAgo.getDate() - 6);
  const dateLabel = `${fmt(weekAgo)} – ${fmt(today)}`;

  const greeting = (() => {
    const h = new Date().getHours();
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  })();

  const displayTitle = title ?? `${greeting}, ${user?.name?.split(' ')[0] ?? 'User'}! 👋`;
  const displaySub = subtitle ?? "Here's what's happening with your business today.";

  return (
    <header className="flex items-start justify-between px-6 pt-6 pb-2">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">{displayTitle}</h1>
        <p className="text-sm text-gray-500 mt-0.5">{displaySub}</p>
      </div>
      <div className="flex items-center gap-3 flex-shrink-0">
        {/* Date Range */}
        <button className="flex items-center gap-2 border border-gray-200 bg-white rounded-lg px-3 py-2 text-sm text-gray-600 hover:bg-gray-50 transition-colors shadow-sm">
          <Calendar size={15} className="text-gray-400" />
          <span>{dateLabel}</span>
          <svg width="10" height="6" viewBox="0 0 10 6" fill="none" className="text-gray-400">
            <path d="M1 1l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" />
          </svg>
        </button>

        {/* Notifications */}
        <button className="relative border border-gray-200 bg-white rounded-lg p-2 text-gray-500 hover:bg-gray-50 transition-colors shadow-sm">
          <Bell size={18} />
          <span className="absolute -top-1 -right-1 bg-orange-500 text-white text-[9px] font-bold rounded-full w-4 h-4 flex items-center justify-center">2</span>
        </button>

        {/* Export */}
        <button className="flex items-center gap-2 bg-gray-900 hover:bg-gray-800 text-white rounded-lg px-4 py-2 text-sm font-medium transition-colors shadow-sm">
          <Download size={15} />
          Export Report
        </button>
      </div>
    </header>
  );
}
