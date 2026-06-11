import {
  ResponsiveContainer, LineChart, Line, XAxis, YAxis,
  CartesianGrid, Tooltip, Legend
} from 'recharts';

const DATA = [
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
];

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

export default function SalesLineChart() {
  return (
    <ResponsiveContainer width="100%" height={220}>
      <LineChart data={DATA} margin={{ top: 5, right: 40, left: 10, bottom: 5 }}>
        <defs>
          <linearGradient id="revenueGrad" x1="0" y1="0" x2="0" y2="1">
            <stop offset="5%" stopColor="#f97316" stopOpacity={0.15} />
            <stop offset="95%" stopColor="#f97316" stopOpacity={0} />
          </linearGradient>
        </defs>
        <CartesianGrid strokeDasharray="3 3" stroke="#f3f4f6" vertical={false} />
        <XAxis
          dataKey="month"
          tick={{ fontSize: 11, fill: '#9ca3af' }}
          axisLine={false}
          tickLine={false}
        />
        <YAxis
          yAxisId="left"
          tick={{ fontSize: 11, fill: '#9ca3af' }}
          axisLine={false}
          tickLine={false}
          tickFormatter={v => `${v} Cr`}
          domain={[0, 60]}
        />
        <YAxis
          yAxisId="right"
          orientation="right"
          tick={{ fontSize: 11, fill: '#9ca3af' }}
          axisLine={false}
          tickLine={false}
          domain={[0, 1800]}
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
