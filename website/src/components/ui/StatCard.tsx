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
      <div className="flex items-center gap-6 flex-1 py-1">
        {/* Icon */}
        <div className="flex-shrink-0 flex items-center justify-center text-orange-500 scale-[1.8] ml-2">
          {icon}
        </div>

        {/* Text Content */}
        <div className="flex-1 flex flex-col justify-start min-w-0">
          <p className="text-xs font-medium text-gray-500 uppercase tracking-wide">{label}</p>
          <h3 className={`font-bold text-gray-900 mt-1 leading-none whitespace-nowrap ${value.length > 10 ? 'text-lg sm:text-xl xl:text-2xl' : 'text-xl lg:text-2xl'}`}>{value}</h3>
          <div className={`flex items-center gap-1.5 mt-2 text-xs font-medium ${isPositive ? 'text-green-600' : 'text-red-600'}`}>
            {isPositive ? <ArrowUpRight size={13} className="flex-shrink-0" /> : <ArrowDownRight size={13} className="flex-shrink-0" />}
            <span className="font-semibold">{Math.abs(change)}%</span>
            <span className="text-gray-400 font-normal">{changeLabel}</span>
          </div>
        </div>
      </div>
    </div>
  );
}
