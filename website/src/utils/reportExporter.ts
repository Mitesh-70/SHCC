// ─────────────────────────────────────────────────────────────────────────────
//  SHCC REPORT EXPORTER  –  Handles PDF / Excel / CSV downloads
//  All business data is imported from reportData.ts (isolated dummy layer).
//  Replace data imports with API calls when backend is ready.
// ─────────────────────────────────────────────────────────────────────────────

import jsPDF from 'jspdf';
import autoTable from 'jspdf-autotable';
import * as XLSX from 'xlsx';

import {
  COMPANY,
  SALES_SUMMARY, SALES_BY_COAL_TYPE, SALES_ORDERS, MONTHLY_REVENUE_TREND,
  INVENTORY_SUMMARY, STOCK_FLAT, STOCK_MOVEMENTS,
  FINANCIAL_SUMMARY, FINANCIAL_PL, QUARTERLY_COMPARISON,
  GST_SUMMARY, GST_INVOICE_REGISTER,
  ORDERS_LIFECYCLE_SUMMARY, ORDERS_LIFECYCLE_RECORDS,
  CUSTOMER_LEDGER_SUMMARY, CUSTOMER_ACCOUNTS, CUSTOMER_TRANSACTIONS,
  DISPATCH_SUMMARY, DISPATCH_LOG,
  SALESPERSON_SALES_SUMMARY, SALESPERSON_ORDER_LIST, SALESPERSON_CLIENT_ACCOUNTS,
  REVENUE_STREAM_SUMMARY, REVENUE_BY_CHANNEL,
  INVOICE_AGING,
} from '../data/reportData';

// ── Helpers ───────────────────────────────────────────────────────────────────

const cr = (v: number) => `₹${(v / 10000000).toFixed(2)} Cr`;
const lakh = (v: number) => `₹${(v / 100000).toFixed(2)} L`;
const fmt = (v: number) => `₹${v.toLocaleString('en-IN')}`;
const now = () => new Date().toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });

// ── PDF Builder helpers ────────────────────────────────────────────────────────

function pdfHeader(doc: jsPDF, title: string, subtitle: string) {
  // Orange header bar
  doc.setFillColor(249, 115, 22);
  doc.rect(0, 0, 210, 28, 'F');

  doc.setTextColor(255, 255, 255);
  doc.setFontSize(14);
  doc.setFont('helvetica', 'bold');
  doc.text(COMPANY.name, 14, 11);

  doc.setFontSize(9);
  doc.setFont('helvetica', 'normal');
  doc.text(COMPANY.address, 14, 17);
  doc.text(`GSTIN: ${COMPANY.gstin}  |  PAN: ${COMPANY.pan}`, 14, 22);

  // Report title box
  doc.setFillColor(255, 247, 237);
  doc.rect(0, 28, 210, 16, 'F');
  doc.setTextColor(180, 60, 0);
  doc.setFontSize(13);
  doc.setFont('helvetica', 'bold');
  doc.text(title, 14, 38);
  doc.setFontSize(8);
  doc.setFont('helvetica', 'normal');
  doc.setTextColor(120, 80, 20);
  doc.text(`${subtitle}   |   Generated: ${now()}`, 14, 44);

  doc.setTextColor(30, 30, 30);
}

function sectionTitle(doc: jsPDF, y: number, text: string): number {
  doc.setFillColor(243, 244, 246);
  doc.rect(12, y, 186, 7, 'F');
  doc.setFontSize(8);
  doc.setFont('helvetica', 'bold');
  doc.setTextColor(100, 100, 100);
  doc.text(text.toUpperCase(), 14, y + 5);
  doc.setTextColor(30, 30, 30);
  return y + 10;
}

function kpiRow(doc: jsPDF, y: number, items: { label: string; value: string }[]): number {
  const colW = 186 / items.length;
  items.forEach((item, i) => {
    const x = 12 + i * colW;
    doc.setFillColor(255, 251, 245);
    doc.roundedRect(x, y, colW - 2, 14, 2, 2, 'F');
    doc.setFontSize(7);
    doc.setFont('helvetica', 'normal');
    doc.setTextColor(120, 120, 120);
    doc.text(item.label, x + 3, y + 5);
    doc.setFontSize(9);
    doc.setFont('helvetica', 'bold');
    doc.setTextColor(30, 30, 30);
    doc.text(item.value, x + 3, y + 11);
  });
  doc.setTextColor(30, 30, 30);
  return y + 18;
}

function pdfFooter(doc: jsPDF) {
  const pages = (doc as any).internal.getNumberOfPages();
  for (let i = 1; i <= pages; i++) {
    doc.setPage(i);
    doc.setFontSize(7);
    doc.setTextColor(150, 150, 150);
    doc.setFont('helvetica', 'normal');
    doc.text(`${COMPANY.name}  |  ${COMPANY.email}  |  CONFIDENTIAL`, 14, 290);
    doc.text(`Page ${i} of ${pages}`, 186, 290, { align: 'right' });
  }
}

// ── CSV downloader ────────────────────────────────────────────────────────────

