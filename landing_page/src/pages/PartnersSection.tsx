import { useRef } from 'react'
import { motion, useInView } from 'framer-motion'
import { InfiniteSlider } from '../components/ui/infinite-slider'
import { ProgressiveBlur } from '../components/ui/progressive-blur'
import { Sparkles } from '../components/ui/sparkles'

const O = '#F5821F'
const C = '#2C2C2C'
const BG = '#FAF3EB'

const whyUsPoints = [
  { icon: '✅', text: 'Quality-Assured Variety of Coals' },
  { icon: '💰', text: 'Economical Product Pricing Policy' },
  { icon: '🏆', text: 'Reputed Clientele, In Home' },
  { icon: '🚚', text: 'Expedite Delivery of Consignments' },
  { icon: '⚙️', text: 'Efficient Product Supply Chain' },
  { icon: '😊', text: 'Strong Focus on Customer Delight' },
]

const industryPartners = [
  { name: 'Garden Silk Mills', type: 'Textile', domain: 'gardensilkmills.com' },
  { name: 'Hubergroup Ind Pvt Ltd', type: 'Textile', domain: 'hubergroup.com' },
  { name: 'Alok Industries', type: 'Textile', domain: 'alokind.com' },
  { name: 'Birla Century', type: 'Textile', domain: 'centurytextind.com' },
  { name: 'Sumilon Industries', type: 'Textile', domain: 'sumilon.com' },
  { name: 'Vardhman Fabrics', type: 'Textile', domain: 'vardhman.com', logoSrc: '/logos/vardhaman.png' },
  { name: 'Gayatrishakti Paper', type: 'Paper', domain: 'gayatrishakti.com', logoSrc: '/logos/gayatrishakti.png' },
  { name: 'Best Paper Mills', type: 'Paper', domain: 'bestpaper.in', logoSrc: '/logos/best-paper.png' },
  { name: 'Shree Ajit Pulp & Paper', type: 'Paper', domain: 'shreeajit.com' },
  { name: 'Dipak Nitrate', type: 'Chemical', domain: 'dipaknitrate.com', logoSrc: '/logos/dipak-nitrate.png' },
  { name: 'SRF Ltd', type: 'Chemical', domain: 'srf.com', logoSrc: '/logos/srf.png' },
  { name: 'Demosha Chemicals', type: 'Chemical', domain: 'demosha.com', logoSrc: '/logos/demosha.png' },
  { name: 'Saint Gobain', type: 'Glass', domain: 'saint-gobain.com' },
  { name: 'Vital Laboratories', type: 'Pharma', domain: 'vitallaboratories.com' },
  { name: 'Ciron Drugs', type: 'Pharma', domain: 'cironpharma.com' },
  { name: 'Cadila Healthcare', type: 'Pharma', domain: 'zyduslife.com' },
  { name: 'Farmsons Pharma', type: 'Pharma', domain: 'farmsons.com' },
  { name: 'Trinetra Cement', type: 'Cement', domain: 'indiacements.co.in', logoSrc: '/logos/trinetra.png' },
  { name: 'Kalyani India', type: 'Cement', domain: 'kalyani.com', logoSrc: '/logos/kalyani.png' },
  { name: 'CEAT Ltd', type: 'Tyre', domain: 'ceat.com' },
  { name: 'Detox India', type: 'Waste Mgmt', domain: 'detoxgroup.in' },
]

