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
    <div className="bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-3">
      <div className="flex items-start justify-between">
        <div className="flex items-start gap-3">
          <div className={`${iconBg} p-2.5 rounded-xl flex-shrink-0`}>{icon}</div>
          <div>
            <div className="text-xs text-gray-500 font-medium">{label}</div>
            <div className="text-2xl font-bold text-gray-900 mt-0.5 leading-tight">{value}</div>
            <div className={`flex items-center gap-1 mt-1 text-xs font-medium ${isPositive ? 'text-green-600' : 'text-red-500'}`}>
              {isPositive ? <ArrowUpRight size={12} /> : <ArrowDownRight size={12} />}
              <span>{Math.abs(change)}%</span>
              <span className="text-gray-400 font-normal">{changeLabel}</span>
            </div>
          </div>
        </div>
        <div className="w-24 h-14 flex-shrink-0">
          <SparklineChart data={sparkData} color={sparkColor} />
        </div>
      </div>
    </div>
  );
}
