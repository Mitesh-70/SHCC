import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Settings, Shield, Bell, Database, Save, Check } from 'lucide-react';

export default function AdminSettings() {
  const [success, setSuccess] = useState(false);
  const [emailAlerts, setEmailAlerts] = useState(true);
  const [lowStockWarning, setLowStockWarning] = useState(true);
  const [autoApproveUser, setAutoApproveUser] = useState(false);
  const [coalThreshold, setCoalThreshold] = useState(1000);

  const handleSave = (e: React.FormEvent) => {
    e.preventDefault();
    setSuccess(true);
    setTimeout(() => setSuccess(false), 2000);
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="System Settings" subtitle="Configure system-wide notifications, stock thresholds, and security parameters." />

      <div className="px-6 max-w-3xl">
        <form onSubmit={handleSave} className="bg-white rounded-xl shadow-card border border-gray-100 p-5 space-y-6">
          {success && (
            <div className="flex items-center gap-2 bg-green-50 border border-green-100 text-green-700 text-xs font-semibold px-4 py-2.5 rounded-lg">
              <Check size={16} />
              <span>Configurations saved successfully!</span>
            </div>
          )}

          {/* Block 1: Stock alerts */}
          <div className="space-y-4">
            <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2 border-b border-gray-50 pb-2">
              <Database size={16} className="text-orange-500" />
              Stock & Inventory Thresholds
            </h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between text-xs">
                <div>
                  <span className="font-semibold text-gray-800 block">Low Stock Alert Level</span>
                  <span className="text-gray-400 mt-0.5 block">Trigger low stock alert when inventory drops below this quantity.</span>
                </div>
                <div className="flex items-center gap-2">
                  <input
                    type="number"
                    value={coalThreshold}
                    onChange={e => setCoalThreshold(Number(e.target.value))}
                    className="w-20 border border-gray-200 rounded-lg p-1.5 text-center text-xs text-gray-800 font-semibold focus:border-orange-500 focus:outline-none"
                  />
                  <span className="text-gray-400">MT</span>
                </div>
              </div>

              <div className="flex items-center justify-between text-xs">
                <div>
                  <span className="font-semibold text-gray-800 block">System Warnings</span>
                  <span className="text-gray-400 mt-0.5 block">Display warning widgets on dashboard for critical stock level items.</span>
                </div>
                <input
                  type="checkbox"
                  checked={lowStockWarning}
                  onChange={e => setLowStockWarning(e.target.checked)}
                  className="rounded border-gray-300 text-orange-500 focus:ring-orange-500 h-4 w-4"
                />
              </div>
            </div>
          </div>

          {/* Block 2: Alerts & Notifications */}
          <div className="space-y-4">
            <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2 border-b border-gray-50 pb-2">
              <Bell size={16} className="text-orange-500" />
              Notification Channels
            </h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between text-xs">
                <div>
                  <span className="font-semibold text-gray-800 block">Dispatch Reports Email Summary</span>
                  <span className="text-gray-400 mt-0.5 block">Send weekly summary of sales performance and ledger changes to admins.</span>
                </div>
                <input
                  type="checkbox"
                  checked={emailAlerts}
                  onChange={e => setEmailAlerts(e.target.checked)}
                  className="rounded border-gray-300 text-orange-500 focus:ring-orange-500 h-4 w-4"
                />
              </div>
            </div>
          </div>

          {/* Block 3: Security & RBAC */}
          <div className="space-y-4">
            <h3 className="text-sm font-bold text-gray-800 flex items-center gap-2 border-b border-gray-50 pb-2">
              <Shield size={16} className="text-orange-500" />
              Portal Access Toggles
            </h3>
            <div className="space-y-3">
              <div className="flex items-center justify-between text-xs">
                <div>
                  <span className="font-semibold text-gray-800 block">Automatic User Onboarding</span>
                  <span className="text-gray-400 mt-0.5 block">Allow pending signup requests to log in immediately without admin validation.</span>
                </div>
                <input
                  type="checkbox"
                  checked={autoApproveUser}
                  onChange={e => setAutoApproveUser(e.target.checked)}
                  className="rounded border-gray-300 text-orange-500 focus:ring-orange-500 h-4 w-4"
                />
              </div>
            </div>
          </div>

          <div className="border-t border-gray-100 pt-4 flex justify-end">
            <button type="submit" className="btn-primary text-xs py-2 px-4">
              <Save size={14} /> Save System Settings
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
