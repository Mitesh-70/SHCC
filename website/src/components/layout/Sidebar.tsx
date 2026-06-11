import { NavLink, useNavigate } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import type { Role } from '../../types';
import {
  LayoutDashboard, ShoppingCart, Package, FileText,
  Users, Settings, LogOut, ChevronLeft, ChevronRight, Bell,
  Search, Shield, UserCircle, TrendingUp, ChevronDown,
  ChevronsLeft, ChevronsRight
} from 'lucide-react';
import { useState } from 'react';

interface SidebarProps {
  role: Role;
  collapsed: boolean;
  onToggle: () => void;
}

type NavItem = {
  label: string;
  path: string;
  icon: React.ReactNode;
  roles: Role[];
};

const NAV_ITEMS: NavItem[] = [
  { label: 'Dashboard', path: 'dashboard', icon: <LayoutDashboard size={18} />, roles: ['admin', 'finance', 'salesperson'] },
  { label: 'Orders', path: 'orders', icon: <ShoppingCart size={18} />, roles: ['admin', 'finance', 'salesperson'] },
  { label: 'Sales Analysis', path: 'sales-analysis', icon: <TrendingUp size={18} />, roles: ['admin', 'finance', 'salesperson'] },
  { label: 'Stock Analysis', path: 'stock-analysis', icon: <Package size={18} />, roles: ['admin', 'finance'] },
  { label: 'Reports', path: 'reports', icon: <FileText size={18} />, roles: ['admin', 'finance'] },
  { label: 'User Permissions', path: 'user-permissions', icon: <Shield size={18} />, roles: ['admin'] },
  { label: 'Settings', path: 'settings', icon: <Settings size={18} />, roles: ['admin'] },
  { label: 'Profile', path: 'profile', icon: <UserCircle size={18} />, roles: ['salesperson'] },
  { label: 'Notifications', path: 'notifications', icon: <Bell size={18} />, roles: ['salesperson'] },
  { label: 'Logout', path: 'logout', icon: <LogOut size={18} />, roles: ['admin', 'finance', 'salesperson'] },
];

const ROLE_LABELS: Record<Role, string> = {
  admin: 'Admin Portal',
  finance: 'Finance Portal',
  salesperson: 'Sales Portal',
};

const ROLE_BASE: Record<Role, string> = {
  admin: '/admin',
  finance: '/finance',
  salesperson: '/salesperson',
};

const USER_AVATARS: Record<string, string> = {
  'admin@shcc.co.in': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&h=100&q=80',
  'finance@shcc.co.in': 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=100&h=100&q=80',
  'salesperson@shcc.co.in': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&h=100&q=80',
};

