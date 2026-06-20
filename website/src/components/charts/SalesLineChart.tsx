import {
  ResponsiveContainer, LineChart, Line, XAxis, YAxis,
  CartesianGrid, Tooltip, Legend
} from 'recharts';

const CHART_DATA_BY_TIMEFRAME = {
  day: [
    { month: 'Mon', revenue: 0.6, orders: 15 },
    { month: 'Tue', revenue: 0.7, orders: 18 },
    { month: 'Wed', revenue: 0.65, orders: 16 },
    { month: 'Thu', revenue: 0.8, orders: 22 },
    { month: 'Fri', revenue: 0.75, orders: 20 },
    { month: 'Sat', revenue: 0.4, orders: 10 },
    { month: 'Sun', revenue: 0.3, orders: 8 },
  ],
  week: [
    { month: 'Week 1', revenue: 3.8, orders: 95 },
    { month: 'Week 2', revenue: 4.2, orders: 110 },
    { month: 'Week 3', revenue: 3.9, orders: 98 },
    { month: 'Week 4', revenue: 4.8, orders: 120 },
  ],
  month: [
    { month: 'Jan', revenue: 22, orders: 900 },
    { month: 'Feb', revenue: 20, orders: 750 },
    { month: 'Mar', revenue: 48, orders: 1400 },
    { month: 'Apr', revenue: 30, orders: 1100 },
    { month: 'May', revenue: 35, orders: 1050 },
    { month: 'Jun', revenue: 28, orders: 950 },
    { month: 'Jul', revenue: 32, orders: 1000 },
    { month: 'Aug', revenue: 45, orders: 1350 },
    { month: 'Sep', revenue: 48, orders: 1500 },
    { month: 'Oct', revenue: 38, orders: 1200 },
    { month: 'Nov', revenue: 40, orders: 1100 },
    { month: 'Dec', revenue: 43, orders: 1350 },
  ],
  year: [
    { month: '2022', revenue: 160, orders: 4200 },
    { month: '2023', revenue: 185, orders: 4800 },
    { month: '2024', revenue: 210, orders: 5300 },
    { month: '2025', revenue: 225, orders: 5700 },
    { month: '2026', revenue: 235, orders: 5900 },
  ],
};

const CustomTooltip = ({ active, payload, label }: any) => {
  if (active && payload && payload.length) {
    return (
      <div className="bg-white border border-gray-100 rounded-xl shadow-lg p-3 text-xs">
        <div className="font-semibold text-gray-700 mb-1.5">{label}</div>
        {payload.map((p: any) => (
          <div key={p.dataKey} className="flex items-center gap-2">
            <div className="w-2 h-2 rounded-full" style={{ background: p.color }} />
            <span className="text-gray-500">{p.name}:</span>
            <span className="font-medium text-gray-800">
              {p.dataKey === 'revenue' ? `₹${p.value} Cr` : p.value}
            </span>
          </div>
        ))}
      </div>
    );
  }
  return null;
};

interface SalesLineChartProps {
  timeframe?: 'day' | 'week' | 'month' | 'year';
  year?: 'This Year' | 'Last Year';
}

export default function SalesLineChart({ timeframe = 'week', year = 'This Year' }: SalesLineChartProps) {
  const baseData = CHART_DATA_BY_TIMEFRAME[timeframe] || CHART_DATA_BY_TIMEFRAME.week;
  const chartData = baseData.map((d, index) => {
    return {
      month: d.month,
      revenue: Math.round(d.revenue * (year === 'This Year' ? 1.0 : 0.78) * 10) / 10,
      orders: Math.round(d.orders * (year === 'This Year' ? 1.0 : 0.85)),
    };
  });

  return (
    <ResponsiveContainer width="100%" height="100%">
      <LineChart data={chartData} margin={{ top: 5, right: 40, left: 10, bottom: 5 }}>
        <defs>
          <linearGradient id="revenueGrad" x1="0" y1="0" x2="0" y2="1">
            <stop offset="5%" stopColor="#f97316" stopOpacity={0.15} />
            <stop offset="95%" stopColor="#f97316" stopOpacity={0} />
          </linearGradient>
        </defs>
        <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
        <XAxis
          dataKey="month"
          tick={{ fontSize: 11, fill: '#1e293b' }}
          axisLine={false}
          tickLine={false}
        />
        <YAxis
          yAxisId="left"
          tick={{ fontSize: 11, fill: '#1e293b' }}
          axisLine={false}
          tickLine={false}
          tickFormatter={v => `${v} Cr`}
          domain={[0, 'auto']}
        />
        <YAxis
          yAxisId="right"
          orientation="right"
          tick={{ fontSize: 11, fill: '#1e293b' }}
          axisLine={false}
          tickLine={false}
          domain={[0, 'auto']}
        />
        <Tooltip content={<CustomTooltip />} />
        <Legend
          iconType="circle"
          iconSize={8}
          formatter={(value) => <span className="text-xs text-gray-500">{value}</span>}
        />
        <Line
          yAxisId="left"
          type="monotone"
          dataKey="revenue"
          name="Revenue (₹)"
          stroke="#f97316"
          strokeWidth={2.5}
          dot={{ r: 4, fill: '#f97316', strokeWidth: 0 }}
          activeDot={{ r: 5 }}
        />
        <Line
          yAxisId="right"
          type="monotone"
          dataKey="orders"
          name="Orders"
          stroke="#d1d5db"
          strokeWidth={2}
          strokeDasharray="5 3"
          dot={{ r: 3.5, fill: '#d1d5db', strokeWidth: 0 }}
          activeDot={{ r: 4 }}
        />
      </LineChart>
    </ResponsiveContainer>
  );
}
