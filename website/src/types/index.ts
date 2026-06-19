// User roles
export type Role = 'admin' | 'finance' | 'salesperson' | 'port_admin';

export interface User {
  id: string;
  name: string;
  email: string;
  role: Role;
  avatar?: string;
  department?: string;
}

export interface AuthState {
  user: User | null;
  isAuthenticated: boolean;
}

// Orders
export type OrderStatus = 'pending' | 'processing' | 'shipped' | 'delivered' | 'cancelled';

export interface Order {
  id: string;
  customer: string;
  product: string;
  quantity: number;
  unit: string;
  amount: number;
  status: OrderStatus;
  date: string;
  salesperson?: string;
}

// Stock
export interface StockItem {
  id: string;
  name: string;
  type: string;
  quantity: number;
  unit: string;
  location: string;
  lastUpdated: string;
  status: 'healthy' | 'low' | 'critical';
}

// Customer
export interface Customer {
  id: string;
  name: string;
  company: string;
  email: string;
  phone: string;
  totalOrders: number;
  totalRevenue: number;
  outstandingBalance: number;
  status: 'active' | 'inactive';
}

// Chart data
export interface MonthlySalesData {
  month: string;
  revenue: number;
  orders: number;
}

export interface SparklinePoint {
  value: number;
}

// Activity
export interface Activity {
  id: string;
  type: 'order' | 'stock' | 'report' | 'user';
  message: string;
  time: string;
}

// Alert
export interface BusinessAlert {
  id: string;
  type: 'delivery' | 'stock' | 'order';
  title: string;
  subtitle: string;
  severity: 'warning' | 'error' | 'info';
}

// Navigation item
export interface NavItem {
  label: string;
  path: string;
  icon: string;
  children?: NavItem[];
}