export default function Sidebar({ role, collapsed, onToggle }: SidebarProps) {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [search, setSearch] = useState('');

  const visibleItems = NAV_ITEMS.filter(item =>
    item.roles.includes(role) &&
    item.label.toLowerCase().includes(search.toLowerCase())
  );

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const base = ROLE_BASE[role];
  const avatarUrl = user?.email
    ? USER_AVATARS[user.email.toLowerCase()] || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&h=100&q=80'
    : 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&h=100&q=80';

  return (
    <aside
      className={`flex flex-col bg-white border-r border-gray-100 transition-all duration-300 ease-in-out ${
        collapsed ? 'w-[72px]' : 'w-[240px]'
      } min-h-screen relative`}
    >
      {/* Logo and Collapse Toggle */}
      <div className={`flex items-center justify-between px-4 py-5 border-b border-gray-100 ${collapsed ? 'flex-col gap-2' : ''}`}>
        <div className="flex items-center gap-3">
          <div className="flex-shrink-0 w-10 h-10 rounded-full bg-gradient-to-br from-orange-500 to-red-600 flex items-center justify-center text-white font-extrabold text-xs shadow-md border-2 border-orange-100">
            SHCC
          </div>
          {!collapsed && (
            <div className="leading-tight overflow-hidden text-left">
              <div className="text-xs font-extrabold text-gray-900 tracking-wide">SHREE HARI</div>
              <div className="text-[10px] font-semibold text-orange-600 tracking-widest uppercase">COAL CORPORATION</div>
              <div className="text-[9px] text-gray-400 italic">Fueling Industries. Delivering Trust.</div>
            </div>
          )}
        </div>
        {!collapsed ? (
          <button
            onClick={onToggle}
            className="text-gray-400 hover:text-orange-600 transition-colors p-1.5 rounded-lg border border-gray-200 bg-gray-50 hover:bg-orange-50 shadow-sm"
            aria-label="Collapse sidebar"
          >
            <ChevronsLeft size={12} />
          </button>
        ) : (
          <button
            onClick={onToggle}
            className="absolute -right-3 top-6 z-10 bg-white border border-gray-200 rounded-full p-1 shadow-sm hover:shadow-md transition-shadow text-gray-500 hover:text-orange-600"
            aria-label="Expand sidebar"
          >
            <ChevronsRight size={12} />
          </button>
        )}
      </div>

      {/* Role Badge / Portal Selector */}
      {!collapsed && (
        <div className="px-3 mt-3 mb-1">
          <div className="flex items-center justify-between bg-white border border-gray-200 rounded-lg px-3 py-2 shadow-sm text-gray-700 cursor-pointer hover:bg-gray-50 transition-colors">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-orange-500"></div>
              <span className="text-xs font-bold text-gray-800">{ROLE_LABELS[role]}</span>
            </div>
            <ChevronDown size={12} className="text-gray-400" />
          </div>
        </div>
      )}

      {/* Search */}
      {!collapsed && (
        <div className="px-3 mt-2 mb-1">
          <div className="flex items-center gap-2 bg-gray-50 rounded-lg px-3 py-2 border border-gray-100">
            <Search size={13} className="text-gray-400 flex-shrink-0" />
            <input
              type="text"
              placeholder="Search..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="bg-transparent text-xs text-gray-600 outline-none w-full placeholder-gray-400"
            />
            <span className="text-[10px] text-gray-300 font-mono flex-shrink-0">⌘K</span>
          </div>
        </div>
      )}

      {/* Nav */}
      <nav className="flex-1 px-2 py-2 overflow-y-auto">
        {!collapsed && <div className="text-[10px] font-semibold text-gray-400 px-2 py-1.5 uppercase tracking-widest text-left">Menu</div>}
        <ul className="space-y-0.5">
          {visibleItems.map(item => (
            <li key={item.path}>
              {item.path === 'logout' ? (
                <button
                  onClick={handleLogout}
                  className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-150 cursor-pointer w-full text-left text-gray-600 hover:bg-red-50 hover:text-red-600 ${collapsed ? 'justify-center' : ''}`}
                  title={collapsed ? item.label : undefined}
                >
                  <span className="flex-shrink-0">{item.icon}</span>
                  {!collapsed && <span className="truncate">{item.label}</span>}
                </button>
              ) : (
                <NavLink
                  to={`${base}/${item.path}`}
                  className={({ isActive }) =>
                    `flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-150 cursor-pointer ${
                      isActive
                        ? 'bg-orange-50 text-orange-600 border-l-2 border-orange-500 rounded-l-none'
                        : 'text-gray-600 hover:bg-gray-50 hover:text-gray-900'
                    } ${collapsed ? 'justify-center' : ''}`
                  }
                  title={collapsed ? item.label : undefined}
                >
                  {({ isActive }) => (
                    <>
                      <span className="flex-shrink-0">{item.icon}</span>
                      {!collapsed && <span className="truncate">{item.label}</span>}
                      {!collapsed && item.path === 'notifications' && (
                        <span className="ml-auto text-[10px] bg-orange-500 text-white rounded-full px-1.5 py-0.5 font-bold">3</span>
                      )}
                      {!collapsed && ['orders', 'sales-analysis', 'stock-analysis', 'reports', 'user-permissions'].includes(item.path) && (
                        <ChevronRight size={14} className={`ml-auto flex-shrink-0 ${isActive ? 'text-orange-600' : 'text-gray-400'}`} />
                      )}
                    </>
                  )}
                </NavLink>
              )}
            </li>
          ))}
        </ul>
      </nav>

      {/* User Info bottom widget */}
      {!collapsed ? (
        <div className="border-t border-gray-100 p-3">
          <div className="flex items-center justify-between bg-gray-50 border border-gray-100 rounded-xl p-2.5 cursor-pointer hover:bg-gray-100/55 transition-colors">
            <div className="flex items-center gap-2.5 min-w-0">
              <img
                src={avatarUrl}
                alt={user?.name ?? 'User'}
                className="w-9 h-9 rounded-full object-cover border border-gray-200"
              />
              <div className="flex-1 min-w-0 text-left">
                <div className="text-xs font-bold text-gray-800 truncate">{user?.name ?? 'Admin User'}</div>
                <div className="text-[10px] text-gray-400 truncate mt-0.5">{user?.email ?? 'admin@shcc.co.in'}</div>
              </div>
            </div>
            <ChevronDown size={14} className="text-gray-400 flex-shrink-0 ml-1" />
          </div>
        </div>
      ) : (
        <div className="border-t border-gray-100 p-3 flex justify-center">
          <img
            src={avatarUrl}
            alt={user?.name ?? 'User'}
            className="w-8 h-8 rounded-full object-cover border border-gray-200"
          />
        </div>
      )}
    </aside>
  );
}
