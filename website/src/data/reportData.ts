// ─────────────────────────────────────────────────────────────────────────────
//  SHCC REPORT SAMPLE DATA  –  Isolated from UI logic
//  Replace arrays/objects below with API responses when backend is ready.
// ─────────────────────────────────────────────────────────────────────────────

export const COMPANY = {
  name: 'Shree Hari Coal Corporation',
  gstin: '24AABCS1429B1ZA',
  pan: 'AABCS1429B',
  address: 'Plot No. 14, GIDC Industrial Estate, Mundra – 370421, Gujarat',
  email: 'accounts@shreeharcoal.in',
  phone: '+91 98250 47301',
};

// ── 1. SALES & REVENUE ───────────────────────────────────────────────────────
export const SALES_SUMMARY = {
  period: 'June 2026 (MTD)',
  totalRevenue: 185750000,
  totalOrders: 42,
  avgOrderValue: 4422619,
  revenueGrowth: 14.8,
  ordersGrowth: 9.3,
  topCoalType: 'Indonesian Coal (5500 GAR)',
  topPort: 'Mundra Port',
};

export const SALES_BY_COAL_TYPE = [
  { coalType: 'Indonesian Coal (5500 GAR)', orders: 14, quantityMT: 28500, revenue: 62700000, revenueShare: 33.8 },
  { coalType: 'South African Coal (6000 NAR)', orders: 10, quantityMT: 19200, revenue: 48000000, revenueShare: 25.8 },
  { coalType: 'US Coal (6800 NAR)', orders: 8, quantityMT: 14800, revenue: 38480000, revenueShare: 20.7 },
  { coalType: 'Russian Coal (6000 NAR)', orders: 6, quantityMT: 12000, revenue: 24000000, revenueShare: 12.9 },
  { coalType: 'Indonesian Coal (3800 GAR)', orders: 4, quantityMT: 8400, revenue: 12570000, revenueShare: 6.8 },
];

export const SALES_ORDERS = [
  { orderId: 'SHCC-1248', date: '2026-06-10', customer: 'Adani Power Ltd', salesperson: 'Rahul Verma', coalType: 'Indonesian Coal (5500 GAR)', port: 'Mundra Port', quantityMT: 2500, baseAmount: 11500000, freight: 875000, gst: 1237500, tcs: 137500, totalAmount: 13750000, status: 'Delivered' },
  { orderId: 'SHCC-1247', date: '2026-06-09', customer: 'Tata Power Company', salesperson: 'Rahul Verma', coalType: 'South African Coal (6000 NAR)', port: 'Kandla Port', quantityMT: 1800, baseAmount: 9800000, freight: 720000, gst: 1052400, tcs: 127600, totalAmount: 11700000, status: 'Shipped' },
  { orderId: 'SHCC-1246', date: '2026-06-08', customer: 'Jindal Steel & Power', salesperson: 'Neha Sharma', coalType: 'US Coal (6800 NAR)', port: 'Paradip Port', quantityMT: 1200, baseAmount: 8100000, freight: 600000, gst: 768000, tcs: 132000, totalAmount: 9600000, status: 'Processing' },
  { orderId: 'SHCC-1245', date: '2026-06-07', customer: 'Vedanta Aluminium', salesperson: 'Vikram Singh', coalType: 'Russian Coal (6000 NAR)', port: 'Vizag Port', quantityMT: 3000, baseAmount: 16500000, freight: 1200000, gst: 1575000, tcs: 225000, totalAmount: 19500000, status: 'Pending' },
  { orderId: 'SHCC-1244', date: '2026-06-05', customer: 'Ultratech Cement', salesperson: 'Rahul Verma', coalType: 'Indonesian Coal (3800 GAR)', port: 'Mundra Port', quantityMT: 4500, baseAmount: 17000000, freight: 1575000, gst: 1822500, tcs: 202500, totalAmount: 20250000, status: 'Delivered' },
  { orderId: 'SHCC-1243', date: '2026-06-03', customer: 'Ambuja Cements', salesperson: 'Neha Sharma', coalType: 'South African Coal (5500 NAR)', port: 'Hazira Port', quantityMT: 1500, baseAmount: 7500000, freight: 675000, gst: 1250000, tcs: 75000, totalAmount: 9500000, status: 'Cancelled' },
  { orderId: 'SHCC-1242', date: '2026-06-02', customer: 'NTPC Ltd', salesperson: 'Vikram Singh', coalType: 'US Coal (6800 NAR)', port: 'Mundra Port', quantityMT: 5000, baseAmount: 29500000, freight: 2750000, gst: 3150000, tcs: 350000, totalAmount: 35000000, status: 'Delivered' },
  { orderId: 'SHCC-1241', date: '2026-06-01', customer: 'JSW Energy Ltd', salesperson: 'Rahul Verma', coalType: 'Indonesian Coal (5500 GAR)', port: 'Mundra Port', quantityMT: 2200, baseAmount: 9900000, freight: 770000, gst: 1058700, tcs: 121300, totalAmount: 11850000, status: 'Delivered' },
  { orderId: 'SHCC-1240', date: '2026-05-29', customer: 'Reliance Industries', salesperson: 'Neha Sharma', coalType: 'South African Coal (6000 NAR)', port: 'Kandla Port', quantityMT: 3200, baseAmount: 17600000, freight: 1280000, gst: 1886400, tcs: 233600, totalAmount: 21000000, status: 'Delivered' },
  { orderId: 'SHCC-1239', date: '2026-05-27', customer: 'Hindalco Industries', salesperson: 'Vikram Singh', coalType: 'Russian Coal (6000 NAR)', port: 'Vizag Port', quantityMT: 2800, baseAmount: 15400000, freight: 1120000, gst: 1470000, tcs: 210000, totalAmount: 18200000, status: 'Delivered' },
];

