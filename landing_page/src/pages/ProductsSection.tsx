import { motion } from 'framer-motion'
import { useInView } from 'framer-motion'
import { useRef } from 'react'

const O = '#F5821F'
const C = '#2C2C2C'
const BG = '#FAF3EB'

const coalTypes = [
  {
    name: 'Indonesian Coal', flag: '🇮🇩',
    description: 'High-calorific sub-bituminous coal, ideal for power plants and industrial boilers.',
    sizes: ['0–8 MM', '8–25 MM', '25–50 MM'],
    from: '#fb923c', to: '#fbbf24',
  },
  {
    name: 'South African Coal', flag: '🇿🇦',
    description: 'Premium bituminous coal with consistent quality, used in cement and steel industries.',
    sizes: ['8–25 MM', '25–50 MM', '8–50 MM'],
    from: '#fbbf24', to: '#fde047',
  },
  {
    name: 'US Coal', flag: '🇺🇸',
    description: 'Thermal and metallurgical grades, known for low sulfur and high energy content.',
    sizes: ['0–8 MM', '8–25 MM'],
    from: '#fde047', to: '#fb923c',
  },
  {
    name: 'Russian Coal', flag: '🇷🇺',
    description: 'High-quality anthracite and coking coal with superior calorific values.',
    sizes: ['0–8 MM', '25–50 MM', '8–50 MM'],
    from: '#F5821F', to: '#E8941A',
  },
]

const ports = ['Magdalla', 'Hazira', 'Kribhco', 'Kandla', 'Navlakhi', 'Mundra', 'Tuna']
const screeningSizes = ['0–8 MM', '8–25 MM', '25–50 MM', '8–50 MM']

export function ProductsSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-80px' })

  return (
    <section id="products" className="py-24 bg-white" ref={ref}>
      <div className="max-w-7xl mx-auto px-6">
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="font-semibold tracking-widest text-sm uppercase mb-3" style={{ color: O }}>Product Range</p>
          <h2 className="font-bold text-4xl md:text-5xl mb-4" style={{ fontFamily: 'Syne, sans-serif', color: C }}>
            Global Coal,<br/><span style={{ color: O }}>Delivered Locally</span>
          </h2>
          <div className="w-16 h-1 rounded-full mx-auto mb-6" style={{ background: `linear-gradient(to right, ${O}, #FFA757)` }} />
          <p className="max-w-xl mx-auto text-base leading-relaxed" style={{ color: 'rgba(44,44,44,0.6)' }}>
            We source premium coal from four countries and screen it to your exact specification at our large-capacity screening plant.
          </p>
        </motion.div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
          {coalTypes.map((coal, i) => (
            <motion.div
              key={coal.name}
              initial={{ opacity: 0, y: 40 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.6, delay: i * 0.1 }}
              className="bg-white border rounded-2xl overflow-hidden transition-all duration-300 hover:-translate-y-2 hover:shadow-xl"
              style={{ borderColor: 'rgba(245,130,31,0.15)' }}
            >
              <div className="h-1.5 w-full" style={{ background: `linear-gradient(to right, ${coal.from}, ${coal.to})` }} />
              <div className="p-6">
                <div className="text-4xl mb-4">{coal.flag}</div>
                <h3 className="font-bold text-lg mb-2" style={{ fontFamily: 'Syne, sans-serif', color: C }}>{coal.name}</h3>
                <p className="text-sm mb-4 leading-relaxed" style={{ color: 'rgba(44,44,44,0.6)' }}>{coal.description}</p>
                <div className="flex flex-wrap gap-2">
                  {coal.sizes.map(size => (
                    <span
                      key={size}
                      className="text-xs font-semibold px-3 py-1 rounded-full"
                      style={{ backgroundColor: 'rgba(245,130,31,0.1)', color: O }}
                    >
                      {size}
                    </span>
                  ))}
                </div>
              </div>
            </motion.div>
          ))}
        </div>

        <div className="grid md:grid-cols-2 gap-8">
          <motion.div
            initial={{ opacity: 0, x: -30 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.4 }}
            className="rounded-2xl p-8 border"
            style={{ backgroundColor: BG, borderColor: 'rgba(245,130,31,0.15)' }}
          >
            <div className="flex items-end gap-3 mb-6" style={{ overflow: 'visible' }}>
              <span className="text-4xl leading-none">🚢</span>
              <h3 className="font-bold text-2xl" style={{ fontFamily: 'Syne, sans-serif', color: C, lineHeight: '1.4', overflow: 'visible' }}>Ports of Working</h3>
            </div>
            <div className="grid grid-cols-2 gap-3">
              {ports.map(port => (
                <div key={port} className="flex items-center gap-3">
                  <span className="text-xl">⚓</span>
                  <span className="font-bold text-lg" style={{ color: C }}>{port}</span>
                </div>
              ))}
            </div>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: 30 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ duration: 0.6, delay: 0.5 }}
            className="rounded-2xl p-8 text-white"
            style={{ background: `linear-gradient(135deg, ${O}, #E8941A)` }}
          >
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ backgroundColor: 'rgba(255,255,255,0.2)' }}>
                <span className="text-xl">🏭</span>
              </div>
              <h3 className="font-bold text-xl" style={{ fontFamily: 'Syne, sans-serif' }}>Own Screening Plant</h3>
            </div>
            <p className="text-sm mb-6 leading-relaxed" style={{ color: 'rgba(255,255,255,0.85)' }}>
              Our company operates its own large-capacity coal screening plant, ensuring precision sizing and quality control for every consignment.
            </p>
            <p className="font-semibold text-xs mb-3 uppercase tracking-wider" style={{ color: 'rgba(255,255,255,0.6)' }}>Available Sizes</p>
            <div className="grid grid-cols-2 gap-3">
              {screeningSizes.map(size => (
                <div
                  key={size}
                  className="rounded-xl py-3 text-center font-bold text-lg"
                  style={{ backgroundColor: 'rgba(255,255,255,0.15)', fontFamily: 'Syne, sans-serif' }}
                >
                  {size}
                </div>
              ))}
            </div>
          </motion.div>
        </div>
      </div>
    </section>
  )
}
