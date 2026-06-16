import Hero from '@/components/Hero'
import About from '@/components/About'
import Skills from '@/components/Skills'
import ProjectsSection from '@/components/ProjectsSection'
import SocialLinks from '@/components/SocialLinks'
import Contact from '@/components/Contact'
import Navbar from '@/components/Navbar'
import Footer from '@/components/Footer'

export default function Home() {
  return (
    <div className="relative">
      <Navbar />
      <div className="max-w-7xl mx-auto px-6 sm:px-12 lg:px-16 space-y-32 py-20">
        <Hero />
        <About />
        <Skills />
        <ProjectsSection />
        <Contact />
      </div>
      <SocialLinks />
      <Footer />
    </div>
  )
}
