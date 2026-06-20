import React from 'react';
import {
  X,
  Hash,
  User,
  Briefcase,
  Anchor,
  Package,
  Scale,
  DollarSign,
  Truck,
  Receipt,
  Percent,
  TrendingUp,
  Activity,
  Calendar,
  RefreshCw,
  MessageSquare,
  StickyNote,
  CheckCircle2,
  Clock,
  XCircle,
  AlertCircle,
  Info,
  MapPin,
  BarChart2,
} from 'lucide-react';
import type { Order, OrderStatus } from '../../types';

interface OrderInfoModalProps {
  order: Order | null;
  onClose: () => void;
}

function StatusPill({ status }: { status: string }) {
  const map: Record<string, { label: string; cls: string }> = {
    pending:    { label: 'Pending',    cls: 'bg-amber-50  text-amber-700  border border-amber-200'  },
    processing: { label: 'Processing', cls: 'bg-blue-50   text-blue-700   border border-blue-200'   },
    shipped:    { label: 'Shipped',    cls: 'bg-purple-50 text-purple-700 border border-purple-200' },
    delivered:  { label: 'Delivered',  cls: 'bg-green-50  text-green-700  border border-green-200'  },
    cancelled:  { label: 'Rejected',   cls: 'bg-red-50    text-red-700    border border-red-200'    },
    // Port-admin custom statuses
    'Pending Approval': { label: 'Pending Approval', cls: 'bg-gray-100 text-gray-700 border border-gray-200' },
    Rejected:   { label: 'Rejected',   cls: 'bg-red-50    text-red-700    border border-red-200'    },
    Approved:   { label: 'Approved',   cls: 'bg-blue-50   text-blue-700   border border-blue-200'   },
    'On Hold':  { label: 'On Hold',    cls: 'bg-amber-50  text-amber-700  border border-amber-200'  },
    Dispatched: { label: 'Dispatched', cls: 'bg-purple-50 text-purple-700 border border-purple-200' },
    Completed:  { label: 'Completed',  cls: 'bg-green-50  text-green-700  border border-green-200'  },
  };

  const s = map[status] ?? { label: status, cls: 'bg-gray-100 text-gray-700 border border-gray-200' };
  return (
    <span className={`text-[11px] font-bold px-2.5 py-1 rounded-full inline-flex items-center gap-1.5 ${s.cls}`}>
      {s.label}
    </span>
  );
}

function InfoRow({ icon, label, value, highlight = false }: {
  icon: React.ReactNode;
  label: string;
  value: React.ReactNode;
  highlight?: boolean;
}) {
  return (
    <div className="flex items-start gap-3 py-2.5 border-b border-gray-50 last:border-0">
      <div className="mt-0.5 flex-shrink-0 w-7 h-7 rounded-lg bg-orange-50 flex items-center justify-center text-orange-500">
        {icon}
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-[10px] font-semibold text-gray-400 uppercase tracking-wider">{label}</p>
        <p className={`text-sm mt-0.5 font-semibold break-words ${highlight ? 'text-orange-600' : 'text-gray-800'}`}>
          {value || <span className="text-gray-300 font-normal italic text-xs">—</span>}
        </p>
      </div>
    </div>
  );
}

function SectionHeading({ title }: { title: string }) {
  return (
    <div className="flex items-center gap-2 mb-1 mt-4 first:mt-0">
      <div className="h-px flex-1 bg-gray-100" />
      <span className="text-[10px] font-bold uppercase tracking-widest text-gray-400 px-2">{title}</span>
      <div className="h-px flex-1 bg-gray-100" />
    </div>
  );
}

function formatAmount(val?: number): string {
  if (val == null) return '—';
  if (val >= 10000000) return `₹${(val / 10000000).toFixed(2)} Cr`;
  if (val >= 100000) return `₹${(val / 100000).toFixed(2)} L`;
  return `₹${val.toLocaleString('en-IN')}`;
}

