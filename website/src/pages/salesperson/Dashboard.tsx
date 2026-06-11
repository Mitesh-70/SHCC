import React from 'react';
import Topbar from '../../components/layout/Topbar';
import StatCard from '../../components/ui/StatCard';
import SalesLineChart from '../../components/charts/SalesLineChart';
import { ShoppingCart, DollarSign, Award, Target, ChevronRight, Bell, Clock, Building } from 'lucide-react';
import { Link } from 'react-router-dom';

export default function SalespersonDashboard() {
  const spark1 = [2, 5, 4, 8, 7, 10, 12];
  const spark2 = [10, 15, 12, 20, 18, 24, 30];
  const spark3 = [80, 82, 85, 88, 90, 92, 95];

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="Salesperson Workspace" subtitle="Manage your accounts, track client shipments, and monitor commission targets." />

      <div className="px-6 space-y-5">
        {/* KPI Grid */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <StatCard
            icon={<ShoppingCart size={20} className="text-orange-500" />}
            label="My Orders"
            value="42"
            change={12.5}
            sparkData={spark1}
          />
          <StatCard
            icon={<span className="text-orange-600 font-bold text-lg leading-none">₹</span>}
            label="Revenue Generated"
            value="₹ 1.85 Cr"
            change={24.8}
            sparkData={spark2}
          />
          <StatCard
            icon={<Award size={20} className="text-orange-500" />}
            label="Quota Progress"
            value="92.5%"
            change={5.2}
            sparkData={spark3}
          />
        </div>

        {/* Lower layout split */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
          {/* Personal Performance Chart */}
          <div className="lg:col-span-2 bg-white rounded-xl p-5 shadow-card border border-gray-100 flex flex-col gap-4">
            <h3 className="text-sm font-bold text-gray-800">My Sales Performance (Monthly)</h3>
            <div className="w-full h-[220px]">
              <SalesLineChart />
            </div>
          </div>

          {/* Right Panels (Salesperson context) */}
          <div className="space-y-4">
            {/* My Customers */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">My Clients</h3>
                <Link to="/salesperson/customers" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>
              <div className="space-y-2">
                {[
                  { name: 'Adani Power Ltd', contact: 'Rajesh Adani', city: 'Ahmedabad' },
                  { name: 'Tata Power Company', contact: 'N. Chandrasekaran', city: 'Mumbai' },
                  { name: 'Ultratech Cement', contact: 'Kumar Birla', city: 'Mumbai' },
                ].map((cli, idx) => (
                  <div key={idx} className="flex items-center gap-3 text-xs py-2 border-b border-gray-50 last:border-0 last:pb-0">
                    <div className="p-1.5 bg-orange-50 text-orange-600 rounded-lg">
                      <Building size={14} />
                    </div>
                    <div>
                      <span className="font-semibold text-gray-700 block">{cli.name}</span>
                      <span className="text-[9px] text-gray-400">{cli.contact} • {cli.city}</span>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Notifications panel */}
            <div className="bg-white rounded-xl p-4 shadow-card border border-gray-100">
              <div className="flex items-center justify-between border-b border-gray-50 pb-2.5 mb-3">
                <h3 className="text-xs font-bold text-gray-800 uppercase tracking-wider">Recent Notices</h3>
                <Link to="/salesperson/notifications" className="text-[10px] font-bold text-orange-600 hover:underline flex items-center">
                  See All <ChevronRight size={10} />
                </Link>
              </div>
              <div className="space-y-3">
                <div className="flex gap-2 text-xs">
                  <Bell size={13} className="text-orange-500 mt-0.5 flex-shrink-0" />
                  <div>
                    <span className="font-semibold text-gray-800 block">Order #SHCC-1248 Approved</span>
                    <span className="text-[9px] text-gray-400">Your order has been signed off by finance.</span>
                  </div>
                </div>
                <div className="flex gap-2 text-xs">
                  <Clock size={13} className="text-blue-500 mt-0.5 flex-shrink-0" />
                  <div>
                    <span className="font-semibold text-gray-800 block">New Lead Assigned</span>
                    <span className="text-[9px] text-gray-400">Check detail profiles in customer list.</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
