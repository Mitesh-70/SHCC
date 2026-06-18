import { useRef, useState } from 'react'
import { motion, useInView } from 'framer-motion'

const O = '#F5821F'
const C = '#2C2C2C'
const BG = '#FAF3EB'

export function ContactSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-80px' })
  const [form, setForm] = useState({ name: '', company: '', email: '', message: '' })
  const [submitted, setSubmitted] = useState(false)

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setForm({ ...form, [e.target.name]: e.target.value })
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setSubmitted(true)
  }

  const inputStyle = {
    width: '100%',
    border: '1px solid rgba(245,130,31,0.25)',
    backgroundColor: BG,
    borderRadius: '12px',
    padding: '12px 16px',
    fontSize: '14px',
    color: C,
    outline: 'none',
    fontFamily: 'Inter, sans-serif',
  }

  return (
    <section id="contact" className="py-24" style={{ backgroundColor: BG }} ref={ref}>
      <div className="max-w-7xl mx-auto px-6">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="font-semibold tracking-widest text-sm uppercase mb-3" style={{ color: O }}>Get In Touch</p>
          <h2 className="font-bold text-4xl md:text-5xl mb-4" style={{ fontFamily: 'Syne, sans-serif', color: C }}>
            Request a <span style={{ color: O }}>Quote</span>
          </h2>
          <div className="w-16 h-1 rounded-full mx-auto mb-6" style={{ background: `linear-gradient(to right, ${O}, #FFA757)` }} />
          <p className="max-w-xl mx-auto" style={{ color: 'rgba(44,44,44,0.6)', fontSize: '16px' }}>
            Reach out to us for pricing, availability, or any enquiry. We typically respond within 24 hours.
          </p>
        </motion.div>

        <div className="grid lg:grid-cols-2 gap-12 max-w-5xl mx-auto">
          {/* Info */}
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.2 }}
            className="space-y-8"
          >
            <div>
              <h3 className="font-bold text-2xl mb-4" style={{ fontFamily: 'Syne, sans-serif', color: C }}>
                Shree Hari Coal Corporation
              </h3>
              <p className="text-sm leading-relaxed" style={{ color: 'rgba(44,44,44,0.6)' }}>
                One of the trusted importers and traders of coal from various countries,
                known in the industry for product consistency, price reliability, material
                availability, and delivery accuracy.
              </p>
            </div>

            <div className="space-y-5">
              {[
                { icon: '📍', label: 'Address', value: '314, International Business Center, Next to Big Bazzar, Piplod, Surat, Gujarat – 395007' },
                { icon: '✉️', label: 'Email', value: 'info@shcc.co.in' },
                { icon: '📞', label: 'Phone', value: '+91 8511122797' },
              ].map((contact) => (
                <div key={contact.label} className="flex items-start gap-4">
                  <div
                    className="flex items-center justify-center flex-shrink-0 text-2xl mt-1"
                  >
                    {contact.icon}
                  </div>
                  <div>
                    <p className="text-xs font-semibold uppercase tracking-wider mb-1" style={{ color: O }}>{contact.label}</p>
                    <p className="text-sm leading-relaxed" style={{ color: 'rgba(44,44,44,0.8)' }}>{contact.value}</p>
                  </div>
                </div>
              ))}
            </div>

            {/* Values pill strip */}
            <div className="rounded-2xl p-6 text-white" style={{ background: `linear-gradient(to right, ${O}, #E8941A)` }}>
              <p className="font-bold text-lg mb-3" style={{ fontFamily: 'Syne, sans-serif' }}>Our Values</p>
              <div className="flex flex-wrap gap-2">
                {['Assurity', 'Consistency', 'Reliability', 'Availability'].map(v => (
                  <span
                    key={v}
                    className="text-sm font-semibold px-4 py-1.5 rounded-full"
                    style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}
                  >
                    {v}
                  </span>
                ))}
              </div>
            </div>
          </motion.div>

          {/* Form */}
          <motion.div
            initial={{ opacity: 0, x: 30 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.3 }}
            className="bg-white rounded-3xl p-8 border"
            style={{ borderColor: 'rgba(245,130,31,0.15)', boxShadow: '0 2px 16px rgba(0,0,0,0.04)' }}
          >
            {submitted ? (
              <div className="flex flex-col items-center justify-center h-full gap-4 py-12">
                <div className="text-6xl">✅</div>
                <h3 className="font-bold text-xl" style={{ fontFamily: 'Syne, sans-serif', color: C }}>Message Sent!</h3>
                <p className="text-center text-sm" style={{ color: 'rgba(44,44,44,0.6)' }}>
                  Thank you for reaching out. Our team will get back to you within 24 hours.
                </p>
                <button
                  onClick={() => setSubmitted(false)}
                  className="mt-4 text-sm font-semibold hover:underline"
                  style={{ color: O }}
                >
                  Send another message
                </button>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-5">
                <div className="grid sm:grid-cols-2 gap-4">
                  <div>
                    <label className="block text-xs font-semibold uppercase tracking-wider mb-2" style={{ color: 'rgba(44,44,44,0.55)' }}>Name</label>
                    <input type="text" name="name" required value={form.name} onChange={handleChange} placeholder="Your name" style={inputStyle} />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold uppercase tracking-wider mb-2" style={{ color: 'rgba(44,44,44,0.55)' }}>Company</label>
                    <input type="text" name="company" value={form.company} onChange={handleChange} placeholder="Company name" style={inputStyle} />
                  </div>
                </div>
                <div>
                  <label className="block text-xs font-semibold uppercase tracking-wider mb-2" style={{ color: 'rgba(44,44,44,0.55)' }}>Email</label>
                  <input type="email" name="email" required value={form.email} onChange={handleChange} placeholder="your@email.com" style={inputStyle} />
                </div>
                <div>
                  <label className="block text-xs font-semibold uppercase tracking-wider mb-2" style={{ color: 'rgba(44,44,44,0.55)' }}>Message / Requirements</label>
                  <textarea
                    name="message"
                    required
                    rows={4}
                    value={form.message}
                    onChange={handleChange}
                    placeholder="Tell us about your coal requirements (type, quantity, size)..."
                    style={{ ...inputStyle, resize: 'none' }}
                  />
                </div>
                <button
                  type="submit"
                  className="w-full inline-flex items-center justify-center gap-2 text-white font-semibold py-4 rounded-full transition-all duration-300 text-sm"
                  style={{ backgroundColor: O }}
                >
                  Send Enquiry
                  <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
                  </svg>
                </button>
              </form>
            )}
          </motion.div>
        </div>
      </div>
    </section>
  )
}
