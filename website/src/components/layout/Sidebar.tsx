import { NavLink, useNavigate, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import type { Role } from '../../types';
import {
  LayoutDashboard, ShoppingCart, Package, FileText,
  ChevronRight, Bell,
  Search, Shield, TrendingUp, ChevronDown,
  ChevronsLeft, ChevronsRight,
  Mail, LogOut, X
} from 'lucide-react';
import { useState, useEffect } from 'react';

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
  { label: 'Dashboard',        path: 'dashboard',        icon: <LayoutDashboard size={18} />, roles: ['admin', 'finance', 'salesperson', 'port_admin'] },
  { label: 'Orders',           path: 'orders',           icon: <ShoppingCart size={18} />,    roles: ['admin', 'finance', 'salesperson', 'port_admin'] },
  { label: 'Sales Analysis',   path: 'sales-analysis',   icon: <TrendingUp size={18} />,      roles: ['admin', 'finance'] },
  { label: 'Stock Analysis',   path: 'stock-analysis',   icon: <Package size={18} />,         roles: ['admin', 'finance', 'port_admin'] },
  { label: 'Reports',          path: 'reports',          icon: <FileText size={18} />,        roles: ['admin', 'finance', 'salesperson', 'port_admin'] },
  { label: 'User Permissions', path: 'user-permissions', icon: <Shield size={18} />,         roles: ['admin'] },
  { label: 'Notifications',    path: 'notifications',    icon: <Bell size={18} />,            roles: ['admin', 'salesperson', 'port_admin'] },
];

const ROLE_LABELS: Record<Role, string> = {
  admin:       'Admin Portal',
  finance:     'Finance Portal',
  salesperson: 'Sales Portal',
  port_admin:  'Port Admin Portal',
};

const ROLE_BASE: Record<Role, string> = {
  admin:       '/admin',
  finance:     '/finance',
  salesperson: '/salesperson',
  port_admin:  '/port-admin',
};

const LOGO_SRC = '/logo.png';

const USER_AVATARS: Record<string, string> = {
  'admin@shcc.co.in':       'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&h=100&q=80',
  'finance@shcc.co.in':     'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=100&h=100&q=80',
  'salesperson@shcc.co.in': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&h=100&q=80',
  'portadmin@shcc.co.in':   'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=100&h=100&q=80',
};


export default function Sidebar({ role, collapsed, onToggle }: SidebarProps) {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [search, setSearch] = useState('');
  const [userMenuOpen, setUserMenuOpen] = useState(false);
  const location = useLocation();
  const [unreadNotifications, setUnreadNotifications] = useState(role === 'admin' ? 2 : 3);

  useEffect(() => {
    if (location.pathname.includes('/notifications')) {
      setUnreadNotifications(0);
    }
  }, [location.pathname]);

  const base = ROLE_BASE[role];

  const visibleItems = NAV_ITEMS.filter(item =>
    item.roles.includes(role) &&
    item.label.toLowerCase().includes(search.toLowerCase())
  );

  const handleLogout = () => {
    setUserMenuOpen(false);
    logout();
    navigate('/login');
  };

  const handleSettings = () => {
    setUserMenuOpen(false);
    if (role === 'admin') {
      navigate(`${base}/settings`);
    } else if (role === 'salesperson' || role === 'port_admin') {
      navigate(`${base}/profile`);
    } else {
      navigate(`${base}/dashboard`);
    }
  };

  const handleProfile = () => {
    setUserMenuOpen(false);
    if (role === 'admin' || role === 'finance' || role === 'salesperson' || role === 'port_admin') {
      navigate(`${base}/profile`);
    } else {
      navigate(`${base}/dashboard`);
    }
  };

  const avatarUrl = user?.email
    ? USER_AVATARS[user.email.toLowerCase()] || 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&h=100&q=80'
    : 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&w=100&h=100&q=80';

  // ProfileModal code removed, port_admin uses standard profile page

  // ── Standard popup (All Roles) ───────────────────────────────────────────
  const StandardPopup = () => (
    <div className="absolute left-3 right-3 bottom-[72px] z-20 rounded-2xl border border-gray-200 bg-white shadow-xl p-2 space-y-0.5">
      {role === 'admin' ? (
        <>
          <button
            type="button"
            onClick={handleProfile}
            className="w-full text-left rounded-xl px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Profile
          </button>
          <button
            type="button"
            onClick={handleSettings}
            className="w-full text-left rounded-xl px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Settings
          </button>
        </>
      ) : (
        <button
          type="button"
          onClick={handleProfile}
          className="w-full text-left rounded-xl px-3 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors"
        >
          Profile
        </button>
      )}
      <button
        type="button"
        onClick={handleLogout}
        className="w-full text-left rounded-xl px-3 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
      >
        Logout
      </button>
    </div>
  );

  return (
    <>
      <aside
        className={`flex flex-col bg-white border-r border-gray-100 transition-all duration-300 ease-in-out ${
          collapsed ? 'w-[72px]' : 'w-[240px]'
        } min-h-screen relative`}
      >
        {/* Logo and Collapse Toggle */}
        <div className={`flex items-center justify-between px-4 py-5 border-b border-gray-100 ${collapsed ? 'flex-col gap-2' : ''}`}>
          <div className="flex items-center gap-3">
            <img src={LOGO_SRC} alt="SHCC Logo" className="flex-shrink-0 w-14 h-14 object-contain" />
            {!collapsed && (
              <div className="leading-tight overflow-hidden text-left max-w-[140px]">
                <div className="text-base font-extrabold text-gray-900 tracking-tight">SHREE HARI</div>
                <div className="text-xs font-extrabold text-orange-600 tracking-wide uppercase -mt-0.5 truncate">COAL CORPORATION</div>
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

        {/* Role Badge Removed */}

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
                      {!collapsed && item.path === 'notifications' && unreadNotifications > 0 && (
                        <span className="ml-auto text-[10px] bg-orange-500 text-white rounded-full px-1.5 py-0.5 font-bold">
                          {unreadNotifications}
                        </span>
                      )}
                      {!collapsed && ['orders', 'sales-analysis', 'stock-analysis', 'reports', 'user-permissions'].includes(item.path) && (
                        <ChevronRight size={14} className={`ml-auto flex-shrink-0 ${isActive ? 'text-orange-600' : 'text-gray-400'}`} />
                      )}
                    </>
                  )}
                </NavLink>
              </li>
            ))}
          </ul>
        </nav>

        {/* User Info bottom widget */}
        {!collapsed ? (
          <div className="border-t border-gray-100 p-3 relative">
            <div
              className="flex items-center justify-between bg-gray-50 border border-gray-100 rounded-xl p-2.5 cursor-pointer hover:bg-gray-100/55 transition-colors"
              onClick={() => setUserMenuOpen(prev => !prev)}
            >
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
              <ChevronDown
                size={14}
                className={`text-gray-400 flex-shrink-0 ml-1 transition-transform ${userMenuOpen ? 'rotate-180' : ''}`}
              />
            </div>

            {/* Standard menu popup */}
            {userMenuOpen && <StandardPopup />}
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
    </>
  );
}
