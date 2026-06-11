import { Outlet } from 'react-router-dom';
import { useState } from 'react';
import Sidebar from './Sidebar';
import type { Role } from '../../types';

interface AdminLayoutProps {
  role: Role;
}

export default function AdminLayout({ role }: AdminLayoutProps) {
  const [collapsed, setCollapsed] = useState(false);

  return (
    <div className="flex h-screen bg-gray-50 overflow-hidden font-inter">
      <Sidebar role={role} collapsed={collapsed} onToggle={() => setCollapsed(c => !c)} />
      <main className="flex-1 flex flex-col overflow-hidden">
        <div className="flex-1 overflow-y-auto">
          <Outlet />
        </div>
      </main>
    </div>
  );
}