function downloadCSV(filename: string, headers: string[], rows: (string | number | null)[][][]) {
  const all: string[][] = [headers];
  rows.forEach(section => section.forEach(row => all.push(row.map(c => String(c ?? '')))));
  const csv = all.map(r => r.map(c => `"${c.replace(/"/g, '""')}"`).join(',')).join('\n');
  const blob = new Blob(['\uFEFF' + csv], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url; a.download = filename; a.click();
  URL.revokeObjectURL(url);
}

// ── Excel helper ──────────────────────────────────────────────────────────────

function downloadXLSX(filename: string, sheets: { name: string; data: (string | number | null)[][] }[]) {
  const wb = XLSX.utils.book_new();
  sheets.forEach(s => {
    const ws = XLSX.utils.aoa_to_sheet(s.data);
    XLSX.utils.book_append_sheet(wb, ws, s.name.slice(0, 31));
  });
  XLSX.writeFile(wb, filename);
}

// ═════════════════════════════════════════════════════════════════════════════
//  REPORT GENERATORS
// ═════════════════════════════════════════════════════════════════════════════

// ── SALES & REVENUE ───────────────────────────────────────────────────────────

function salesPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Sales & Revenue Report', `Period: ${SALES_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Executive Summary – Key Metrics');
  y = kpiRow(doc, y, [
    { label: 'Total Revenue', value: cr(SALES_SUMMARY.totalRevenue) },
    { label: 'Total Orders', value: String(SALES_SUMMARY.totalOrders) },
    { label: 'Avg Order Value', value: lakh(SALES_SUMMARY.avgOrderValue) },
    { label: 'Revenue Growth (MoM)', value: `+${SALES_SUMMARY.revenueGrowth}%` },
  ]);
  y = kpiRow(doc, y, [
    { label: 'Top Coal Type', value: SALES_SUMMARY.topCoalType },
    { label: 'Top Port', value: SALES_SUMMARY.topPort },
    { label: 'Order Growth (MoM)', value: `+${SALES_SUMMARY.ordersGrowth}%` },
    { label: 'Report Date', value: now() },
  ]);

  y = sectionTitle(doc, y, 'Revenue by Coal Type');
  autoTable(doc, {
    startY: y,
    head: [['Coal Type', 'Orders', 'Quantity (MT)', 'Revenue', 'Revenue Share %']],
    body: SALES_BY_COAL_TYPE.map(r => [r.coalType, r.orders, r.quantityMT.toLocaleString(), cr(r.revenue), `${r.revenueShare}%`]),
    styles: { fontSize: 7.5, cellPadding: 2.5 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  y = sectionTitle(doc, y, 'Monthly Revenue Trend');
  autoTable(doc, {
    startY: y,
    head: [['Month', 'Revenue', 'Orders', 'Avg Order Value']],
    body: MONTHLY_REVENUE_TREND.map(r => [r.month, cr(r.revenue), r.orders, lakh(r.avgOrder)]),
    styles: { fontSize: 7.5, cellPadding: 2.5 },
    headStyles: { fillColor: [30, 58, 138], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [239, 246, 255] },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  y = sectionTitle(doc, y, 'Order Transactional Detail');
  autoTable(doc, {
    startY: y,
    head: [['Order ID', 'Date', 'Customer', 'Coal Type', 'Port', 'Qty MT', 'Base Amt', 'GST', 'Total', 'Status']],
    body: SALES_ORDERS.map(r => [r.orderId, r.date, r.customer, r.coalType, r.port, r.quantityMT.toLocaleString(), cr(r.baseAmount), cr(r.gst), cr(r.totalAmount), r.status]),
    styles: { fontSize: 6.5, cellPadding: 2 },
    headStyles: { fillColor: [55, 65, 81], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [249, 250, 251] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Sales_Revenue_Report_${SALES_SUMMARY.period.replace(/\s/g, '_')}.pdf`);
}

function salesXLSX() {
  const summarySheet: (string | number | null)[][] = [
    ['SHCC – Sales & Revenue Report', '', '', ''],
    ['Period:', SALES_SUMMARY.period, 'Generated:', now()],
    [],
    ['EXECUTIVE SUMMARY'],
    ['Total Revenue', cr(SALES_SUMMARY.totalRevenue), 'Total Orders', SALES_SUMMARY.totalOrders],
    ['Avg Order Value', lakh(SALES_SUMMARY.avgOrderValue), 'Revenue Growth (MoM)', `+${SALES_SUMMARY.revenueGrowth}%`],
    ['Top Coal Type', SALES_SUMMARY.topCoalType, 'Top Port', SALES_SUMMARY.topPort],
    [],
    ['REVENUE BY COAL TYPE'],
    ['Coal Type', 'Orders', 'Quantity (MT)', 'Revenue (₹)', 'Revenue Share %'],
    ...SALES_BY_COAL_TYPE.map(r => [r.coalType, r.orders, r.quantityMT, r.revenue, r.revenueShare]),
    [],
    ['MONTHLY TREND'],
    ['Month', 'Revenue (₹)', 'Orders', 'Avg Order Value (₹)'],
    ...MONTHLY_REVENUE_TREND.map(r => [r.month, r.revenue, r.orders, r.avgOrder]),
  ];
  const ordersSheet: (string | number | null)[][] = [
    ['Order ID', 'Date', 'Customer', 'Salesperson', 'Coal Type', 'Port', 'Qty MT', 'Base Amount (₹)', 'Freight (₹)', 'GST (₹)', 'TCS (₹)', 'Total Amount (₹)', 'Status'],
    ...SALES_ORDERS.map(r => [r.orderId, r.date, r.customer, r.salesperson, r.coalType, r.port, r.quantityMT, r.baseAmount, r.freight, r.gst, r.tcs, r.totalAmount, r.status]),
  ];
  downloadXLSX(`SHCC_Sales_Revenue_Report.xlsx`, [
    { name: 'Summary', data: summarySheet },
    { name: 'Order Detail', data: ordersSheet },
    { name: 'Monthly Trend', data: [['Month', 'Revenue', 'Orders', 'Avg Order Value'], ...MONTHLY_REVENUE_TREND.map(r => [r.month, r.revenue, r.orders, r.avgOrder])] },
  ]);
}

function salesCSV() {
  downloadCSV('SHCC_Sales_Revenue_Report.csv',
    ['Order ID', 'Date', 'Customer', 'Salesperson', 'Coal Type', 'Port', 'Qty MT', 'Base Amount', 'Freight', 'GST', 'TCS', 'Total Amount', 'Status'],
    [SALES_ORDERS.map(r => [r.orderId, r.date, r.customer, r.salesperson, r.coalType, r.port, r.quantityMT, r.baseAmount, r.freight, r.gst, r.tcs, r.totalAmount, r.status])]
  );
}

// ── INVENTORY & STOCK ─────────────────────────────────────────────────────────

function inventoryPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Inventory & Stock Movement Report', `Period: ${INVENTORY_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Inventory Summary – Key Metrics');
  y = kpiRow(doc, y, [
    { label: 'Total Stock (MT)', value: INVENTORY_SUMMARY.totalStockMT.toLocaleString() },
    { label: 'Total Valuation', value: cr(INVENTORY_SUMMARY.totalValuation) },
    { label: 'Low Stock Items', value: String(INVENTORY_SUMMARY.lowStockItems) },
    { label: 'Critical Items', value: String(INVENTORY_SUMMARY.criticalItems) },
  ]);

  y = sectionTitle(doc, y, 'Stock Levels by Port & Coal Type');
  autoTable(doc, {
    startY: y,
    head: [['Port', 'Coal Type', 'Stock (MT)', 'Rate/MT (₹)', 'Valuation', 'Status', 'Last Movement']],
    body: STOCK_FLAT.map(r => [r.port, r.coalType, r.quantityMT.toLocaleString(), fmt(r.ratePerMT), cr(r.valuation), r.status, r.lastMovement]),
    styles: { fontSize: 7, cellPadding: 2.5 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    didDrawCell: (data: any) => {
      if (data.column.index === 5 && data.section === 'body') {
        const val = data.cell.raw as string;
        const colors: Record<string, [number, number, number]> = { Critical: [220, 38, 38], Low: [217, 119, 6], Healthy: [22, 163, 74] };
        const col = colors[val] ?? [100, 100, 100];
        doc.setTextColor(...col);
        doc.setFontSize(7);
        doc.setFont('helvetica', 'bold');
        doc.text(val, data.cell.x + 2, data.cell.y + data.cell.height / 2 + 1);
        doc.setTextColor(30, 30, 30);
        doc.setFont('helvetica', 'normal');
        return false;
      }
    },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  y = sectionTitle(doc, y, 'Recent Stock Movements');
  autoTable(doc, {
    startY: y,
    head: [['Date', 'Port', 'Coal Type', 'Type', 'Qty (MT)', 'Reference', 'Balance After (MT)']],
    body: STOCK_MOVEMENTS.map(r => [r.date, r.port, r.coalType, r.type, r.quantityMT.toLocaleString(), r.reference, r.balanceAfter.toLocaleString()]),
    styles: { fontSize: 7, cellPadding: 2.5 },
    headStyles: { fillColor: [30, 58, 138], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [239, 246, 255] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Inventory_Stock_Report.pdf`);
}

function inventoryXLSX() {
  downloadXLSX('SHCC_Inventory_Stock_Report.xlsx', [
    {
      name: 'Stock Levels', data: [
        ['SHCC – Inventory & Stock Report', '', '', '', '', '', ''],
        ['Period:', INVENTORY_SUMMARY.period, '', 'Total Stock MT:', INVENTORY_SUMMARY.totalStockMT, 'Valuation:', INVENTORY_SUMMARY.totalValuation],
        [],
        ['Port', 'Coal Type', 'Stock (MT)', 'Rate Per MT (₹)', 'Valuation (₹)', 'Status', 'Last Movement'],
        ...STOCK_FLAT.map(r => [r.port, r.coalType, r.quantityMT, r.ratePerMT, r.valuation, r.status, r.lastMovement]),
      ]
    },
    {
      name: 'Stock Movements', data: [
        ['Date', 'Port', 'Coal Type', 'Movement Type', 'Qty (MT)', 'Reference', 'Balance After (MT)'],
        ...STOCK_MOVEMENTS.map(r => [r.date, r.port, r.coalType, r.type, r.quantityMT, r.reference, r.balanceAfter]),
      ]
    },
  ]);
}

function inventoryCSV() {
  downloadCSV('SHCC_Inventory_Stock_Report.csv',
    ['Port', 'Coal Type', 'Stock (MT)', 'Rate Per MT', 'Valuation', 'Status', 'Last Movement'],
    [STOCK_FLAT.map(r => [r.port, r.coalType, r.quantityMT, r.ratePerMT, r.valuation, r.status, r.lastMovement])]
  );
}

// ── FINANCIAL ANALYSIS ────────────────────────────────────────────────────────

function financialPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Financial Analysis & Profit/Loss Statement', `Period: ${FINANCIAL_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Financial Performance – Key Indicators');
  y = kpiRow(doc, y, [
    { label: 'Gross Revenue', value: cr(FINANCIAL_SUMMARY.grossRevenue) },
    { label: 'Gross Profit', value: cr(FINANCIAL_SUMMARY.grossProfit) },
    { label: 'Gross Margin', value: `${FINANCIAL_SUMMARY.grossMarginPct}%` },
    { label: 'EBITDA', value: cr(FINANCIAL_SUMMARY.ebitda) },
  ]);
  y = kpiRow(doc, y, [
    { label: 'EBITDA Margin', value: `${FINANCIAL_SUMMARY.ebitdaMarginPct}%` },
    { label: 'Net Profit (PAT)', value: cr(FINANCIAL_SUMMARY.netProfit) },
    { label: 'Net Margin', value: `${FINANCIAL_SUMMARY.netMarginPct}%` },
    { label: 'OpEx Total', value: cr(FINANCIAL_SUMMARY.operatingExpenses) },
  ]);

  y = sectionTitle(doc, y, 'Profit & Loss Statement');
  autoTable(doc, {
    startY: y,
    head: [['Line Item', 'Category', 'Amount']],
    body: FINANCIAL_PL.map(r => [r.lineItem, r.category, r.amount < 0 ? `(${cr(Math.abs(r.amount))})` : cr(r.amount)]),
    styles: { fontSize: 8, cellPadding: 3 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    didDrawCell: (data: any) => {
      if (data.section === 'body' && data.column.index === 2) {
        const val = String(data.cell.raw);
        doc.setTextColor(val.startsWith('(') ? 200 : 22, val.startsWith('(') ? 30 : 100, val.startsWith('(') ? 30 : 30);
        doc.setFontSize(8);
        doc.setFont('helvetica', data.row.raw[1] === 'Profit' ? 'bold' : 'normal');
        doc.text(val, data.cell.x + data.cell.width - 2, data.cell.y + data.cell.height / 2 + 1, { align: 'right' });
        doc.setTextColor(30, 30, 30);
        doc.setFont('helvetica', 'normal');
        return false;
      }
    },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  y = sectionTitle(doc, y, 'Quarterly Comparison');
  autoTable(doc, {
    startY: y,
    head: [['Quarter', 'Revenue', 'Gross Profit', 'Net Profit (PAT)', 'Net Margin %']],
    body: QUARTERLY_COMPARISON.map(r => [r.quarter, cr(r.revenue), cr(r.grossProfit), cr(r.netProfit), `${r.marginPct}%`]),
    styles: { fontSize: 8, cellPadding: 3 },
    headStyles: { fillColor: [30, 58, 138], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [239, 246, 255] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Financial_PL_Report.pdf`);
}

function financialXLSX() {
  downloadXLSX('SHCC_Financial_PL_Report.xlsx', [
    {
      name: 'P&L Statement', data: [
        ['SHCC – Financial Analysis & P/L Report'],
        ['Period:', FINANCIAL_SUMMARY.period, 'Generated:', now()],
        [],
        ['KPI', 'Value'],
        ['Gross Revenue', FINANCIAL_SUMMARY.grossRevenue],
        ['Gross Profit', FINANCIAL_SUMMARY.grossProfit],
        ['Gross Margin %', FINANCIAL_SUMMARY.grossMarginPct],
        ['EBITDA', FINANCIAL_SUMMARY.ebitda],
        ['EBITDA Margin %', FINANCIAL_SUMMARY.ebitdaMarginPct],
        ['Net Profit (PAT)', FINANCIAL_SUMMARY.netProfit],
        ['Net Margin %', FINANCIAL_SUMMARY.netMarginPct],
        [],
        ['PROFIT & LOSS STATEMENT'],
        ['Line Item', 'Category', 'Amount (₹)'],
        ...FINANCIAL_PL.map(r => [r.lineItem, r.category, r.amount]),
        [],
        ['QUARTERLY COMPARISON'],
        ['Quarter', 'Revenue (₹)', 'Gross Profit (₹)', 'Net Profit (₹)', 'Net Margin %'],
        ...QUARTERLY_COMPARISON.map(r => [r.quarter, r.revenue, r.grossProfit, r.netProfit, r.marginPct]),
      ]
    },
  ]);
}

function financialCSV() {
  downloadCSV('SHCC_Financial_PL_Report.csv',
    ['Line Item', 'Category', 'Amount (INR)'],
    [FINANCIAL_PL.map(r => [r.lineItem, r.category, r.amount])]
  );
}

// ── GST & TAXATION ────────────────────────────────────────────────────────────

function gstPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'GST & Taxation Summary Report', `Period: ${GST_SUMMARY.period}  |  GSTIN: ${COMPANY.gstin}`);
  let y = 52;

  y = sectionTitle(doc, y, 'GST Liability Summary');
  y = kpiRow(doc, y, [
    { label: 'Total Taxable Value', value: cr(GST_SUMMARY.totalTaxableValue) },
    { label: 'Total IGST (5%)', value: cr(GST_SUMMARY.totalIGST) },
    { label: 'TCS Collected (1%)', value: cr(GST_SUMMARY.totalTCS) },
    { label: 'ITC Available', value: cr(GST_SUMMARY.itcAvailable) },
  ]);
  y = kpiRow(doc, y, [
    { label: 'Gross GST Liability', value: cr(GST_SUMMARY.netGSTLiability) },
    { label: 'Less: ITC', value: cr(GST_SUMMARY.itcAvailable) },
    { label: 'Net GST Payable', value: cr(GST_SUMMARY.netPayable) },
    { label: 'HSN Code', value: '2701 (Coal)' },
  ]);

  y = sectionTitle(doc, y, 'GST Invoice Register (GSTR-1 Format)');
  autoTable(doc, {
    startY: y,
    head: [['Invoice No.', 'Date', 'Customer', 'GSTIN', 'HSN', 'Taxable Value', 'IGST @5%', 'TCS @1%', 'Invoice Total']],
    body: GST_INVOICE_REGISTER.map(r => [r.invoiceNo, r.date, r.customer, r.gstin, r.hsnCode, cr(r.taxableValue), cr(r.igstAmt), cr(r.tcs), cr(r.totalInvoice)]),
    styles: { fontSize: 6.5, cellPadding: 2 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  // Totals row
  const totTaxable = GST_INVOICE_REGISTER.reduce((s, r) => s + r.taxableValue, 0);
  const totIGST = GST_INVOICE_REGISTER.reduce((s, r) => s + r.igstAmt, 0);
  const totTCS = GST_INVOICE_REGISTER.reduce((s, r) => s + r.tcs, 0);
  const totInvoice = GST_INVOICE_REGISTER.reduce((s, r) => s + r.totalInvoice, 0);
  autoTable(doc, {
    startY: y,
    body: [['TOTAL', '', '', '', '', cr(totTaxable), cr(totIGST), cr(totTCS), cr(totInvoice)]],
    styles: { fontSize: 7.5, cellPadding: 2.5, fontStyle: 'bold', fillColor: [254, 243, 199] },
    margin: { left: 12, right: 12 },
    theme: 'plain',
  });

  pdfFooter(doc);
  doc.save(`SHCC_GST_Taxation_Report_${GST_SUMMARY.period.replace(/\s/g, '_')}.pdf`);
}

function gstXLSX() {
  downloadXLSX('SHCC_GST_Taxation_Report.xlsx', [
    {
      name: 'GST Summary', data: [
        ['SHCC – GST & Taxation Report'],
        ['Period:', GST_SUMMARY.period, 'GSTIN:', COMPANY.gstin],
        [],
        ['Metric', 'Value (₹)'],
        ['Total Taxable Value', GST_SUMMARY.totalTaxableValue],
        ['Total IGST (5%)', GST_SUMMARY.totalIGST],
        ['TCS Collected (1%)', GST_SUMMARY.totalTCS],
        ['ITC Available', GST_SUMMARY.itcAvailable],
        ['Net GST Payable', GST_SUMMARY.netPayable],
      ]
    },
    {
      name: 'Invoice Register', data: [
        ['Invoice No.', 'Date', 'Customer', 'GSTIN', 'HSN Code', 'Taxable Value (₹)', 'IGST @5% (₹)', 'TCS @1% (₹)', 'Invoice Total (₹)'],
        ...GST_INVOICE_REGISTER.map(r => [r.invoiceNo, r.date, r.customer, r.gstin, r.hsnCode, r.taxableValue, r.igstAmt, r.tcs, r.totalInvoice]),
      ]
    },
  ]);
}

function gstCSV() {
  downloadCSV('SHCC_GST_Taxation_Report.csv',
    ['Invoice No.', 'Date', 'Customer', 'GSTIN', 'HSN Code', 'Taxable Value', 'IGST Amt', 'TCS Amt', 'Invoice Total'],
    [GST_INVOICE_REGISTER.map(r => [r.invoiceNo, r.date, r.customer, r.gstin, r.hsnCode, r.taxableValue, r.igstAmt, r.tcs, r.totalInvoice])]
  );
}

// ── ORDERS LIFECYCLE ──────────────────────────────────────────────────────────

function ordersPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Orders Lifecycle Metrics Report', `Period: ${ORDERS_LIFECYCLE_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Order Pipeline Summary');
  y = kpiRow(doc, y, [
    { label: 'Total Orders', value: String(ORDERS_LIFECYCLE_SUMMARY.totalOrders) },
    { label: 'Delivered', value: String(ORDERS_LIFECYCLE_SUMMARY.delivered) },
    { label: 'In Transit / Shipped', value: String(ORDERS_LIFECYCLE_SUMMARY.shipped) },
    { label: 'Processing', value: String(ORDERS_LIFECYCLE_SUMMARY.processing) },
  ]);
  y = kpiRow(doc, y, [
    { label: 'Pending Approval', value: String(ORDERS_LIFECYCLE_SUMMARY.pending) },
    { label: 'Cancelled', value: String(ORDERS_LIFECYCLE_SUMMARY.cancelled) },
    { label: 'Fulfillment Rate', value: `${ORDERS_LIFECYCLE_SUMMARY.fulfillmentRate}%` },
    { label: 'Avg Delivery Days', value: String(ORDERS_LIFECYCLE_SUMMARY.avgDeliveryDays) },
  ]);

  y = sectionTitle(doc, y, 'Order Lifecycle Tracking');
  autoTable(doc, {
    startY: y,
    head: [['Order ID', 'Customer', 'Qty MT', 'Placed', 'Approved', 'Shipped', 'Delivered', 'Proc. Days', 'Del. Days', 'Status']],
    body: ORDERS_LIFECYCLE_RECORDS.map(r => [r.orderId, r.customer, r.quantityMT.toLocaleString(), r.placedOn, r.approvedOn, r.shippedOn, r.deliveredOn, r.processingDays ?? '—', r.deliveryDays ?? '—', r.status]),
    styles: { fontSize: 6.5, cellPadding: 2 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Orders_Lifecycle_Report.pdf`);
}

function ordersXLSX() {
  downloadXLSX('SHCC_Orders_Lifecycle_Report.xlsx', [
    {
      name: 'Lifecycle Summary', data: [
        ['SHCC – Orders Lifecycle Report'],
        ['Period:', ORDERS_LIFECYCLE_SUMMARY.period, 'Generated:', now()],
        [],
        ['Metric', 'Value'],
        ['Total Orders', ORDERS_LIFECYCLE_SUMMARY.totalOrders],
        ['Delivered', ORDERS_LIFECYCLE_SUMMARY.delivered],
        ['Shipped', ORDERS_LIFECYCLE_SUMMARY.shipped],
        ['Processing', ORDERS_LIFECYCLE_SUMMARY.processing],
        ['Pending', ORDERS_LIFECYCLE_SUMMARY.pending],
        ['Cancelled', ORDERS_LIFECYCLE_SUMMARY.cancelled],
        ['Fulfillment Rate %', ORDERS_LIFECYCLE_SUMMARY.fulfillmentRate],
        ['Avg Processing Days', ORDERS_LIFECYCLE_SUMMARY.avgProcessingDays],
        ['Avg Delivery Days', ORDERS_LIFECYCLE_SUMMARY.avgDeliveryDays],
      ]
    },
    {
      name: 'Order Detail', data: [
        ['Order ID', 'Customer', 'Qty (MT)', 'Placed On', 'Approved On', 'Shipped On', 'Delivered On', 'Processing Days', 'Delivery Days', 'Status'],
        ...ORDERS_LIFECYCLE_RECORDS.map(r => [r.orderId, r.customer, r.quantityMT, r.placedOn, r.approvedOn, r.shippedOn, r.deliveredOn, r.processingDays, r.deliveryDays, r.status]),
      ]
    },
  ]);
}

function ordersCSV() {
  downloadCSV('SHCC_Orders_Lifecycle_Report.csv',
    ['Order ID', 'Customer', 'Qty MT', 'Placed On', 'Approved On', 'Shipped On', 'Delivered On', 'Processing Days', 'Delivery Days', 'Status'],
    [ORDERS_LIFECYCLE_RECORDS.map(r => [r.orderId, r.customer, r.quantityMT, r.placedOn, r.approvedOn, r.shippedOn, r.deliveredOn, r.processingDays, r.deliveryDays, r.status])]
  );
}

// ── CUSTOMERS TRANSACTION LEDGER ─────────────────────────────────────────────

function customersPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Customers Transaction Ledger', `Period: ${CUSTOMER_LEDGER_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Customer Portfolio Summary');
  y = kpiRow(doc, y, [
    { label: 'Total Customers', value: String(CUSTOMER_LEDGER_SUMMARY.totalCustomers) },
    { label: 'Active', value: String(CUSTOMER_LEDGER_SUMMARY.activeCustomers) },
    { label: 'Total Billed', value: cr(CUSTOMER_LEDGER_SUMMARY.totalBilled) },
    { label: 'Total Collected', value: cr(CUSTOMER_LEDGER_SUMMARY.totalCollected) },
  ]);
  y = kpiRow(doc, y, [
    { label: 'Total Outstanding', value: cr(CUSTOMER_LEDGER_SUMMARY.totalOutstanding) },
    { label: 'Overdue Accounts', value: String(CUSTOMER_LEDGER_SUMMARY.overdueAccounts) },
    { label: 'Avg Credit Days', value: String(CUSTOMER_LEDGER_SUMMARY.avgCreditDays) },
    { label: 'Collection Rate', value: `${((CUSTOMER_LEDGER_SUMMARY.totalCollected / CUSTOMER_LEDGER_SUMMARY.totalBilled) * 100).toFixed(1)}%` },
  ]);

  y = sectionTitle(doc, y, 'Customer Account Summary');
  autoTable(doc, {
    startY: y,
    head: [['Cust ID', 'Name', 'GSTIN', 'Orders', 'Total Billed', 'Paid', 'Outstanding', 'Avg Pay Days', 'Credit Limit', 'Status']],
    body: CUSTOMER_ACCOUNTS.map(r => [r.customerId, r.name, r.gstin, r.totalOrders, cr(r.totalBilled), cr(r.paid), cr(r.outstanding), r.avgPaymentDays, cr(r.creditLimit), r.status]),
    styles: { fontSize: 6, cellPadding: 2 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  y = sectionTitle(doc, y, 'Recent Payment Transactions');
  autoTable(doc, {
    startY: y,
    head: [['Date', 'Customer', 'Invoice No.', 'Invoice Amt', 'Payment Amt', 'Mode', 'Reference', 'Balance After']],
    body: CUSTOMER_TRANSACTIONS.map(r => [r.date, r.customer, r.invoiceNo, cr(r.invoiceAmt), cr(r.paymentAmt), r.paymentMode, r.referenceNo, cr(r.balanceAfter)]),
    styles: { fontSize: 6.5, cellPadding: 2 },
    headStyles: { fillColor: [30, 58, 138], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [239, 246, 255] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Customer_Ledger_Report.pdf`);
}

function customersXLSX() {
  downloadXLSX('SHCC_Customer_Ledger_Report.xlsx', [
    {
      name: 'Customer Accounts', data: [
        ['Customer ID', 'Name', 'GSTIN', 'Total Orders', 'Total Billed (₹)', 'Paid (₹)', 'Outstanding (₹)', 'Avg Payment Days', 'Credit Limit (₹)', 'Status'],
        ...CUSTOMER_ACCOUNTS.map(r => [r.customerId, r.name, r.gstin, r.totalOrders, r.totalBilled, r.paid, r.outstanding, r.avgPaymentDays, r.creditLimit, r.status]),
      ]
    },
    {
      name: 'Transactions', data: [
        ['Date', 'Customer', 'Invoice No.', 'Invoice Amt (₹)', 'Payment Amt (₹)', 'Payment Mode', 'Reference No.', 'Balance After (₹)'],
        ...CUSTOMER_TRANSACTIONS.map(r => [r.date, r.customer, r.invoiceNo, r.invoiceAmt, r.paymentAmt, r.paymentMode, r.referenceNo, r.balanceAfter]),
      ]
    },
  ]);
}

function customersCSV() {
  downloadCSV('SHCC_Customer_Ledger_Report.csv',
    ['Customer ID', 'Name', 'GSTIN', 'Orders', 'Total Billed', 'Paid', 'Outstanding', 'Avg Pay Days', 'Credit Limit', 'Status'],
    [CUSTOMER_ACCOUNTS.map(r => [r.customerId, r.name, r.gstin, r.totalOrders, r.totalBilled, r.paid, r.outstanding, r.avgPaymentDays, r.creditLimit, r.status])]
  );
}

// ── DISPATCH & OPERATIONS (Port Admin) ───────────────────────────────────────

function dispatchPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Dispatch & Operations Report', `Period: ${DISPATCH_SUMMARY.period}  |  Port: Mundra Port`);
  let y = 52;

  y = sectionTitle(doc, y, 'Operations Summary');
  y = kpiRow(doc, y, [
    { label: 'Total Dispatches', value: String(DISPATCH_SUMMARY.totalDispatches) },
    { label: 'Total Dispatched (MT)', value: DISPATCH_SUMMARY.totalDispatchedMT.toLocaleString() },
    { label: 'Fully Delivered Orders', value: String(DISPATCH_SUMMARY.ordersFullyDelivered) },
    { label: 'Partial Deliveries', value: String(DISPATCH_SUMMARY.ordersPartiallyDelivered) },
  ]);
  y = kpiRow(doc, y, [
    { label: 'Avg Turnaround (hrs)', value: String(DISPATCH_SUMMARY.avgTurnaroundHrs) },
    { label: 'Vehicles Deployed', value: String(DISPATCH_SUMMARY.vehiclesDeployed) },
    { label: 'Period', value: DISPATCH_SUMMARY.period },
    { label: 'Report Date', value: now() },
  ]);

  y = sectionTitle(doc, y, 'Dispatch Log – Vehicle & Delivery Records');
  autoTable(doc, {
    startY: y,
    head: [['Dispatch ID', 'Date', 'Order ID', 'Customer', 'Port', 'Coal Type', 'Qty MT', 'Vehicle No.', 'Driver', 'Departure', 'Arrival', 'Status']],
    body: DISPATCH_LOG.map(r => [r.dispatchId, r.date, r.orderId, r.customer, r.port, r.coalType, r.quantityMT.toLocaleString(), r.vehicleNo, r.driverName, r.departureTime, r.arrivalTime, r.status]),
    styles: { fontSize: 5.8, cellPadding: 1.8 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Dispatch_Operations_Report.pdf`);
}

function dispatchXLSX() {
  downloadXLSX('SHCC_Dispatch_Operations_Report.xlsx', [
    {
      name: 'Summary', data: [
        ['SHCC – Dispatch & Operations Report'],
        ['Period:', DISPATCH_SUMMARY.period, 'Generated:', now()],
        [],
        ['Metric', 'Value'],
        ['Total Dispatches', DISPATCH_SUMMARY.totalDispatches],
        ['Total Dispatched MT', DISPATCH_SUMMARY.totalDispatchedMT],
        ['Fully Delivered Orders', DISPATCH_SUMMARY.ordersFullyDelivered],
        ['Partial Deliveries', DISPATCH_SUMMARY.ordersPartiallyDelivered],
        ['Avg Turnaround (hrs)', DISPATCH_SUMMARY.avgTurnaroundHrs],
        ['Vehicles Deployed', DISPATCH_SUMMARY.vehiclesDeployed],
      ]
    },
    {
      name: 'Dispatch Log', data: [
        ['Dispatch ID', 'Date', 'Order ID', 'Customer', 'Port', 'Coal Type', 'Qty (MT)', 'Vehicle No.', 'Driver Name', 'Departure', 'Arrival', 'Status'],
        ...DISPATCH_LOG.map(r => [r.dispatchId, r.date, r.orderId, r.customer, r.port, r.coalType, r.quantityMT, r.vehicleNo, r.driverName, r.departureTime, r.arrivalTime, r.status]),
      ]
    },
  ]);
}

function dispatchCSV() {
  downloadCSV('SHCC_Dispatch_Operations_Report.csv',
    ['Dispatch ID', 'Date', 'Order ID', 'Customer', 'Port', 'Coal Type', 'Qty MT', 'Vehicle No.', 'Driver', 'Departure', 'Arrival', 'Status'],
    [DISPATCH_LOG.map(r => [r.dispatchId, r.date, r.orderId, r.customer, r.port, r.coalType, r.quantityMT, r.vehicleNo, r.driverName, r.departureTime, r.arrivalTime, r.status])]
  );
}

// ── SALESPERSON SALES DATA ────────────────────────────────────────────────────

function salespersonSalesPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Sales Performance Report', `Salesperson: ${SALESPERSON_SALES_SUMMARY.salesperson}  |  Period: ${SALESPERSON_SALES_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Performance Summary');
  y = kpiRow(doc, y, [
    { label: 'Total Revenue', value: cr(SALESPERSON_SALES_SUMMARY.totalRevenue) },
    { label: 'Target Revenue', value: cr(SALESPERSON_SALES_SUMMARY.targetRevenue) },
    { label: 'Target Achievement', value: `${SALESPERSON_SALES_SUMMARY.achievementPct}%` },
    { label: 'Total Orders', value: String(SALESPERSON_SALES_SUMMARY.totalOrders) },
  ]);
  y = kpiRow(doc, y, [
    { label: 'Avg Order Value', value: lakh(SALESPERSON_SALES_SUMMARY.avgOrderValue) },
    { label: 'New Customers', value: String(SALESPERSON_SALES_SUMMARY.newCustomers) },
    { label: 'Repeat Customers', value: String(SALESPERSON_SALES_SUMMARY.repeatCustomers) },
    { label: 'Period', value: SALESPERSON_SALES_SUMMARY.period },
  ]);

  y = sectionTitle(doc, y, 'My Orders');
  autoTable(doc, {
    startY: y,
    head: [['Order ID', 'Date', 'Customer', 'Coal Type', 'Port', 'Qty MT', 'Total Amount', 'Status']],
    body: SALESPERSON_ORDER_LIST.map(r => [r.orderId, r.date, r.customer, r.coalType, r.port, r.quantityMT.toLocaleString(), cr(r.totalAmount), r.status]),
    styles: { fontSize: 7.5, cellPadding: 2.5 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });
  y = (doc as any).lastAutoTable.finalY + 8;

  y = sectionTitle(doc, y, 'Client Accounts');
  autoTable(doc, {
    startY: y,
    head: [['Customer ID', 'Name', 'Orders (Period)', 'Revenue', 'Outstanding', 'Last Order', 'Since', 'Status']],
    body: SALESPERSON_CLIENT_ACCOUNTS.map(r => [r.customerId, r.name, r.totalOrdersThisPeriod, cr(r.totalRevenue), cr(r.outstandingBalance), r.lastOrderDate, r.relationshipSince, r.status]),
    styles: { fontSize: 7.5, cellPadding: 2.5 },
    headStyles: { fillColor: [30, 58, 138], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [239, 246, 255] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Sales_Performance_${SALESPERSON_SALES_SUMMARY.salesperson.replace(/\s/g, '_')}.pdf`);
}

function salespersonSalesXLSX() {
  downloadXLSX('SHCC_Sales_Performance_Report.xlsx', [
    {
      name: 'My Orders', data: [
        ['Order ID', 'Date', 'Customer', 'Coal Type', 'Port', 'Qty (MT)', 'Total Amount (₹)', 'Status'],
        ...SALESPERSON_ORDER_LIST.map(r => [r.orderId, r.date, r.customer, r.coalType, r.port, r.quantityMT, r.totalAmount, r.status]),
      ]
    },
    {
      name: 'Client Accounts', data: [
        ['Customer ID', 'Name', 'Orders (Period)', 'Revenue (₹)', 'Outstanding (₹)', 'Last Order Date', 'Relationship Since', 'Status'],
        ...SALESPERSON_CLIENT_ACCOUNTS.map(r => [r.customerId, r.name, r.totalOrdersThisPeriod, r.totalRevenue, r.outstandingBalance, r.lastOrderDate, r.relationshipSince, r.status]),
      ]
    },
  ]);
}

function salespersonSalesCSV() {
  downloadCSV('SHCC_My_Sales_Orders.csv',
    ['Order ID', 'Date', 'Customer', 'Coal Type', 'Port', 'Qty MT', 'Total Amount', 'Status'],
    [SALESPERSON_ORDER_LIST.map(r => [r.orderId, r.date, r.customer, r.coalType, r.port, r.quantityMT, r.totalAmount, r.status])]
  );
}

function salespersonClientsPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Client Data & Accounts Report', `Salesperson: ${SALESPERSON_SALES_SUMMARY.salesperson}  |  Period: ${SALESPERSON_SALES_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Client Portfolio');
  autoTable(doc, {
    startY: y,
    head: [['Customer ID', 'Name', 'Orders (Period)', 'Revenue (Period)', 'Outstanding Balance', 'Last Order', 'Relationship Since', 'Status']],
    body: SALESPERSON_CLIENT_ACCOUNTS.map(r => [r.customerId, r.name, r.totalOrdersThisPeriod, cr(r.totalRevenue), cr(r.outstandingBalance), r.lastOrderDate, r.relationshipSince, r.status]),
    styles: { fontSize: 7.5, cellPadding: 3 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Client_Accounts_${SALESPERSON_SALES_SUMMARY.salesperson.replace(/\s/g, '_')}.pdf`);
}

function salespersonClientsXLSX() {
  downloadXLSX('SHCC_Client_Accounts_Report.xlsx', [
    {
      name: 'Clients', data: [
        ['Customer ID', 'Name', 'Orders This Period', 'Revenue (₹)', 'Outstanding (₹)', 'Last Order Date', 'Relationship Since', 'Status'],
        ...SALESPERSON_CLIENT_ACCOUNTS.map(r => [r.customerId, r.name, r.totalOrdersThisPeriod, r.totalRevenue, r.outstandingBalance, r.lastOrderDate, r.relationshipSince, r.status]),
      ]
    },
  ]);
}

function salespersonClientsCSV() {
  downloadCSV('SHCC_Client_Accounts_Report.csv',
    ['Customer ID', 'Name', 'Orders This Period', 'Revenue', 'Outstanding', 'Last Order', 'Since', 'Status'],
    [SALESPERSON_CLIENT_ACCOUNTS.map(r => [r.customerId, r.name, r.totalOrdersThisPeriod, r.totalRevenue, r.outstandingBalance, r.lastOrderDate, r.relationshipSince, r.status])]
  );
}

// ── REVENUE STREAMS (Finance) ─────────────────────────────────────────────────

function revenueStreamPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Revenue Stream Metrics Report', `Period: ${REVENUE_STREAM_SUMMARY.period}`);
  let y = 52;

  y = sectionTitle(doc, y, 'Revenue Overview');
  y = kpiRow(doc, y, [
    { label: 'Total Revenue', value: cr(REVENUE_STREAM_SUMMARY.totalRevenue) },
    { label: 'Coal Sales', value: cr(REVENUE_STREAM_SUMMARY.coalSalesRevenue) },
    { label: 'Freight Recovery', value: cr(REVENUE_STREAM_SUMMARY.freightRecovery) },
    { label: 'Net Revenue (ex-Tax)', value: cr(REVENUE_STREAM_SUMMARY.netRevenueExcludingTax) },
  ]);

  y = sectionTitle(doc, y, 'Revenue by Channel');
  autoTable(doc, {
    startY: y,
    head: [['Channel', 'Revenue', 'Orders', 'Avg Order Value', 'Revenue Share %']],
    body: REVENUE_BY_CHANNEL.map(r => [r.channel, cr(r.revenue), r.orders, cr(r.avgOrderValue), `${r.revenueShare}%`]),
    styles: { fontSize: 8, cellPadding: 3 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Revenue_Stream_Report.pdf`);
}

function revenueStreamXLSX() {
  downloadXLSX('SHCC_Revenue_Stream_Report.xlsx', [
    {
      name: 'Revenue Streams', data: [
        ['SHCC – Revenue Stream Report'],
        ['Period:', REVENUE_STREAM_SUMMARY.period],
        [],
        ['Metric', 'Value (₹)'],
        ['Total Revenue', REVENUE_STREAM_SUMMARY.totalRevenue],
        ['Coal Sales Revenue', REVENUE_STREAM_SUMMARY.coalSalesRevenue],
        ['Freight Recovery', REVENUE_STREAM_SUMMARY.freightRecovery],
        ['GST Collected', REVENUE_STREAM_SUMMARY.gstCollected],
        ['TCS Collected', REVENUE_STREAM_SUMMARY.tcsCollected],
        ['Net Revenue (ex-Tax)', REVENUE_STREAM_SUMMARY.netRevenueExcludingTax],
        [],
        ['CHANNEL BREAKDOWN'],
        ['Channel', 'Revenue (₹)', 'Orders', 'Avg Order Value (₹)', 'Revenue Share %'],
        ...REVENUE_BY_CHANNEL.map(r => [r.channel, r.revenue, r.orders, r.avgOrderValue, r.revenueShare]),
      ]
    },
  ]);
}

function revenueStreamCSV() {
  downloadCSV('SHCC_Revenue_Stream_Report.csv',
    ['Channel', 'Revenue', 'Orders', 'Avg Order Value', 'Revenue Share %'],
    [REVENUE_BY_CHANNEL.map(r => [r.channel, r.revenue, r.orders, r.avgOrderValue, r.revenueShare])]
  );
}

// ── INVOICE AGING (Finance) ───────────────────────────────────────────────────

function invoiceAgingPDF() {
  const doc = new jsPDF();
  pdfHeader(doc, 'Invoice Aging Register', `As of: ${now()}`);
  let y = 52;

  const totalOutstanding = INVOICE_AGING.reduce((s, r) => s + r.outstanding, 0);
  y = sectionTitle(doc, y, 'Aging Summary');
  y = kpiRow(doc, y, [
    { label: 'Total Outstanding', value: cr(totalOutstanding) },
    { label: 'Invoices Tracked', value: String(INVOICE_AGING.length) },
    { label: 'Overdue Count', value: String(INVOICE_AGING.filter(r => r.daysOverdue > 0).length) },
    { label: 'Report Date', value: now() },
  ]);

  y = sectionTitle(doc, y, 'Invoice Aging Detail');
  autoTable(doc, {
    startY: y,
    head: [['Invoice No.', 'Customer', 'Invoice Date', 'Due Date', 'Invoice Amt', 'Paid Amt', 'Outstanding', 'Days Overdue', 'Aging Bucket']],
    body: INVOICE_AGING.map(r => [r.invoiceNo, r.customer, r.invoiceDate, r.dueDate, cr(r.invoiceAmt), cr(r.paidAmt), cr(r.outstanding), r.daysOverdue, r.agingBucket]),
    styles: { fontSize: 7, cellPadding: 2.5 },
    headStyles: { fillColor: [249, 115, 22], textColor: 255, fontStyle: 'bold' },
    alternateRowStyles: { fillColor: [255, 251, 245] },
    margin: { left: 12, right: 12 },
  });

  pdfFooter(doc);
  doc.save(`SHCC_Invoice_Aging_Register.pdf`);
}

function invoiceAgingXLSX() {
  downloadXLSX('SHCC_Invoice_Aging_Register.xlsx', [
    {
      name: 'Aging Register', data: [
        ['Invoice No.', 'Customer', 'Invoice Date', 'Due Date', 'Invoice Amt (₹)', 'Paid Amt (₹)', 'Outstanding (₹)', 'Days Overdue', 'Aging Bucket'],
        ...INVOICE_AGING.map(r => [r.invoiceNo, r.customer, r.invoiceDate, r.dueDate, r.invoiceAmt, r.paidAmt, r.outstanding, r.daysOverdue, r.agingBucket]),
      ]
    },
  ]);
}

function invoiceAgingCSV() {
  downloadCSV('SHCC_Invoice_Aging_Register.csv',
    ['Invoice No.', 'Customer', 'Invoice Date', 'Due Date', 'Invoice Amt', 'Paid Amt', 'Outstanding', 'Days Overdue', 'Aging Bucket'],
    [INVOICE_AGING.map(r => [r.invoiceNo, r.customer, r.invoiceDate, r.dueDate, r.invoiceAmt, r.paidAmt, r.outstanding, r.daysOverdue, r.agingBucket])]
  );
}

// ── CREDIT LEDGER (Finance) ───────────────────────────────────────────────────
function creditLedgerPDF() { return customersPDF(); }
function creditLedgerXLSX() { return customersXLSX(); }
function creditLedgerCSV() { return customersCSV(); }

// ═════════════════════════════════════════════════════════════════════════════
//  PUBLIC ENTRY POINT  –  Called by UI report pages
// ═════════════════════════════════════════════════════════════════════════════

export type ReportKey =
  | 'sales' | 'inventory' | 'financial' | 'gst' | 'orders' | 'customers'
  | 'dispatch' | 'salesperson-sales' | 'salesperson-clients'
  | 'revenue' | 'invoice' | 'credit';

export type ExportFormat = 'pdf' | 'excel' | 'csv';

const MATRIX: Record<ReportKey, Record<ExportFormat, () => void>> = {
  sales:               { pdf: salesPDF,              excel: salesXLSX,            csv: salesCSV },
  inventory:           { pdf: inventoryPDF,           excel: inventoryXLSX,         csv: inventoryCSV },
  financial:           { pdf: financialPDF,           excel: financialXLSX,         csv: financialCSV },
  gst:                 { pdf: gstPDF,                 excel: gstXLSX,               csv: gstCSV },
  orders:              { pdf: ordersPDF,              excel: ordersXLSX,            csv: ordersCSV },
  customers:           { pdf: customersPDF,           excel: customersXLSX,         csv: customersCSV },
  dispatch:            { pdf: dispatchPDF,            excel: dispatchXLSX,          csv: dispatchCSV },
  'salesperson-sales': { pdf: salespersonSalesPDF,    excel: salespersonSalesXLSX,  csv: salespersonSalesCSV },
  'salesperson-clients':{ pdf: salespersonClientsPDF, excel: salespersonClientsXLSX, csv: salespersonClientsCSV },
  revenue:             { pdf: revenueStreamPDF,       excel: revenueStreamXLSX,     csv: revenueStreamCSV },
  invoice:             { pdf: invoiceAgingPDF,        excel: invoiceAgingXLSX,      csv: invoiceAgingCSV },
  credit:              { pdf: creditLedgerPDF,        excel: creditLedgerXLSX,      csv: creditLedgerCSV },
};

export function exportReport(reportKey: ReportKey, format: ExportFormat): void {
  const fn = MATRIX[reportKey]?.[format];
  if (fn) fn();
  else console.warn(`No exporter for report="${reportKey}" format="${format}"`);
}
