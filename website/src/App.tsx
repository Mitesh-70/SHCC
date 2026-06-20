import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import type { Role } from './types';

// Pages
import Login from './pages/Login';
import NotFound from './pages/NotFound';

// Admin
import AdminLayout from './components/layout/AdminLayout';
import AdminDashboard from './pages/admin/Dashboard';
import AdminOrders from './pages/admin/Orders';
import AdminSalesAnalysis from './pages/admin/SalesAnalysis';
import AdminStockAnalysis from './pages/admin/StockAnalysis';
import AdminReports from './pages/admin/Reports';
import AdminUserPermissions from './pages/admin/UserPermissions';
import AdminCustomers from './pages/admin/Customers';
import AdminSettings from './pages/admin/Settings';
import AdminProfile from './pages/admin/Profile';
import AdminNotifications from './pages/admin/Notifications';

// Finance
import FinanceLayout from './components/layout/AdminLayout';
import FinanceDashboard from './pages/finance/Dashboard';
import FinanceOrders from './pages/finance/Orders';
import FinanceSalesAnalysis from './pages/finance/SalesAnalysis';
import FinanceStockAnalysis from './pages/finance/StockAnalysis';
import FinanceReports from './pages/finance/Reports';
import FinanceCustomers from './pages/finance/Customers';
import FinanceProfile from './pages/finance/Profile';

// Salesperson
import SalespersonDashboard from './pages/salesperson/Dashboard';
import SalespersonOrders from './pages/salesperson/Orders';
import SalespersonSalesAnalysis from './pages/salesperson/SalesAnalysis';
import SalespersonCustomers from './pages/salesperson/Customers';
import SalespersonProfile from './pages/salesperson/Profile';
import SalespersonNotifications from './pages/salesperson/Notifications';

// Port Admin
import PortAdminDashboard from './pages/port_admin/Dashboard';
import PortAdminOrders from './pages/port_admin/Orders';
import PortAdminReports from './pages/port_admin/Reports';
import PortAdminNotifications from './pages/port_admin/Notifications';
import PortAdminProfile from './pages/port_admin/Profile';

function ProtectedRoute({ children, allowedRole }: { children: React.ReactNode; allowedRole: Role }) {
  const { user, isAuthenticated } = useAuth();
  if (!isAuthenticated || !user) return <Navigate to="/login" replace />;
  if (user.role !== allowedRole) {
    const redirectMap: Record<Role, string> = {
      admin: '/admin/dashboard',
      finance: '/finance/dashboard',
      salesperson: '/salesperson/dashboard',
      port_admin: '/port-admin/dashboard',
    };
    return <Navigate to={redirectMap[user.role]} replace />;
  }
  return <>{children}</>;
}

function RootRedirect() {
  const { user, isAuthenticated } = useAuth();
  if (!isAuthenticated || !user) return <Navigate to="/login" replace />;
  const map: Record<Role, string> = {
    admin: '/admin/dashboard',
    finance: '/finance/dashboard',
    salesperson: '/salesperson/dashboard',
    port_admin: '/port-admin/dashboard',
  };
  return <Navigate to={map[user.role]} replace />;
}

function AppRoutes() {
  return (
    <Routes>
      <Route path="/" element={<RootRedirect />} />
      <Route path="/login" element={<Login />} />

      {/* Admin Routes */}
      <Route path="/admin" element={<ProtectedRoute allowedRole="admin"><AdminLayout role="admin" /></ProtectedRoute>}>
        <Route index element={<Navigate to="dashboard" replace />} />
        <Route path="dashboard" element={<AdminDashboard />} />
        <Route path="orders" element={<AdminOrders />} />
        <Route path="sales-analysis" element={<AdminSalesAnalysis />} />
        <Route path="stock-analysis" element={<AdminStockAnalysis />} />
        <Route path="reports" element={<AdminReports />} />
        <Route path="user-permissions" element={<AdminUserPermissions />} />
        <Route path="customers" element={<AdminCustomers />} />
        <Route path="settings" element={<AdminSettings />} />
        <Route path="profile" element={<AdminProfile />} />
        <Route path="notifications" element={<AdminNotifications />} />
      </Route>

      {/* Finance Routes */}
      <Route path="/finance" element={<ProtectedRoute allowedRole="finance"><FinanceLayout role="finance" /></ProtectedRoute>}>
        <Route index element={<Navigate to="dashboard" replace />} />
        <Route path="dashboard" element={<FinanceDashboard />} />
        <Route path="orders" element={<FinanceOrders />} />
        <Route path="sales-analysis" element={<FinanceSalesAnalysis />} />
        <Route path="stock-analysis" element={<FinanceStockAnalysis />} />
        <Route path="reports" element={<FinanceReports />} />
        <Route path="customers" element={<FinanceCustomers />} />
        <Route path="profile" element={<FinanceProfile />} />
      </Route>

      {/* Salesperson Routes */}
      <Route path="/salesperson" element={<ProtectedRoute allowedRole="salesperson"><AdminLayout role="salesperson" /></ProtectedRoute>}>
        <Route index element={<Navigate to="dashboard" replace />} />
        <Route path="dashboard" element={<SalespersonDashboard />} />
        <Route path="orders" element={<SalespersonOrders />} />
        <Route path="sales-analysis" element={<SalespersonSalesAnalysis />} />
        <Route path="customers" element={<SalespersonCustomers />} />
        <Route path="profile" element={<SalespersonProfile />} />
        <Route path="notifications" element={<SalespersonNotifications />} />
      </Route>

      {/* Port Admin Routes */}
      <Route path="/port-admin" element={<ProtectedRoute allowedRole="port_admin"><AdminLayout role="port_admin" /></ProtectedRoute>}>
        <Route index element={<Navigate to="dashboard" replace />} />
        <Route path="dashboard" element={<PortAdminDashboard />} />
        <Route path="orders" element={<PortAdminOrders />} />
        <Route path="reports" element={<PortAdminReports />} />
        <Route path="notifications" element={<PortAdminNotifications />} />
        <Route path="profile" element={<PortAdminProfile />} />
      </Route>

      <Route path="*" element={<NotFound />} />
    </Routes>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AppRoutes />
      </AuthProvider>
    </BrowserRouter>
  );
}
