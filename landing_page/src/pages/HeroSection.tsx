import { motion } from 'framer-motion'
import { AuroraBackground } from '../components/ui/aurora-background'

const fadeUp = {
  hidden: { opacity: 0, y: 40 },
  visible: (delay = 0) => ({
    opacity: 1,
    y: 0,
    transition: { duration: 0.7, ease: 'easeOut', delay },
  }),
}

export function HeroSection() {
  return (
    <AuroraBackground showRadialGradient>
      <div className="relative z-10 max-w-5xl mx-auto px-6 text-center">
        {/* Badge */}
        <motion.h2
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, duration: 0.5 }}
          className="font-bold text-2xl md:text-5xl mb-6"
          style={{ fontFamily: 'Syne, sans-serif', color: '#2C2C2C' }}
        >
          Shree Hari Coal Corporation
        </motion.h2>

        {/* Heading */}
        <motion.h1
          variants={fadeUp}
          initial="hidden"
          animate="visible"
          custom={0.3}
          className="font-bold text-6xl md:text-8xl lg:text-8xl leading-tight tracking-tight mb-8"
          style={{ fontFamily: 'Syne, sans-serif', color: '#2C2C2C' }}
        >
          Trusted Source of 
          <br />
          <span
            style={{
              background: 'linear-gradient(to right, #F5821F, #FFA757, #E8941A)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              backgroundClip: 'text',
            }}
          >
             Imported Coal.
          </span>
        </motion.h1>

        {/* Subtext */}
        <motion.p
          variants={fadeUp}
          initial="hidden"
          animate="visible"
          custom={0.5}
          className="text-lg md:text-xl max-w-2xl mx-auto mb-12 leading-relaxed"
          style={{ color: 'rgba(44,44,44,0.6)' }}
        >
          Shree Hari Coal Corporation — India's reliable importer &amp; wholesaler of premium coal
          from Indonesia, South Africa, USA &amp; Russia. Known for product consistency, price reliability
          and delivery accuracy.
        </motion.p>

        {/* CTA Buttons */}
        <motion.div
          variants={fadeUp}
          initial="hidden"
          animate="visible"
          custom={0.7}
          className="flex flex-col sm:flex-row gap-4 justify-center"
        >
          <a
            href="#products"
            className="inline-flex items-center justify-center gap-2 text-white font-semibold px-8 py-4 rounded-full transition-all duration-300 text-base"
            style={{ backgroundColor: '#F5821F' }}
          >
            Explore Products
            <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 8l4 4m0 0l-4 4m4-4H3" />
            </svg>
          </a>
          <a
            href="#contact"
            className="inline-flex items-center justify-center gap-2 font-semibold px-8 py-4 rounded-full transition-all duration-300 text-base"
            style={{
              border: '2px solid #F5821F',
              color: '#F5821F',
              backgroundColor: 'transparent',
            }}
          >
            Get a Quote
          </a>
        </motion.div>

        {/* Stats */}
        <motion.div
          variants={fadeUp}
          initial="hidden"
          animate="visible"
          custom={0.9}
          className="mt-16 grid grid-cols-3 gap-6 max-w-xl mx-auto"
        >
          {[
            { value: '4+', label: 'Coal Origins' },
            { value: '7+', label: 'Active Ports' },
            { value: '20+', label: 'Major Clients' },
          ].map((stat) => (
            <div key={stat.label} className="text-center">
              <p className="font-bold text-3xl md:text-4xl" style={{ fontFamily: 'Syne, sans-serif', color: '#F5821F' }}>{stat.value}</p>
              <p className="text-sm mt-1 font-medium" style={{ color: 'rgba(44,44,44,0.5)' }}>{stat.label}</p>
            </div>
          ))}
        </motion.div>
      </div>


    </AuroraBackground>
  )
}
