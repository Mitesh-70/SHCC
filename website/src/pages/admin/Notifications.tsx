import React from 'react';
import Topbar from '../../components/layout/Topbar';
import { Bell, ShoppingCart, Users, Database, AlertTriangle } from 'lucide-react';

const NOTIFICATIONS = [
  { id: 1, type: 'order', title: 'High-Volume Order Placed', msg: 'Order #SHCC-1248 (2,500 MT) has been submitted by Adani Power Ltd and is processing.', time: '10 mins ago', read: false },
  { id: 2, type: 'user', title: 'New User Signup Pending Approval', msg: 'Sales Executive Vikram Singh has completed registration. Review permissions in User Permissions tab.', time: '2 hrs ago', read: false },
  { id: 3, type: 'system', title: 'Automated Database Backup Complete', msg: 'Weekly recovery snapshot of central transaction ledger generated successfully.', time: '1 day ago', read: true },
  { id: 4, type: 'warning', title: 'Low Inventory Threshold Warning', msg: 'Mundra port has reported low stock for Indonesian Coal 5000 GAR (850 MT remaining). Threshold is 1,000 MT.', time: '3 days ago', read: true },
];

export default function AdminNotifications() {
  const getIcon = (type: string) => {
    switch (type) {
      case 'order':
        return <div className="p-2 bg-green-50 text-green-600 rounded-lg"><ShoppingCart size={16} /></div>;
      case 'user':
        return <div className="p-2 bg-blue-50 text-blue-600 rounded-lg"><Users size={16} /></div>;
      case 'system':
        return <div className="p-2 bg-teal-50 text-teal-600 rounded-lg"><Database size={16} /></div>;
      case 'warning':
        return <div className="p-2 bg-red-50 text-red-600 rounded-lg"><AlertTriangle size={16} /></div>;
      default:
        return <div className="p-2 bg-orange-50 text-orange-600 rounded-lg"><Bell size={16} /></div>;
    }
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="System Alerts & Notifications" subtitle="Track administrative events, pending user actions, and system health status." />

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
