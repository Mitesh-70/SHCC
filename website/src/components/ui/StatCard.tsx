import { ArrowUpRight, ArrowDownRight } from 'lucide-react';
import { SparklineChart } from '../charts/SparklineChart';

interface StatCardProps {
  icon: React.ReactNode;
  iconBg?: string;
  label: string;
  value: string;
  change: number;
  changeLabel?: string;
  sparkData: number[];
  sparkColor?: string;
}

export default function StatCard({
  icon,
  iconBg = 'bg-orange-50',
  label,
  value,
  change,
  changeLabel = 'from last week',
  sparkData,
  sparkColor = '#f97316',
}: StatCardProps) {
  const isPositive = change >= 0;

  return (
    <div className="bg-white rounded-xl p-6 shadow-card border border-gray-100 h-full flex flex-col relative group">
      {/* Main Content */}
      <div className="flex gap-4 flex-1">
        {/* Icon */}
        <div className={`${iconBg} p-3 rounded-lg flex-shrink-0 flex items-center justify-center w-12 h-12`}>
          {icon}
        </div>

        {/* Text Content */}
        <div className="flex-1 flex flex-col justify-start min-w-0">
          <p className="text-xs font-medium text-gray-500 uppercase tracking-wide">{label}</p>
          <h3 className="text-2xl font-bold text-gray-900 mt-1 leading-none">{value}</h3>
          <div className={`flex items-center gap-1.5 mt-2 text-xs font-medium ${isPositive ? 'text-green-600' : 'text-red-600'}`}>
            {isPositive ? <ArrowUpRight size={13} className="flex-shrink-0" /> : <ArrowDownRight size={13} className="flex-shrink-0" />}
            <span className="font-semibold">{Math.abs(change)}%</span>
            <span className="text-gray-400 font-normal">{changeLabel}</span>
          </div>
        </div>
      </div>

      {/* Chart positioned at bottom */}
      <div className="w-full h-12 mt-4 pt-4 border-t border-gray-100">
        <SparklineChart data={sparkData} color={sparkColor} />
      </div>
    </div>
  );
}