export const MONTHLY_REVENUE_TREND = [
  { month: 'Jan 2026', revenue: 128500000, orders: 29, avgOrder: 4431034 },
  { month: 'Feb 2026', revenue: 141200000, orders: 31, avgOrder: 4554839 },
  { month: 'Mar 2026', revenue: 175800000, orders: 38, avgOrder: 4626316 },
  { month: 'Apr 2026', revenue: 152600000, orders: 35, avgOrder: 4360000 },
  { month: 'May 2026', revenue: 161900000, orders: 37, avgOrder: 4375676 },
  { month: 'Jun 2026 (MTD)', revenue: 185750000, orders: 42, avgOrder: 4422619 },
];

// ── 2. INVENTORY & STOCK ─────────────────────────────────────────────────────
export const INVENTORY_SUMMARY = {
  period: 'As of 21 June 2026',
  totalStockMT: 48750,
  totalValuation: 182812500,
  lowStockItems: 2,
  criticalItems: 1,
  lastAuditDate: '2026-06-18',
};

export const STOCK_FLAT = [
  { port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 12400, ratePerMT: 4200, valuation: 52080000, status: 'Healthy', lastMovement: '2026-06-20' },
  { port: 'Mundra Port', coalType: 'South African Coal (6000 NAR)', quantityMT: 8600, ratePerMT: 5500, valuation: 47300000, status: 'Healthy', lastMovement: '2026-06-19' },
  { port: 'Mundra Port', coalType: 'US Coal (6800 NAR)', quantityMT: 4200, ratePerMT: 7200, valuation: 30240000, status: 'Healthy', lastMovement: '2026-06-18' },
  { port: 'Mundra Port', coalType: 'Indonesian Coal (3800 GAR)', quantityMT: 980, ratePerMT: 2800, valuation: 2744000, status: 'Low', lastMovement: '2026-06-17' },
  { port: 'Kandla Port', coalType: 'South African Coal (6000 NAR)', quantityMT: 6800, ratePerMT: 5500, valuation: 37400000, status: 'Healthy', lastMovement: '2026-06-20' },
  { port: 'Kandla Port', coalType: 'Russian Coal (6000 NAR)', quantityMT: 3500, ratePerMT: 5200, valuation: 18200000, status: 'Healthy', lastMovement: '2026-06-16' },
  { port: 'Paradip Port', coalType: 'US Coal (6800 NAR)', quantityMT: 5800, ratePerMT: 7200, valuation: 41760000, status: 'Healthy', lastMovement: '2026-06-19' },
  { port: 'Paradip Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 420, ratePerMT: 4200, valuation: 1764000, status: 'Critical', lastMovement: '2026-06-14' },
  { port: 'Vizag Port', coalType: 'Russian Coal (6000 NAR)', quantityMT: 2900, ratePerMT: 5200, valuation: 15080000, status: 'Healthy', lastMovement: '2026-06-18' },
  { port: 'Vizag Port', coalType: 'South African Coal (5500 NAR)', quantityMT: 950, ratePerMT: 4800, valuation: 4560000, status: 'Low', lastMovement: '2026-06-15' },
  { port: 'Hazira Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 2200, ratePerMT: 4200, valuation: 9240000, status: 'Healthy', lastMovement: '2026-06-17' },
];

export const STOCK_MOVEMENTS = [
  { date: '2026-06-20', port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', type: 'Dispatch', quantityMT: 1000, reference: 'SHCC-1248', balanceAfter: 12400 },
  { date: '2026-06-19', port: 'Mundra Port', coalType: 'South African Coal (6000 NAR)', type: 'Receipt', quantityMT: 3500, reference: 'GRN-0891', balanceAfter: 8600 },
  { date: '2026-06-18', port: 'Paradip Port', coalType: 'US Coal (6800 NAR)', type: 'Dispatch', quantityMT: 600, reference: 'SHCC-1246', balanceAfter: 5800 },
  { date: '2026-06-17', port: 'Kandla Port', coalType: 'Russian Coal (6000 NAR)', type: 'Dispatch', quantityMT: 700, reference: 'SHCC-1245', balanceAfter: 3500 },
  { date: '2026-06-16', port: 'Vizag Port', coalType: 'Russian Coal (6000 NAR)', type: 'Receipt', quantityMT: 2900, reference: 'GRN-0890', balanceAfter: 2900 },
  { date: '2026-06-15', port: 'Mundra Port', coalType: 'Indonesian Coal (3800 GAR)', type: 'Dispatch', quantityMT: 2250, reference: 'SHCC-1244', balanceAfter: 980 },
  { date: '2026-06-14', port: 'Hazira Port', coalType: 'Indonesian Coal (5500 GAR)', type: 'Receipt', quantityMT: 2200, reference: 'GRN-0889', balanceAfter: 2200 },
  { date: '2026-06-13', port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', type: 'Dispatch', quantityMT: 900, reference: 'SHCC-1248-B2', balanceAfter: 13400 },
];

// ── 3. FINANCIAL ANALYSIS ────────────────────────────────────────────────────
export const FINANCIAL_SUMMARY = {
  period: 'Q1 FY 2026-27 (Apr–Jun 2026)',
  grossRevenue: 519250000,
  totalCOGS: 378254000,
  grossProfit: 140996000,
  grossMarginPct: 27.15,
  operatingExpenses: 28640000,
  ebitda: 112356000,
  ebitdaMarginPct: 21.64,
  netProfit: 75502600,
  netMarginPct: 14.54,
};

export const FINANCIAL_PL = [
  { lineItem: 'Gross Revenue from Coal Sales', amount: 519250000, category: 'Revenue' },
  { lineItem: 'Less: Freight & Logistics', amount: -28175000, category: 'COGS' },
  { lineItem: 'Less: Cost of Coal Procurement', amount: -350079000, category: 'COGS' },
  { lineItem: 'Gross Profit', amount: 140996000, category: 'Profit' },
  { lineItem: 'Less: Employee Salaries', amount: -12400000, category: 'OpEx' },
  { lineItem: 'Less: Port Handling & Demurrage', amount: -8240000, category: 'OpEx' },
  { lineItem: 'Less: Admin & Office Overheads', amount: -5200000, category: 'OpEx' },
  { lineItem: 'Less: Marketing & Business Dev.', amount: -2800000, category: 'OpEx' },
  { lineItem: 'EBITDA', amount: 112356000, category: 'Profit' },
  { lineItem: 'Less: Depreciation', amount: -4820000, category: 'Non-Cash' },
  { lineItem: 'Less: Interest / Loan Repayment', amount: -6200000, category: 'Finance' },
  { lineItem: 'Profit Before Tax (PBT)', amount: 101336000, category: 'Profit' },
  { lineItem: 'Less: Income Tax (25.17%)', amount: -25834000, category: 'Tax' },
  { lineItem: 'Net Profit After Tax (PAT)', amount: 75502600, category: 'Profit' },
];

export const QUARTERLY_COMPARISON = [
  { quarter: 'Q4 FY25-26 (Jan–Mar 2026)', revenue: 445800000, grossProfit: 119750000, netProfit: 64300000, marginPct: 14.4 },
  { quarter: 'Q1 FY26-27 (Apr–Jun 2026)', revenue: 519250000, grossProfit: 140996000, netProfit: 75502600, marginPct: 14.5 },
];

// ── 4. GST & TAXATION ────────────────────────────────────────────────────────
export const GST_SUMMARY = {
  period: 'June 2026',
  totalTaxableValue: 157600000,
  totalIGST: 14184000,
  totalCGST: 0,
  totalSGST: 0,
  totalTCS: 1576000,
  netGSTLiability: 14184000,
  itcAvailable: 8620000,
  netPayable: 5564000,
};

export const GST_INVOICE_REGISTER = [
  { invoiceNo: 'SHCC/2026-27/001', date: '2026-06-10', customer: 'Adani Power Ltd', gstin: '24AAACA0415H2ZO', hsnCode: '2701', taxableValue: 12375000, igstRate: 5, igstAmt: 618750, tcs: 123750, totalInvoice: 13117500 },
  { invoiceNo: 'SHCC/2026-27/002', date: '2026-06-09', customer: 'Tata Power Company', gstin: '27AAACT3946E1Z4', hsnCode: '2701', taxableValue: 10520000, igstRate: 5, igstAmt: 526000, tcs: 105200, totalInvoice: 11151200 },
  { invoiceNo: 'SHCC/2026-27/003', date: '2026-06-08', customer: 'Jindal Steel & Power', gstin: '13AAACJ0727N2ZS', hsnCode: '2701', taxableValue: 8700000, igstRate: 5, igstAmt: 435000, tcs: 87000, totalInvoice: 9222000 },
  { invoiceNo: 'SHCC/2026-27/004', date: '2026-06-07', customer: 'Vedanta Aluminium', gstin: '21AAACV1973H2ZQ', hsnCode: '2701', taxableValue: 17700000, igstRate: 5, igstAmt: 885000, tcs: 177000, totalInvoice: 18762000 },
  { invoiceNo: 'SHCC/2026-27/005', date: '2026-06-05', customer: 'Ultratech Cement', gstin: '27AAACL0027A1Z9', hsnCode: '2701', taxableValue: 18575000, igstRate: 5, igstAmt: 928750, tcs: 185750, totalInvoice: 19689500 },
  { invoiceNo: 'SHCC/2026-27/006', date: '2026-06-02', customer: 'NTPC Ltd', gstin: '07AABCN0097C1ZE', hsnCode: '2701', taxableValue: 32250000, igstRate: 5, igstAmt: 1612500, tcs: 322500, totalInvoice: 34185000 },
  { invoiceNo: 'SHCC/2026-27/007', date: '2026-06-01', customer: 'JSW Energy Ltd', gstin: '27AABCJ3663C1ZY', hsnCode: '2701', taxableValue: 10670000, igstRate: 5, igstAmt: 533500, tcs: 106700, totalInvoice: 11310200 },
  { invoiceNo: 'SHCC/2026-27/008', date: '2026-05-29', customer: 'Reliance Industries', gstin: '27AAACR5055K1ZZ', hsnCode: '2701', taxableValue: 18880000, igstRate: 5, igstAmt: 944000, tcs: 188800, totalInvoice: 20012800 },
  { invoiceNo: 'SHCC/2026-27/009', date: '2026-05-27', customer: 'Hindalco Industries', gstin: '16AAACH4021H1Z8', hsnCode: '2701', taxableValue: 16520000, igstRate: 5, igstAmt: 826000, tcs: 165200, totalInvoice: 17511200 },
];

// ── 5. ORDERS LIFECYCLE ──────────────────────────────────────────────────────
export const ORDERS_LIFECYCLE_SUMMARY = {
  period: 'June 2026 (MTD)',
  totalOrders: 42,
  pending: 8,
  processing: 11,
  shipped: 9,
  delivered: 12,
  cancelled: 2,
  avgProcessingDays: 3.2,
  avgDeliveryDays: 8.7,
  fulfillmentRate: 95.2,
};

export const ORDERS_LIFECYCLE_RECORDS = [
  { orderId: 'SHCC-1248', customer: 'Adani Power Ltd', placedOn: '2026-06-10', approvedOn: '2026-06-11', shippedOn: '2026-06-12', deliveredOn: '2026-06-14', processingDays: 1, deliveryDays: 3, quantityMT: 2500, status: 'Delivered' },
  { orderId: 'SHCC-1247', customer: 'Tata Power Company', placedOn: '2026-06-09', approvedOn: '2026-06-10', shippedOn: '2026-06-11', deliveredOn: '—', processingDays: 1, deliveryDays: null, quantityMT: 1800, status: 'Shipped' },
  { orderId: 'SHCC-1246', customer: 'Jindal Steel & Power', placedOn: '2026-06-08', approvedOn: '2026-06-09', shippedOn: '—', deliveredOn: '—', processingDays: 1, deliveryDays: null, quantityMT: 1200, status: 'Processing' },
  { orderId: 'SHCC-1245', customer: 'Vedanta Aluminium', placedOn: '2026-06-07', approvedOn: '—', shippedOn: '—', deliveredOn: '—', processingDays: null, deliveryDays: null, quantityMT: 3000, status: 'Pending' },
  { orderId: 'SHCC-1244', customer: 'Ultratech Cement', placedOn: '2026-06-05', approvedOn: '2026-06-06', shippedOn: '2026-06-08', deliveredOn: '2026-06-11', processingDays: 1, deliveryDays: 5, quantityMT: 4500, status: 'Delivered' },
  { orderId: 'SHCC-1242', customer: 'NTPC Ltd', placedOn: '2026-06-02', approvedOn: '2026-06-02', shippedOn: '2026-06-04', deliveredOn: '2026-06-09', processingDays: 0, deliveryDays: 5, quantityMT: 5000, status: 'Delivered' },
  { orderId: 'SHCC-1241', customer: 'JSW Energy Ltd', placedOn: '2026-06-01', approvedOn: '2026-06-01', shippedOn: '2026-06-03', deliveredOn: '2026-06-07', processingDays: 0, deliveryDays: 4, quantityMT: 2200, status: 'Delivered' },
  { orderId: 'SHCC-1240', customer: 'Reliance Industries', placedOn: '2026-05-29', approvedOn: '2026-05-30', shippedOn: '2026-06-01', deliveredOn: '2026-06-05', processingDays: 1, deliveryDays: 5, quantityMT: 3200, status: 'Delivered' },
  { orderId: 'SHCC-1243', customer: 'Ambuja Cements', placedOn: '2026-06-03', approvedOn: '—', shippedOn: '—', deliveredOn: '—', processingDays: null, deliveryDays: null, quantityMT: 1500, status: 'Cancelled' },
];

// ── 6. CUSTOMERS TRANSACTION LEDGER ─────────────────────────────────────────
export const CUSTOMER_LEDGER_SUMMARY = {
  period: 'FY 2026-27 (Apr–Jun 2026)',
  totalCustomers: 24,
  activeCustomers: 21,
  totalBilled: 519250000,
  totalCollected: 468325000,
  totalOutstanding: 50925000,
  avgCreditDays: 32,
  overdueAccounts: 3,
};

export const CUSTOMER_ACCOUNTS = [
  { customerId: 'CUST-001', name: 'Adani Power Ltd', gstin: '24AAACA0415H2ZO', totalOrders: 8, totalBilled: 87650000, paid: 87650000, outstanding: 0, avgPaymentDays: 28, creditLimit: 100000000, status: 'Clear' },
  { customerId: 'CUST-002', name: 'Tata Power Company', gstin: '27AAACT3946E1Z4', totalOrders: 6, totalBilled: 68420000, paid: 62000000, outstanding: 6420000, avgPaymentDays: 35, creditLimit: 80000000, status: 'Outstanding' },
  { customerId: 'CUST-003', name: 'Jindal Steel & Power', gstin: '13AAACJ0727N2ZS', totalOrders: 5, totalBilled: 47850000, paid: 47850000, outstanding: 0, avgPaymentDays: 22, creditLimit: 60000000, status: 'Clear' },
  { customerId: 'CUST-004', name: 'Vedanta Aluminium', gstin: '21AAACV1973H2ZQ', totalOrders: 4, totalBilled: 75400000, paid: 45000000, outstanding: 30400000, avgPaymentDays: 48, creditLimit: 80000000, status: 'Overdue' },
  { customerId: 'CUST-005', name: 'Ultratech Cement', gstin: '27AAACL0027A1Z9', totalOrders: 7, totalBilled: 62250000, paid: 62250000, outstanding: 0, avgPaymentDays: 25, creditLimit: 75000000, status: 'Clear' },
  { customerId: 'CUST-006', name: 'NTPC Ltd', gstin: '07AABCN0097C1ZE', totalOrders: 5, totalBilled: 85200000, paid: 81200000, outstanding: 4000000, avgPaymentDays: 30, creditLimit: 100000000, status: 'Outstanding' },
  { customerId: 'CUST-007', name: 'JSW Energy Ltd', gstin: '27AABCJ3663C1ZY', totalOrders: 6, totalBilled: 58900000, paid: 58900000, outstanding: 0, avgPaymentDays: 20, creditLimit: 70000000, status: 'Clear' },
  { customerId: 'CUST-008', name: 'Reliance Industries', gstin: '27AAACR5055K1ZZ', totalOrders: 4, totalBilled: 82500000, paid: 72500000, outstanding: 10000000, avgPaymentDays: 38, creditLimit: 100000000, status: 'Outstanding' },
  { customerId: 'CUST-009', name: 'Hindalco Industries', gstin: '16AAACH4021H1Z8', totalOrders: 3, totalBilled: 54100000, paid: 54100000, outstanding: 0, avgPaymentDays: 27, creditLimit: 60000000, status: 'Clear' },
];

export const CUSTOMER_TRANSACTIONS = [
  { date: '2026-06-14', customer: 'Adani Power Ltd', invoiceNo: 'SHCC/2026-27/001', invoiceAmt: 13117500, paymentAmt: 13117500, paymentMode: 'RTGS', referenceNo: 'RTGS2026061401', balanceAfter: 0 },
  { date: '2026-06-12', customer: 'Ultratech Cement', invoiceNo: 'SHCC/2026-27/005', invoiceAmt: 19689500, paymentAmt: 19689500, paymentMode: 'NEFT', referenceNo: 'NEFT20260612ULT', balanceAfter: 0 },
  { date: '2026-06-10', customer: 'Tata Power Company', invoiceNo: 'SHCC/2026-27/002', invoiceAmt: 11151200, paymentAmt: 5000000, paymentMode: 'RTGS', referenceNo: 'RTGS2026061002', balanceAfter: 6151200 },
  { date: '2026-06-09', customer: 'Jindal Steel & Power', invoiceNo: 'SHCC/2026-27/003', invoiceAmt: 9222000, paymentAmt: 9222000, paymentMode: 'Cheque', referenceNo: 'CHQ-220491', balanceAfter: 0 },
  { date: '2026-06-07', customer: 'NTPC Ltd', invoiceNo: 'SHCC/2026-27/006', invoiceAmt: 34185000, paymentAmt: 30185000, paymentMode: 'RTGS', referenceNo: 'RTGS2026060706', balanceAfter: 4000000 },
  { date: '2026-06-05', customer: 'JSW Energy Ltd', invoiceNo: 'SHCC/2026-27/007', invoiceAmt: 11310200, paymentAmt: 11310200, paymentMode: 'RTGS', referenceNo: 'RTGS2026060507', balanceAfter: 0 },
  { date: '2026-06-04', customer: 'Reliance Industries', invoiceNo: 'SHCC/2026-27/008', invoiceAmt: 20012800, paymentAmt: 10012800, paymentMode: 'NEFT', referenceNo: 'NEFT20260604REL', balanceAfter: 10000000 },
  { date: '2026-06-02', customer: 'Hindalco Industries', invoiceNo: 'SHCC/2026-27/009', invoiceAmt: 17511200, paymentAmt: 17511200, paymentMode: 'RTGS', referenceNo: 'RTGS2026060209', balanceAfter: 0 },
];

// ── 7. DISPATCH & OPERATIONS (Port Admin) ────────────────────────────────────
export const DISPATCH_SUMMARY = {
  period: 'June 2026 (MTD)',
  totalDispatches: 18,
  totalDispatchedMT: 24600,
  ordersFullyDelivered: 6,
  ordersPartiallyDelivered: 4,
  avgTurnaroundHrs: 14.2,
  vehiclesDeployed: 48,
};

export const DISPATCH_LOG = [
  { dispatchId: 'DIS-0091', date: '2026-06-20', orderId: 'SHCC-1248', customer: 'Adani Power Ltd', port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 1000, vehicleNo: 'GJ01-AB1234', driverName: 'Ramesh Patel', departureTime: '06:30', arrivalTime: '14:45', status: 'Completed' },
  { dispatchId: 'DIS-0090', date: '2026-06-19', orderId: 'SHCC-1248', customer: 'Adani Power Ltd', port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 900, vehicleNo: 'GJ01-CD5678', driverName: 'Suresh Mehta', departureTime: '07:00', arrivalTime: '15:20', status: 'Completed' },
  { dispatchId: 'DIS-0089', date: '2026-06-18', orderId: 'SHCC-1246', customer: 'Jindal Steel & Power', port: 'Paradip Port', coalType: 'US Coal (6800 NAR)', quantityMT: 600, vehicleNo: 'OD02-XY4321', driverName: 'Bijay Nayak', departureTime: '08:15', arrivalTime: '18:00', status: 'Completed' },
  { dispatchId: 'DIS-0088', date: '2026-06-17', orderId: 'SHCC-1245', customer: 'Vedanta Aluminium', port: 'Vizag Port', coalType: 'Russian Coal (6000 NAR)', quantityMT: 700, vehicleNo: 'AP09-MN8765', driverName: 'Krishna Rao', departureTime: '05:45', arrivalTime: '16:30', status: 'Completed' },
  { dispatchId: 'DIS-0087', date: '2026-06-15', orderId: 'SHCC-1244', customer: 'Ultratech Cement', port: 'Mundra Port', coalType: 'Indonesian Coal (3800 GAR)', quantityMT: 2250, vehicleNo: 'GJ02-EF9012', driverName: 'Mahesh Shah', departureTime: '06:00', arrivalTime: '13:30', status: 'Completed' },
  { dispatchId: 'DIS-0086', date: '2026-06-14', orderId: 'SHCC-1248', customer: 'Adani Power Ltd', port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 600, vehicleNo: 'GJ03-GH2345', driverName: 'Ravi Chauhan', departureTime: '07:30', arrivalTime: '15:00', status: 'Completed' },
  { dispatchId: 'DIS-0085', date: '2026-06-13', orderId: 'SHCC-1242', customer: 'NTPC Ltd', port: 'Mundra Port', coalType: 'US Coal (6800 NAR)', quantityMT: 2500, vehicleNo: 'GJ01-IJ6789', driverName: 'Dilip Trivedi', departureTime: '05:00', arrivalTime: '12:15', status: 'Completed' },
  { dispatchId: 'DIS-0084', date: '2026-06-12', orderId: 'SHCC-1241', customer: 'JSW Energy Ltd', port: 'Mundra Port', coalType: 'Indonesian Coal (5500 GAR)', quantityMT: 1100, vehicleNo: 'GJ04-KL1230', driverName: 'Pratik Modi', departureTime: '06:45', arrivalTime: '14:00', status: 'Completed' },
  { dispatchId: 'DIS-0083', date: '2026-06-11', orderId: 'SHCC-1240', customer: 'Reliance Industries', port: 'Kandla Port', coalType: 'South African Coal (6000 NAR)', quantityMT: 1600, vehicleNo: 'GJ05-MN4560', driverName: 'Ankit Joshi', departureTime: '07:15', arrivalTime: '11:45', status: 'Completed' },
  { dispatchId: 'DIS-0082', date: '2026-06-10', orderId: 'SHCC-1239', customer: 'Hindalco Industries', port: 'Vizag Port', coalType: 'Russian Coal (6000 NAR)', quantityMT: 1400, vehicleNo: 'AP07-OP7890', driverName: 'Sai Reddy', departureTime: '06:00', arrivalTime: '17:30', status: 'Completed' },
];

// ── 8. SALESPERSON DATA ───────────────────────────────────────────────────────
export const SALESPERSON_SALES_SUMMARY = {
  period: 'June 2026 (MTD)',
  salesperson: 'Rahul Verma',
  totalOrders: 18,
  totalRevenue: 82400000,
  targetRevenue: 100000000,
  achievementPct: 82.4,
  avgOrderValue: 4577778,
  newCustomers: 2,
  repeatCustomers: 6,
};

export const SALESPERSON_ORDER_LIST = [
  { orderId: 'SHCC-1248', date: '2026-06-10', customer: 'Adani Power Ltd', coalType: 'Indonesian Coal (5500 GAR)', port: 'Mundra Port', quantityMT: 2500, totalAmount: 13750000, status: 'Delivered' },
  { orderId: 'SHCC-1247', date: '2026-06-09', customer: 'Tata Power Company', coalType: 'South African Coal (6000 NAR)', port: 'Kandla Port', quantityMT: 1800, totalAmount: 11700000, status: 'Shipped' },
  { orderId: 'SHCC-1244', date: '2026-06-05', customer: 'Ultratech Cement', coalType: 'Indonesian Coal (3800 GAR)', port: 'Mundra Port', quantityMT: 4500, totalAmount: 20250000, status: 'Delivered' },
  { orderId: 'SHCC-1242', date: '2026-06-02', customer: 'NTPC Ltd', coalType: 'US Coal (6800 NAR)', port: 'Mundra Port', quantityMT: 5000, totalAmount: 35000000, status: 'Delivered' },
  { orderId: 'SHCC-1241', date: '2026-06-01', customer: 'JSW Energy Ltd', coalType: 'Indonesian Coal (5500 GAR)', port: 'Mundra Port', quantityMT: 2200, totalAmount: 11850000, status: 'Delivered' },
];

export const SALESPERSON_CLIENT_ACCOUNTS = [
  { customerId: 'CUST-001', name: 'Adani Power Ltd', totalOrdersThisPeriod: 3, totalRevenue: 38600000, outstandingBalance: 0, lastOrderDate: '2026-06-10', relationshipSince: 'Mar 2024', status: 'Active' },
  { customerId: 'CUST-002', name: 'Tata Power Company', totalOrdersThisPeriod: 2, totalRevenue: 21300000, outstandingBalance: 6420000, lastOrderDate: '2026-06-09', relationshipSince: 'Jan 2024', status: 'Active' },
  { customerId: 'CUST-005', name: 'Ultratech Cement', totalOrdersThisPeriod: 2, totalRevenue: 32100000, outstandingBalance: 0, lastOrderDate: '2026-06-05', relationshipSince: 'Jun 2024', status: 'Active' },
  { customerId: 'CUST-006', name: 'NTPC Ltd', totalOrdersThisPeriod: 2, totalRevenue: 59500000, outstandingBalance: 4000000, lastOrderDate: '2026-06-02', relationshipSince: 'Sep 2024', status: 'Active' },
  { customerId: 'CUST-007', name: 'JSW Energy Ltd', totalOrdersThisPeriod: 2, totalRevenue: 22400000, outstandingBalance: 0, lastOrderDate: '2026-06-01', relationshipSince: 'Dec 2024', status: 'Active' },
];

// ── 9. REVENUE STREAMS (Finance) ─────────────────────────────────────────────
export const REVENUE_STREAM_SUMMARY = {
  period: 'Q1 FY 2026-27',
  totalRevenue: 519250000,
  coalSalesRevenue: 490000000,
  freightRecovery: 17250000,
  gstCollected: 23688000,
  tcsCollected: 2312000,
  netRevenueExcludingTax: 507312000,
};

export const REVENUE_BY_CHANNEL = [
  { channel: 'Direct Corporate Sales', revenue: 387500000, orders: 28, avgOrderValue: 13839286, revenueShare: 74.6 },
  { channel: 'Government / PSU Orders', revenue: 85200000, orders: 8, avgOrderValue: 10650000, revenueShare: 16.4 },
  { channel: 'Export / Port-Based Orders', revenue: 46550000, orders: 6, avgOrderValue: 7758333, revenueShare: 9.0 },
];

// ── 10. INVOICE AGING (Finance) ───────────────────────────────────────────────
export const INVOICE_AGING = [
  { invoiceNo: 'SHCC/2026-27/002', customer: 'Tata Power Company', invoiceDate: '2026-06-09', dueDate: '2026-07-09', invoiceAmt: 11151200, paidAmt: 5000000, outstanding: 6151200, daysOverdue: 0, agingBucket: 'Current (0-30 days)' },
  { invoiceNo: 'SHCC/2026-27/006', customer: 'NTPC Ltd', invoiceDate: '2026-06-07', dueDate: '2026-07-07', invoiceAmt: 34185000, paidAmt: 30185000, outstanding: 4000000, daysOverdue: 0, agingBucket: 'Current (0-30 days)' },
  { invoiceNo: 'SHCC/2026-27/008', customer: 'Reliance Industries', invoiceDate: '2026-05-29', dueDate: '2026-06-28', invoiceAmt: 20012800, paidAmt: 10012800, outstanding: 10000000, daysOverdue: 7, agingBucket: '31-60 days' },
  { invoiceNo: 'SHCC/2026-27/004', customer: 'Vedanta Aluminium', invoiceDate: '2026-06-07', dueDate: '2026-07-07', invoiceAmt: 18762000, paidAmt: 0, outstanding: 18762000, daysOverdue: 0, agingBucket: 'Current (0-30 days)' },
  { invoiceNo: 'SHCC/2025-26/198', customer: 'Vedanta Aluminium', invoiceDate: '2026-04-15', dueDate: '2026-05-15', invoiceAmt: 16250000, paidAmt: 5000000, outstanding: 11250000, daysOverdue: 37, agingBucket: '31-60 days' },
];