export default function OrderInfoModal({ order, onClose }: OrderInfoModalProps) {
  if (!order) return null;

  // Derive financial fields — fall back to estimates from total amount
  const baseAmt   = order.baseAmount ?? order.amount;
  const freight   = order.freight;
  const gst       = order.gst;
  const tcs       = order.tcs;

  const hasFinancials = Boolean(order.baseAmount ?? order.freight ?? order.gst ?? order.tcs);
  const hasRemarks    = Boolean(order.adminRemarks || order.portAdminRemarks || order.rejectRemark);
  const hasDispatch   = order.dispatchDetails && order.dispatchDetails.length > 0;

  return (
    <div
      className="fixed inset-0 bg-black/50 backdrop-blur-sm z-50 flex items-center justify-center p-4"
      onClick={onClose}
    >
      <div
        className="bg-white rounded-2xl shadow-2xl w-full max-w-lg max-h-[90vh] flex flex-col overflow-hidden"
        style={{ animation: 'orderModalIn 0.22s cubic-bezier(0.34,1.56,0.64,1) both' }}
        onClick={e => e.stopPropagation()}
      >
        {/* ── Header ── */}
        <div className="px-6 pt-5 pb-4 border-b border-gray-100 flex items-start justify-between bg-gradient-to-r from-orange-50 to-white">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <div className="w-7 h-7 rounded-lg bg-orange-500 flex items-center justify-center shadow-sm">
                <Info size={14} className="text-white" />
              </div>
              <span className="text-[10px] font-bold uppercase tracking-widest text-orange-400">Order Details</span>
            </div>
            <h2 className="text-lg font-bold text-gray-900 leading-tight">{order.id}</h2>
            <div className="flex items-center gap-2 mt-1.5 flex-wrap">
              <StatusPill status={String(order.status)} />
              <span className="text-[10px] text-gray-400 flex items-center gap-1">
                <Calendar size={10} /> {order.date}
              </span>
              {order.updatedDate && (
                <span className="text-[10px] text-gray-400 flex items-center gap-1">
                  <RefreshCw size={10} /> Updated {order.updatedDate}
                </span>
              )}
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-gray-400 hover:text-gray-700 hover:bg-gray-100 transition-all flex-shrink-0 mt-0.5"
            aria-label="Close order details"
          >
            <X size={18} />
          </button>
        </div>

        {/* ── Scrollable Body ── */}
        <div className="flex-1 overflow-y-auto px-6 py-4 space-y-0.5">

          {/* Order Identity */}
          <SectionHeading title="Order Identity" />
          <InfoRow icon={<Hash size={13} />}         label="Order ID"         value={order.id} />
          <InfoRow icon={<User size={13} />}          label="Customer"         value={order.customer} />
          {order.salesperson && (
            <InfoRow icon={<Briefcase size={13} />}   label="Sales Person"     value={order.salesperson} />
          )}
          <InfoRow icon={<Package size={13} />}       label="Coal Type"        value={order.product} />
          {order.port && (
            <InfoRow icon={<Anchor size={13} />}      label="Port"             value={order.port} />
          )}
          <InfoRow icon={<Scale size={13} />}         label="Quantity"         value={`${order.quantity.toLocaleString('en-IN')} ${order.unit}`} />

          {/* Financials */}
          <SectionHeading title="Financials" />
          <InfoRow
            icon={<DollarSign size={13} />}
            label="Base Amount"
            value={formatAmount(baseAmt)}
          />
          {freight != null && (
            <InfoRow icon={<Truck size={13} />}       label="Freight"          value={formatAmount(freight)} />
          )}
          {gst != null && (
            <InfoRow icon={<Receipt size={13} />}     label="GST"              value={formatAmount(gst)} />
          )}
          {tcs != null && (
            <InfoRow icon={<Percent size={13} />}     label="TCS"              value={formatAmount(tcs)} />
          )}
          <InfoRow
            icon={<TrendingUp size={13} />}
            label="Total Amount"
            value={formatAmount(order.amount)}
            highlight
          />

          {/* Remarks */}
          {hasRemarks && (
            <>
              <SectionHeading title="Remarks" />
              {order.adminRemarks && (
                <InfoRow icon={<MessageSquare size={13} />} label="Admin Remarks"      value={order.adminRemarks} />
              )}
              {order.portAdminRemarks && (
                <InfoRow icon={<StickyNote size={13} />}    label="Port Admin Remarks" value={order.portAdminRemarks} />
              )}
              {order.rejectRemark && (
                <InfoRow icon={<XCircle size={13} />}       label="Rejection Reason"   value={order.rejectRemark} />
              )}
            </>
          )}

          {/* Dispatch Details */}
          {hasDispatch && (
            <>
              <SectionHeading title="Dispatch History" />
              <div className="mt-2 rounded-xl border border-gray-100 overflow-hidden">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="bg-gray-50">
                      <th className="text-[10px] font-bold uppercase tracking-wider text-gray-400 px-3 py-2">Date</th>
                      <th className="text-[10px] font-bold uppercase tracking-wider text-gray-400 px-3 py-2">Qty</th>
                      <th className="text-[10px] font-bold uppercase tracking-wider text-gray-400 px-3 py-2">Vehicle</th>
                      <th className="text-[10px] font-bold uppercase tracking-wider text-gray-400 px-3 py-2">Remark</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {order.dispatchDetails!.map((d, i) => (
                      <tr key={i} className="hover:bg-gray-50/50 transition-colors">
                        <td className="text-xs text-gray-600 px-3 py-2 font-medium">{d.date}</td>
                        <td className="text-xs text-gray-800 font-bold px-3 py-2">{d.quantity.toLocaleString()} {d.unit}</td>
                        <td className="text-xs text-gray-500 px-3 py-2">{d.vehicleNo || '—'}</td>
                        <td className="text-xs text-gray-500 px-3 py-2 italic">{d.remark || '—'}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </>
          )}

          {/* No dispatch yet placeholder */}
          {!hasDispatch && (
            <>
              <SectionHeading title="Dispatch History" />
              <div className="flex items-center justify-center gap-2 py-5 text-gray-300">
                <BarChart2 size={18} />
                <span className="text-xs font-medium">No dispatch entries yet</span>
              </div>
            </>
          )}
        </div>

        {/* ── Footer ── */}
        <div className="px-6 py-3.5 border-t border-gray-100 bg-gray-50/50 flex justify-end">
          <button
            onClick={onClose}
            className="px-5 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg text-xs font-bold transition-colors"
          >
            Close
          </button>
        </div>
      </div>

      {/* Animation keyframe */}
      <style>{`
        @keyframes orderModalIn {
          from { opacity: 0; transform: scale(0.95) translateY(10px); }
          to   { opacity: 1; transform: scale(1) translateY(0); }
        }
      `}</style>
    </div>
  );
}
