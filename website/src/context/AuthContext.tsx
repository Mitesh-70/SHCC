import { createContext, useContext, useState, useEffect } from 'react';
import type { ReactNode } from 'react';
import type { User, Role } from '../types';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; error?: string }>;
  logout: () => void;
}

const CREDENTIALS: Record<string, { password: string; user: User }> = {
  'admin@shcc.co.in': {
    password: 'admin123',
    user: { id: '1', name: 'Admin User', email: 'admin@shcc.co.in', role: 'admin', department: 'Administration' },
  },
  'finance@shcc.co.in': {
    password: 'finance123',
    user: { id: '2', name: 'Finance User', email: 'finance@shcc.co.in', role: 'finance', department: 'Finance' },
  },
  'salesperson@shcc.co.in': {
    password: 'sales123',
    user: { id: '3', name: 'Rahul Verma', email: 'salesperson@shcc.co.in', role: 'salesperson', department: 'Sales' },
  },
  'portadmin@shcc.co.in': {
    password: 'port123',
    user: { id: '4', name: 'Port Admin', email: 'portadmin@shcc.co.in', role: 'port_admin', department: 'Port Operations' },
  },
};

const ROLE_DASHBOARD: Record<Role, string> = {
  admin: '/admin/dashboard',
  finance: '/finance/dashboard',
  salesperson: '/salesperson/dashboard',
  port_admin: '/port-admin/dashboard',
};

export { ROLE_DASHBOARD };

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);

  useEffect(() => {
    const stored = localStorage.getItem('shcc_user');
    if (stored) {
      try {
        setUser(JSON.parse(stored));
      } catch {
        localStorage.removeItem('shcc_user');
      }
    }
  }, []);

  const login = async (email: string, password: string): Promise<{ success: boolean; error?: string }> => {
    const record = CREDENTIALS[email.toLowerCase().trim()];
    if (!record) return { success: false, error: 'Invalid email or password.' };
    if (record.password !== password) return { success: false, error: 'Invalid email or password.' };
    setUser(record.user);
    localStorage.setItem('shcc_user', JSON.stringify(record.user));
    return { success: true };
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem('shcc_user');
  };

  return (
    <AuthContext.Provider value={{ user, isAuthenticated: !!user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
