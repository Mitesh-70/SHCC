import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'

const O = '#F5821F'
const C = '#2C2C2C'
const BG = '#FAF3EB'

const industries = [
  {
    sector: 'Textile Industry', emoji: '🧵',
    clients: [
      { name: 'Garden Silk Mills Pvt Ltd', area: 'Surat' },
      { name: 'Hubergroup Ind Pvt Ltd', area: 'Vapi' },
      { name: 'Alok Industries Ltd', area: 'Vapi' },
      { name: 'Birla Century', area: 'Jaghadiya' },
      { name: 'Sumilon Industries Ltd', area: 'Surat' },
      { name: 'Vardhman Fabrics', area: 'Bhopal' },
    ],
  },
  {
    sector: 'Paper Industry', emoji: '📄',
    clients: [
      { name: 'Gayatrishakti Paper & Boards Ltd', area: 'Vapi' },
      { name: 'Best Paper Mills Pvt Ltd', area: 'Vapi' },
      { name: 'Shree Ajit Pulp & Paper Ltd', area: 'Vapi' },
    ],
  },
  {
    sector: 'Chemical Industry', emoji: '⚗️',
    clients: [
      { name: 'Dipak Nitrate Ltd', area: 'Dahej' },
      { name: 'SRF Ltd', area: 'Dahej' },
      { name: 'Demosha Chemicals Pvt Ltd', area: 'Vapi' },
    ],
  },
  {
    sector: 'Glass Industry', emoji: '🪟',
    clients: [
      { name: 'Saint Gobain Ind Pvt Ltd', area: 'Jaghadiya' },
      { name: 'Saint Gobain Ind Pvt Ltd', area: 'Wada' },
    ],
  },
  {
    sector: 'Pharma Industry', emoji: '💊',
    clients: [
      { name: 'Vital Laboratories Pvt Ltd', area: 'Vapi' },
      { name: 'Ciron Drugs & Pharmaceuticals', area: 'Tarapur' },
      { name: 'Cadila Healthcare Ltd', area: 'Padra' },
      { name: 'Farmsons Pharmaceutical Pvt Ltd', area: 'Jaghadiya' },
    ],
  },
  {
    sector: 'Cement Industry', emoji: '🏗️',
    clients: [
      { name: 'Trinetra Cement Ltd', area: 'Banswara' },
      { name: 'Kalyani India Pvt Ltd', area: 'Rajasthan' },
    ],
  },
  {
    sector: 'Tyre Industry', emoji: '🛞',
    clients: [{ name: 'CEAT Ltd', area: 'Halol' }],
  },
  {
    sector: 'Waste Mgmt Industry', emoji: '♻️',
    clients: [{ name: 'Detox India Pvt Ltd', area: 'Ankleshwar' }],
  },
]

export function ClientsSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-80px' })

  return (
    <section id="clients" className="py-24 bg-white" ref={ref}>
      <div className="max-w-7xl mx-auto px-6">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="font-semibold tracking-widest text-sm uppercase mb-3" style={{ color: O }}>Major Clients</p>
          <h2 className="font-bold text-4xl md:text-5xl mb-4" style={{ fontFamily: 'Syne, sans-serif', color: C }}>
            Industries We <span style={{ color: O }}>Power</span>
          </h2>
          <div className="w-16 h-1 rounded-full mx-auto mb-6" style={{ background: `linear-gradient(to right, ${O}, #FFA757)` }} />
          <p className="max-w-xl mx-auto text-base" style={{ color: 'rgba(44,44,44,0.6)' }}>
            From textiles to pharmaceuticals, our coal fuels some of India's most recognized enterprises.
          </p>
        </motion.div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
          {industries.map((industry, i) => (
            <motion.div
              key={industry.sector}
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.5, delay: i * 0.07 }}
              className="rounded-2xl overflow-hidden border transition-all duration-300 hover:-translate-y-1 hover:shadow-lg"
              style={{ backgroundColor: BG, borderColor: 'rgba(245,130,31,0.15)' }}
            >
              {/* Sector header */}
              <div
                className="px-5 py-4 flex items-center gap-3"
                style={{ background: `linear-gradient(to right, ${O}, #E8941A)` }}
              >
                <span className="text-xl">{industry.emoji}</span>
                <h3 className="font-bold text-white text-sm" style={{ fontFamily: 'Syne, sans-serif' }}>{industry.sector}</h3>
              </div>

              {/* Clients */}
              <div className="p-4 space-y-3">
                {industry.clients.map((client) => (
                  <div key={client.name + client.area} className="flex items-start justify-between gap-2">
                    <p className="font-medium text-xs leading-snug flex-1" style={{ color: C }}>{client.name}</p>
                    <span
                      className="flex-shrink-0 text-xs font-semibold px-2 py-0.5 rounded-full"
                      style={{ backgroundColor: 'rgba(245,130,31,0.12)', color: O }}
                    >
                      {client.area}
                    </span>
                  </div>
                ))}
              </div>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
