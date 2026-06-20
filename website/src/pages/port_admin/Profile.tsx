import React, { useState } from 'react';
import Topbar from '../../components/layout/Topbar';
import { Key, Check, Save } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';

export default function PortAdminProfile() {
  const { user } = useAuth();
  const [success, setSuccess] = useState(false);
  const [name, setName] = useState(user?.name || 'Port Admin');
  const [phone, setPhone] = useState('+91 98765 43210');
  const [currPassword, setCurrPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');

  const handleUpdate = (e: React.FormEvent) => {
    e.preventDefault();
    setSuccess(true);
    setTimeout(() => setSuccess(false), 2000);
  };

  return (
    <div className="bg-gray-50 min-h-screen pb-10">
      <Topbar title="My Profile Settings" subtitle="Update your personal details and manage your account password." />

      <div className="px-6 max-w-xl space-y-6">
        <form onSubmit={handleUpdate} className="bg-white rounded-xl shadow-card border border-gray-100 p-5 space-y-5">
          {success && (
            <div className="flex items-center gap-2 bg-green-50 border border-green-100 text-green-700 text-xs font-semibold px-4 py-2.5 rounded-lg">
              <Check size={16} />
              <span>Profile details updated successfully!</span>
            </div>
          )}

          <div className="flex items-center gap-4 border-b border-gray-50 pb-4">
            <div className="w-16 h-16 rounded-full bg-gradient-to-br from-orange-500 to-orange-700 flex items-center justify-center text-white text-2xl font-bold">
              {name.charAt(0)}
            </div>
            <div>
              <h3 className="font-bold text-gray-800 text-base">{name}</h3>
              <span className="text-xs text-orange-600 bg-orange-50 px-2.5 py-0.5 rounded font-semibold mt-1 inline-block uppercase">Port Admin</span>
            </div>
          </div>

          <div className="space-y-4">
            <div>
              <label className="text-[10px] font-semibold text-gray-400 uppercase block mb-1">Full Name</label>
              <input
                type="text"
                required
                value={name}
                onChange={e => setName(e.target.value)}
                className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none focus:border-orange-500"
              />
            </div>

            <div>
              <label className="text-[10px] font-semibold text-gray-400 uppercase block mb-1">Email Address (Read Only)</label>
              <input
                type="email"
                disabled
                value={user?.email || 'portadmin@shcc.co.in'}
                className="w-full text-xs bg-gray-50 border border-gray-200 rounded-lg p-2 text-gray-400 outline-none"
              />
            </div>

            <div>
              <label className="text-[10px] font-semibold text-gray-400 uppercase block mb-1">Contact Phone</label>
              <input
                type="text"
                required
                value={phone}
                onChange={e => setPhone(e.target.value)}
                className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none focus:border-orange-500"
              />
            </div>
          </div>

          <div className="border-t border-gray-50 pt-5 space-y-4">
            <h4 className="text-xs font-bold text-gray-800 flex items-center gap-2">
              <Key size={14} className="text-orange-500" />
              Update Account Password
            </h4>
            <div className="grid grid-cols-2 gap-3">
              <div>
                <label className="text-[9px] font-semibold text-gray-400 block mb-1">Current Password</label>
                <input
                  type="password"
                  value={currPassword}
                  onChange={e => setCurrPassword(e.target.value)}
                  className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none focus:border-orange-500"
                />
              </div>
              <div>
                <label className="text-[9px] font-semibold text-gray-400 block mb-1">New Password</label>
                <input
                  type="password"
                  value={newPassword}
                  onChange={e => setNewPassword(e.target.value)}
                  className="w-full text-xs border border-gray-200 rounded-lg p-2 text-gray-700 outline-none focus:border-orange-500"
                />
              </div>
            </div>
          </div>

          <div className="border-t border-gray-50 pt-4 flex justify-end">
            <button type="submit" className="btn-primary text-xs py-2 px-4">
              <Save size={14} /> Update Profile
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
