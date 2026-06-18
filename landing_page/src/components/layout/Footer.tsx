const O = '#F5821F'
const C = '#2C2C2C'

const links = [
  { label: 'About', href: '#about' },
  { label: 'Products', href: '#products' },
  { label: 'Clients', href: '#clients' },
  { label: 'Contact', href: '#contact' },
]

export function Footer() {
  return (
    <footer style={{ backgroundColor: C, color: 'white' }} className="py-12">
      <div className="max-w-7xl mx-auto px-6">
        <div className="grid md:grid-cols-3 gap-10 mb-10">
          {/* Brand */}
          <div>
            <div className="flex items-center gap-3 mb-4">
              <img src="/logo.png" alt="SHCC Logo" className="h-16 object-contain" onError={(e) => {
                e.currentTarget.outerHTML = '<div class="w-10 h-10 bg-[#F5821F] rounded-xl flex items-center justify-center shadow-md"><span class="text-white font-bold text-xs tracking-tight">SHCC</span></div>'
              }} />
              <div>
                <p className="font-bold text-sm leading-tight" style={{ fontFamily: 'Syne, sans-serif' }}>
                  Shree Hari Coal Corporation
                </p>
                <p className="text-xs font-semibold tracking-widest" style={{ color: O }}>
                  IMPORTER · WHOLESELLER · TRADER
                </p>
              </div>
            </div>
            <p className="text-sm leading-relaxed" style={{ color: 'rgba(255,255,255,0.45)' }}>
              Trusted source of imported coal from Indonesia, South Africa, USA &amp; Russia —
              powering industries across India.
            </p>
          </div>

          {/* Links */}
          <div>
            <h4
              className="text-xs uppercase tracking-widest font-semibold mb-4"
              style={{ color: 'rgba(255,255,255,0.35)' }}
            >
              Quick Links
            </h4>
            <div className="flex flex-col gap-2">
              {links.map((link) => (
                <a
                  key={link.href}
                  href={link.href}
                  className="text-sm transition-colors duration-200 hover:text-white"
                  style={{ color: 'rgba(255,255,255,0.55)' }}
                >
                  {link.label}
                </a>
              ))}
            </div>
          </div>

          {/* Contact */}
          <div>
            <h4
              className="text-xs uppercase tracking-widest font-semibold mb-4"
              style={{ color: 'rgba(255,255,255,0.35)' }}
            >
              Contact
            </h4>
            <div className="space-y-3 text-sm" style={{ color: 'rgba(255,255,255,0.55)' }}>
              <p>📍 314, International Business Center,<br />Piplod, Surat, Gujarat – 395007</p>
              <p>✉️ info@shcc.co.in</p>
              <p>📞 +91 8511122797</p>
            </div>
          </div>
        </div>

        <div
          className="pt-6 flex flex-col sm:flex-row items-center justify-between gap-3"
          style={{ borderTop: '1px solid rgba(255,255,255,0.1)' }}
        >
          <p className="text-xs" style={{ color: 'rgba(255,255,255,0.3)' }}>
            © {new Date().getFullYear()} Shree Hari Coal Corporation. All rights reserved.
          </p>
          <div className="flex items-center gap-4">
            {['Assurity', 'Consistency', 'Reliability', 'Availability'].map((v) => (
              <span key={v} className="text-xs" style={{ color: 'rgba(255,255,255,0.3)' }}>{v}</span>
            ))}
          </div>
        </div>
      </div>
    </footer>
  )
}
