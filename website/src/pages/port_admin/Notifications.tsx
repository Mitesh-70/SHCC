import { Bell } from 'lucide-react';

const NOTIFICATIONS = [
  { id: 1, message: 'Order #ORD-2241 has been approved. You can now proceed with dispatch.', time: '2 hours ago',  read: false },
  { id: 2, message: 'Order #ORD-2238 — Admin has been notified of the hold.',               time: '4 hours ago',  read: false },
  { id: 3, message: 'Order #ORD-2230 has been approved. You can now proceed with dispatch.', time: 'Yesterday',    read: true  },
  { id: 4, message: 'Dispatch update for Order #ORD-2225 confirmed as completed.',           time: '2 days ago',   read: true  },
];

export default function PortAdminNotifications() {
  return (
    <div className="p-6 space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Notifications</h1>
          <p className="text-sm text-gray-500 mt-0.5">Updates about your port orders and dispatch actions.</p>
        </div>
        <span className="bg-orange-50 text-orange-700 border border-orange-200 text-xs font-bold px-2.5 py-1 rounded-full">
          {NOTIFICATIONS.filter(n => !n.read).length} unread
        </span>
      </div>

      <div className="space-y-3">
        {NOTIFICATIONS.map(n => (
          <div
            key={n.id}
            className={`flex items-start gap-3 p-4 rounded-xl border transition-colors ${
              n.read ? 'bg-white border-gray-100' : 'bg-orange-50/40 border-orange-200'
            }`}
          >
            <div className={`mt-0.5 flex items-center justify-center flex-shrink-0 scale-125 pt-1 pr-1 ${
              n.read ? 'text-gray-400' : 'text-orange-600'
            }`}>
              <Bell size={14} />
            </div>
            <div className="flex-1 min-w-0">
              <p className={`text-sm leading-snug ${n.read ? 'text-gray-600' : 'text-gray-800 font-medium'}`}>
                {n.message}
              </p>
              <p className="text-xs text-gray-400 mt-1">{n.time}</p>
            </div>
            {!n.read && <div className="w-2 h-2 rounded-full bg-orange-500 flex-shrink-0 mt-2" />}
          </div>
        ))}
      </div>
    </div>
  );
}
