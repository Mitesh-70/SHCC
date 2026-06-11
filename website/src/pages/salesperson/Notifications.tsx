import React from 'react';
import Topbar from '../../components/layout/Topbar';
import { Bell, ShoppingCart, Users, Volume2, Calendar } from 'lucide-react';

const NOTIFICATIONS = [
  { id: 1, type: 'order', title: 'Order #SHCC-1248 Approved', msg: 'Finance team has confirmed payment receipt and approved shipment for Adani Power Ltd.', time: '10 mins ago', read: false },
  { id: 2, type: 'customer', title: 'Client Account Assigned', msg: 'Tata Power Company contact sheet and purchase logs are now linked to your sales dashboard.', time: '2 hrs ago', read: false },
  { id: 3, type: 'task', title: 'Annual Sales Targets Dispatched', msg: 'System admin has published the target quotas for Q3 FY2026. Target threshold: ₹2.00 Cr.', time: '1 day ago', read: true },
  { id: 4, type: 'announcement', title: 'Scheduled Server Maintenance', msg: 'SHCC database portals will undergo routine upgrades on Sunday between 02:00 AM and 04:00 AM IST.', time: '3 days ago', read: true },
];

export default function SalespersonNotifications() {
  const getIcon = (type: string) => {
    switch (type) {
      case 'order':
        return <div className="p-2 bg-green-50 text-green-600 rounded-lg"><ShoppingCart size={16} /></div>;
      case 'customer':
        return <div className="p-2 bg-blue-50 text-blue-600 rounded-lg"><Users size={16} /></div>;
      case 'announcement':
        return <div className="p-2 bg-red-50 text-red-600 rounded-lg"><Volume2 size={16} /></div>;
      default:
        return <div className="p-2 bg-orange-50 text-orange-600 rounded-lg"><Bell size={16} /></div>;
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="My Notifications" subtitle="View and check logs of client events, order approvals, and system broadcasts." />

      <div className="px-6 max-w-2xl space-y-4">
        <div className="bg-white rounded-xl shadow-card border border-gray-100 p-5 divide-y divide-gray-50">
          {NOTIFICATIONS.map(n => (
            <div key={n.id} className="flex gap-4 py-4 first:pt-0 last:pb-0 items-start">
              {getIcon(n.type)}
              <div className="flex-1 min-w-0">
                <div className="flex items-center justify-between">
                  <span className={`text-xs font-bold ${n.read ? 'text-gray-700' : 'text-gray-950 font-extrabold'}`}>
                    {n.title}
                  </span>
                  {!n.read && <span className="w-1.5 h-1.5 rounded-full bg-orange-500 flex-shrink-0" />}
                </div>
                <p className="text-xs text-gray-500 mt-1 leading-relaxed">{n.msg}</p>
                <span className="text-[10px] text-gray-400 font-medium block mt-1.5">{n.time}</span>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