export function PartnersSection() {
  const ref = useRef(null)
  const inView = useInView(ref, { once: true, margin: '-80px' })

  return (
    <section id="partners" className="py-24 overflow-hidden" style={{ backgroundColor: BG }} ref={ref}>
      <div className="max-w-7xl mx-auto px-6">
        {/* Header */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <p className="font-semibold tracking-widest text-sm uppercase mb-3" style={{ color: O }}>Why Choose Us</p>
          <h2 className="font-bold text-4xl md:text-5xl mb-4 pb-2" style={{ fontFamily: 'Syne, sans-serif', color: C, lineHeight: '1.2' }}>
            The SHCC<br/><span style={{ color: O }}>Advantage</span>
          </h2>
          <div className="w-16 h-1 rounded-full mx-auto" style={{ background: `linear-gradient(to right, ${O}, #FFA757)` }} />
        </motion.div>

        {/* Why Us Grid */}
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-24">
          {whyUsPoints.map((pt, i) => (
            <motion.div
              key={pt.text}
              initial={{ opacity: 0, y: 20 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ duration: 0.5, delay: i * 0.08 }}
              className="flex items-center gap-4 bg-white rounded-2xl px-6 py-5 border transition-all duration-300 hover:-translate-y-1 hover:shadow-lg"
              style={{ borderColor: 'rgba(245,130,31,0.15)' }}
            >
              <span className="text-2xl flex-shrink-0">{pt.icon}</span>
              <p className="font-semibold text-sm" style={{ color: C }}>{pt.text}</p>
            </motion.div>
          ))}
        </div>

        {/* Trusted by section */}
        <motion.div
          initial={{ opacity: 0, y: 30 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.6, delay: 0.3 }}
          className="text-center mb-10"
        >
          <p className="font-semibold tracking-widest text-sm uppercase mb-3" style={{ color: O }}>Our Partners</p>
          <h3 className="font-bold text-3xl md:text-4xl" style={{ fontFamily: 'Syne, sans-serif', color: C }}>
            Trusted by Industry <span style={{ color: O }}>Leaders</span>
          </h3>
          <p className="mt-3 text-sm" style={{ color: 'rgba(44,44,44,0.5)' }}>
            Serving textile, pharma, cement, glass, chemical and tyre industries across India.
          </p>
        </motion.div>

        {/* Infinite Slider */}
        <div className="relative h-20 w-full mb-16">
          <InfiniteSlider className="flex h-full w-full items-center" duration={80} gap={20}>
            {industryPartners.map((partner) => (
              <div
                key={partner.name}
                className="flex items-center gap-3 bg-white rounded-xl px-6 py-3 flex-shrink-0"
                style={{ border: '1px solid rgba(245,130,31,0.18)', boxShadow: '0 1px 4px rgba(0,0,0,0.05)' }}
              >
                <img
                  src={partner.logoSrc || `https://www.google.com/s2/favicons?domain=${partner.domain}&sz=128`}
                  alt={`${partner.name} logo`}
                  className="w-8 h-8 object-contain rounded"
                  onError={(e) => {
                    e.currentTarget.style.display = 'none'
                  }}
                />
                <div>
                  <p className="font-bold text-sm whitespace-nowrap" style={{ fontFamily: 'Syne, sans-serif', color: C }}>{partner.name}</p>
                  <p className="text-xs font-medium" style={{ color: O }}>{partner.type}</p>
                </div>
              </div>
            ))}
          </InfiniteSlider>
          <ProgressiveBlur
            className="pointer-events-none absolute top-0 left-0 h-full w-[120px]"
            direction="left"
            blurIntensity={0.8}
          />
          <ProgressiveBlur
            className="pointer-events-none absolute top-0 right-0 h-full w-[120px]"
            direction="right"
            blurIntensity={0.8}
          />
        </div>

        {/* Sparkles CTA band */}
        <div
          className="relative h-48 w-full overflow-hidden rounded-3xl"
          style={{ maskImage: 'radial-gradient(60% 60%, white, transparent)', WebkitMaskImage: 'radial-gradient(60% 60%, white, transparent)' }}
        >
          <div
            className="absolute inset-0 rounded-3xl"
            style={{ background: 'linear-gradient(135deg, rgba(245,130,31,0.15), rgba(232,148,26,0.08))' }}
          />
          <div
            className="absolute z-10 w-[200%] rounded-[100%]"
            style={{
              left: '-50%',
              top: '50%',
              aspectRatio: '1/0.7',
              borderTop: '1px solid rgba(245,130,31,0.2)',
              backgroundColor: BG,
            }}
          />
          <Sparkles
            density={500}
            className="absolute inset-x-0 bottom-0 h-full w-full"
            color={O}
            opacity={0.6}
            speed={0.8}
          />
        </div>
      </div>
    </section>
  )
}
