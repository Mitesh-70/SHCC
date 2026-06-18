import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'

export function Navbar() {
  const [scrolled, setScrolled] = useState(false)
  const [menuOpen, setMenuOpen] = useState(false)

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 20)
    window.addEventListener('scroll', onScroll)
    return () => window.removeEventListener('scroll', onScroll)
  }, [])

  const links = [
    { label: 'About', href: '#about' },
    { label: 'Products', href: '#products' },
    { label: 'Clients', href: '#clients' },
    { label: 'Contact', href: '#contact' },
  ]

  return (
    <motion.nav
      initial={{ y: -80, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.6, ease: 'easeOut' }}
      className={`fixed top-4 md:top-6 left-4 right-4 md:left-8 md:right-8 max-w-7xl mx-auto z-50 transition-all duration-300 rounded-3xl ${
        scrolled
          ? 'bg-white/80 backdrop-blur-xl shadow-lg border border-white/40'
          : 'bg-transparent shadow-none border border-transparent'
      }`}
    >
      <div className={`px-4 md:px-6 flex items-center justify-between transition-all duration-300 ${scrolled ? 'py-2' : 'py-3'}`}>
        <div className="flex items-center lg:gap-10">
          <a href="#" className="flex items-center">
            <img 
              src="/logo.png" 
              alt="SHCC Logo" 
              className={`object-contain transition-all duration-500 ease-in-out ${scrolled ? 'h-10 md:h-12' : 'h-16 md:h-20'}`} 
              onError={(e) => {
                e.currentTarget.outerHTML = `<div class="bg-[#F5821F] rounded-xl flex items-center justify-center shadow-md transition-all duration-500 ease-in-out ${scrolled ? 'w-10 h-10' : 'w-16 h-16'}"><span class="text-white font-bold tracking-tight ${scrolled ? 'text-xs' : 'text-lg'}">SHCC</span></div>`
              }} 
            />
            <span 
              className={`font-bold text-[#2C2C2C] text-lg md:text-xl transition-all duration-500 ease-in-out overflow-hidden whitespace-nowrap ${scrolled ? 'max-w-[400px] opacity-100 ml-3' : 'max-w-0 opacity-0 ml-0'}`} 
              style={{ fontFamily: 'Syne, sans-serif' }}
            >
              Shree Hari Coal Corporation
            </span>
          </a>

          <div className="hidden lg:flex items-center gap-6">
            {links.map((link) => (
              <a
                key={link.href}
                href={link.href}
                className={`text-[#2C2C2C]/80 hover:text-[#2C2C2C] font-semibold transition-all duration-300 relative group ${scrolled ? 'text-base' : 'text-lg'}`}
              >
                {link.label}
                <span className="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#F5821F] rounded-full transition-all duration-300 group-hover:w-full" />
              </a>
            ))}
          </div>
        </div>

        <div className="hidden lg:flex items-center">
          <a
            href="/login"
            className="inline-flex items-center gap-2 bg-[#1A1A1A] text-white font-semibold px-6 py-2.5 rounded-full hover:bg-black transition-all duration-300 text-sm shadow-sm"
          >
            Login
          </a>
        </div>

        <button className="md:hidden flex flex-col gap-1.5 p-2" onClick={() => setMenuOpen(!menuOpen)}>
          <span className={`block w-6 h-0.5 bg-[#2C2C2C] transition-all duration-300 ${menuOpen ? 'rotate-45 translate-y-2' : ''}`} />
          <span className={`block w-6 h-0.5 bg-[#2C2C2C] transition-all duration-300 ${menuOpen ? 'opacity-0' : ''}`} />
          <span className={`block w-6 h-0.5 bg-[#2C2C2C] transition-all duration-300 ${menuOpen ? '-rotate-45 -translate-y-2' : ''}`} />
        </button>
      </div>

      {menuOpen && (
        <motion.div
          initial={{ opacity: 0, height: 0 }}
          animate={{ opacity: 1, height: 'auto' }}
          className="md:hidden bg-white/95 backdrop-blur-md border-t border-orange-100 px-6 pb-6"
        >
          <div className="flex flex-col gap-4 pt-4">
            {links.map((link) => (
              <a
                key={link.href}
                href={link.href}
                onClick={() => setMenuOpen(false)}
                className="text-[#2C2C2C] font-medium py-2 border-b border-orange-50 hover:text-[#F5821F] transition-colors"
              >
                {link.label}
              </a>
            ))}
            <a
              href="#contact"
              className="inline-flex justify-center items-center bg-[#F5821F] text-white font-semibold px-6 py-2.5 rounded-full hover:bg-[#E8941A] transition-all duration-300 text-sm mt-2"
            >
              Get a Quote
            </a>
          </div>
        </motion.div>
      )}
    </motion.nav>
  )
}
