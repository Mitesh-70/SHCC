import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth, ROLE_DASHBOARD } from '../context/AuthContext';
import { Lock, Mail, AlertCircle, ArrowRight } from 'lucide-react';

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const res = await login(email, password);
      if (res.success) {
        // Redirect will happen inside App.tsx or we can redirect directly
        // Fetch user again or just redirect to root which does role-based redirect
        navigate('/');
      } else {
        setError(res.error || 'Authentication failed');
      }
    } catch (err) {
      setError('An unexpected error occurred. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const autofill = (em: string, pass: string) => {
    setEmail(em);
    setPassword(pass);
    setError('');
  };

  return (
    <div className="min-h-screen flex font-inter">
      {/* Left side: branding/welcome (60% width on large screens) */}
      <div className="hidden lg:flex lg:w-3/5 login-bg relative flex-col justify-between p-12 text-white overflow-hidden">
        {/* Glow effects */}
        <div className="absolute top-0 left-0 w-96 h-96 bg-white/10 rounded-full blur-3xl -translate-x-1/2 -translate-y-1/2"></div>
        <div className="absolute bottom-0 right-0 w-96 h-96 bg-orange-400/20 rounded-full blur-3xl translate-x-1/2 translate-y-1/2"></div>

        {/* Brand */}
        <div className="flex items-center gap-3 relative z-10">
          <div className="w-10 h-10 rounded-xl bg-white flex items-center justify-center text-orange-600 font-bold text-lg shadow-md">
            S
          </div>
          <div>
            <div className="text-sm font-bold tracking-wide">SHREE HARI</div>
            <div className="text-[10px] font-bold text-orange-200 tracking-widest uppercase">COAL CORPORATION</div>
          </div>
        </div>

        {/* Tagline/Visual */}
        <div className="my-auto max-w-lg relative z-10">
          <h2 className="text-4xl lg:text-5xl font-extrabold leading-tight tracking-tight">
            Fueling Industries.<br />Delivering Trust.
          </h2>
          <p className="text-orange-100 mt-4 text-base leading-relaxed">
            Manage coal inventories, sales operations, tracking, and financial analytics with Shree Hari Coal Corporation's centralized management portal.
          </p>
        </div>

        {/* Footer */}
        <div className="text-xs text-orange-200/80 relative z-10">
          © {new Date().getFullYear()} Shree Hari Coal Corporation. All rights reserved.
        </div>
      </div>

      {/* Right side: Login form (40% width) */}
      <div className="w-full lg:w-2/5 flex flex-col justify-center bg-white p-8 sm:p-12 md:p-16">
        <div className="w-full max-w-md mx-auto">
          {/* Logo (for small screens) */}
          <div className="lg:hidden flex items-center gap-2.5 mb-8">
            <div className="w-9 h-9 rounded-lg bg-orange-500 flex items-center justify-center text-white font-bold text-base shadow-sm">
              S
            </div>
            <div>
              <div className="text-xs font-bold text-gray-900 tracking-wide">SHREE HARI</div>
              <div className="text-[9px] font-bold text-orange-600 tracking-widest uppercase">COAL CORPORATION</div>
            </div>
          </div>

          <h3 className="text-2xl font-bold text-gray-900">Portal Login</h3>
          <p className="text-sm text-gray-500 mt-1">Access your dashboard using your registered credentials.</p>

          {error && (
            <div className="mt-4 flex items-center gap-2 bg-red-50 border border-red-100 rounded-lg p-3 text-xs text-red-600">
              <AlertCircle size={14} className="flex-shrink-0" />
              <span>{error}</span>
            </div>
          )}

          <form onSubmit={handleLogin} className="mt-6 space-y-4">
            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                Email Address
              </label>
              <div className="relative">
                <Mail size={16} className="absolute left-3 top-3 text-gray-400" />
                <input
                  type="email"
                  required
                  placeholder="name@shcc.co.in"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="pl-10 pr-4 py-2.5 w-full border border-gray-200 rounded-lg text-sm text-gray-800 placeholder-gray-400 focus:border-orange-500 focus:outline-none transition-colors"
                />
              </div>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-600 uppercase tracking-wider mb-1.5">
                Password
              </label>
              <div className="relative">
                <Lock size={16} className="absolute left-3 top-3 text-gray-400" />
                <input
                  type="password"
                  required
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="pl-10 pr-4 py-2.5 w-full border border-gray-200 rounded-lg text-sm text-gray-800 placeholder-gray-400 focus:border-orange-500 focus:outline-none transition-colors"
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="w-full flex items-center justify-center gap-2 bg-orange-500 hover:bg-orange-600 disabled:bg-orange-300 text-white font-medium py-2.5 rounded-lg text-sm transition-colors shadow-sm mt-6"
            >
              <span>{loading ? 'Logging in...' : 'Sign In'}</span>
              {!loading && <ArrowRight size={15} />}
            </button>
          </form>

          {/* Quick Login Section (autofill buttons) */}
          <div className="mt-8 border-t border-gray-100 pt-6">
            <span className="text-xs font-semibold text-gray-400 uppercase tracking-wider">
              Quick Role Login (Click to Fill)
            </span>
            <div className="mt-3 space-y-2">
              <button
                type="button"
                onClick={() => autofill('admin@shcc.co.in', 'admin123')}
                className="w-full flex items-center justify-between p-2.5 border border-gray-100 rounded-lg text-left hover:bg-orange-50/50 hover:border-orange-200 transition-all text-xs"
              >
                <div>
                  <span className="font-semibold text-gray-700 block">Administrator</span>
                  <span className="text-gray-400">admin@shcc.co.in</span>
                </div>
                <span className="bg-orange-50 text-orange-700 px-2 py-0.5 rounded font-medium">Admin</span>
              </button>

              <button
                type="button"
                onClick={() => autofill('finance@shcc.co.in', 'finance123')}
                className="w-full flex items-center justify-between p-2.5 border border-gray-100 rounded-lg text-left hover:bg-orange-50/50 hover:border-orange-200 transition-all text-xs"
              >
                <div>
                  <span className="font-semibold text-gray-700 block">Finance Manager</span>
                  <span className="text-gray-400">finance@shcc.co.in</span>
                </div>
                <span className="bg-blue-50 text-blue-700 px-2 py-0.5 rounded font-medium">Finance</span>
              </button>

              <button
                type="button"
                onClick={() => autofill('salesperson@shcc.co.in', 'sales123')}
                className="w-full flex items-center justify-between p-2.5 border border-gray-100 rounded-lg text-left hover:bg-orange-50/50 hover:border-orange-200 transition-all text-xs"
              >
                <div>
                  <span className="font-semibold text-gray-700 block">Salesperson</span>
                  <span className="text-gray-400">salesperson@shcc.co.in</span>
                </div>
                <span className="bg-green-50 text-green-700 px-2 py-0.5 rounded font-medium">Sales</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
