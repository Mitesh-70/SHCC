import { Navbar } from './components/layout/Navbar'
import { Footer } from './components/layout/Footer'
import { HeroSection } from './pages/HeroSection'
import { AboutSection } from './pages/AboutSection'
import { ProductsSection } from './pages/ProductsSection'
import { PartnersSection } from './pages/PartnersSection'
import { ClientsSection } from './pages/ClientsSection'
import { ContactSection } from './pages/ContactSection'
import './index.css'

function App() {
  return (
    <div className="min-h-screen bg-[#FAF3EB]">
      <Navbar />
      <HeroSection />
      <AboutSection />
      <ProductsSection />
      <PartnersSection />
      <ClientsSection />
      <ContactSection />
      <Footer />
    </div>
  )
}

export default App
