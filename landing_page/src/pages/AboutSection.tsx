import { motion } from 'framer-motion'
import { useInView } from 'framer-motion'
import { useRef } from 'react'

const O = '#F5821F'   // SHCC orange
const C = '#2C2C2C'  // coal dark
const BG = '#FAF3EB' // cream background

function ValueCard({ icon, title, desc }: { icon: string; title: string; desc: string }) {
  return (
    <div
      className="flex flex-col items-start gap-3 p-6 bg-white rounded-2xl border transition-all duration-300 hover:-translate-y-1 hover:shadow-lg"
      style={{ borderColor: 'rgba(245,130,31,0.15)' }}
    >
      <div className="text-4xl mb-2">{icon}</div>
      <h3 className="font-bold text-lg" style={{ fontFamily: 'Syne, sans-serif', color: C }}>{title}</h3>
      <p className="text-sm leading-relaxed" style={{ color: 'rgba(44,44,44,0.6)' }}>{desc}</p>
    </div>
  )
}

export function AboutSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-100px' })

  const mvv = [
    { label: 'Mission', text: 'Committed to procure and deliver superior quality coal to associated industries.', from: '#F5821F', to: '#FFA757' },
    { label: 'Vision', text: 'Creating a platform that meets all sets of coal requirements across industries.', from: '#FFA757', to: '#E8941A' },
    { label: 'Values', text: 'Assurity, Consistency, Reliability, and Availability — the four pillars of SHCC.', from: '#E8941A', to: '#F5821F' },
  ]

  const values = [
    { icon: '🛡️', title: 'Assurity', desc: 'Every order backed by our commitment to deliver exactly what was promised, every time.' },
    { icon: '🎯', title: 'Consistency', desc: 'Uniform coal quality across every shipment — no surprises, always reliable.' },
    { icon: '⚡', title: 'Reliability', desc: 'On-time deliveries and transparent communication throughout.' },
    { icon: '📦', title: 'Availability', desc: 'Year-round stock to keep your operations running without interruption.' },
  ]

  return (
    <section id="about" className="py-24" style={{ backgroundColor: BG }} ref={ref}>
      <div className="max-w-7xl mx-auto px-6">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="font-semibold tracking-widest text-sm uppercase mb-3" style={{ color: O }}>Who We Are</p>
          <h2 className="font-bold text-4xl md:text-5xl mb-4" style={{ fontFamily: 'Syne, sans-serif', color: C }}>
            One-Stop Destination for<br/>
            <span style={{ color: O }}>Premium Coal</span>
          </h2>
          <div className="w-16 h-1 rounded-full mx-auto mb-6" style={{ background: `linear-gradient(to right, ${O}, #FFA757)` }} />
          <p className="max-w-2xl mx-auto text-base md:text-lg leading-relaxed" style={{ color: 'rgba(44,44,44,0.6)' }}>
            We have been distinguished as a standout amongst the most recognized coal suppliers
            in the business sector. Our gifted group of experts helps in selecting the best
            importers for acquiring the coal, contributing to favored customer decisions.
          </p>
        </motion.div>

        <div className="grid md:grid-cols-3 gap-6 mb-16">
          {mvv.map((item, i) => (
            <motion.div
              key={item.label}
              initial={{ opacity: 0, y: 30 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.6, delay: i * 0.15 }}
              className="relative overflow-hidden rounded-2xl p-6 bg-white border transition-all duration-300 hover:-translate-y-1 hover:shadow-lg"
              style={{ borderColor: 'rgba(245,130,31,0.15)' }}
            >
              <div className="absolute top-0 left-0 w-full h-1" style={{ background: `linear-gradient(to right, ${item.from}, ${item.to})` }} />
              <p className="font-bold text-xs uppercase tracking-widest mb-3" style={{ color: item.from }}>{item.label}</p>
              <p className="text-sm leading-relaxed" style={{ color: 'rgba(44,44,44,0.7)' }}>{item.text}</p>
            </motion.div>
          ))}
        </div>

        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6, delay: 0.4 }}
          className="grid sm:grid-cols-2 lg:grid-cols-4 gap-5"
        >
          {values.map(v => <ValueCard key={v.title} {...v} />)}
        </motion.div>
      </div>
    </section>
  )
}
