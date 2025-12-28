import { Logo } from '@/components/logo'
import { EmailForm } from '@/components/email-form'
import { CountdownTimer } from '@/components/countdown-timer'
import { BackgroundElements } from '@/components/background-elements'

export default function ComingSoonPage() {
  // Set your launch date here
  const launchDate = new Date('2026-03-01T00:00:00')

  return (
    <main className="relative min-h-screen overflow-hidden">
      {/* Background layers */}
      <BackgroundElements />
      
      {/* Main content */}
      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen px-6 py-12">
        {/* Logo */}
        <div 
          className="mb-8 animate-fade-in"
          style={{ animationDelay: '0.1s' }}
        >
          <Logo />
        </div>

        {/* Hero section */}
        <div 
          className="text-center max-w-2xl mx-auto mb-12 animate-slide-up"
          style={{ animationDelay: '0.2s', animationFillMode: 'backwards' }}
        >
          <h1 className="font-display text-4xl sm:text-5xl md:text-6xl font-bold mb-6 leading-tight">
            <span className="text-brand-cream">Find Your Perfect</span>
            <br />
            <span className="text-gradient">Home in Maadi</span>
          </h1>
          
          <p className="text-brand-sand/70 text-lg sm:text-xl leading-relaxed max-w-lg mx-auto">
            Premium real estate solutions tailored for the discerning resident. 
            We&apos;re building something exceptional.
          </p>
        </div>

        {/* Countdown */}
        <div 
          className="mb-12 animate-slide-up"
          style={{ animationDelay: '0.4s', animationFillMode: 'backwards' }}
        >
          <CountdownTimer targetDate={launchDate} />
        </div>

        {/* Email signup */}
        <div 
          className="w-full max-w-md mx-auto mb-16 animate-slide-up"
          style={{ animationDelay: '0.6s', animationFillMode: 'backwards' }}
        >
          <p className="text-center text-brand-sand/60 text-sm mb-4">
            Be the first to know when we launch
          </p>
          <EmailForm />
        </div>

        {/* Footer */}
        <footer
          className="absolute bottom-6 left-0 right-0 text-center animate-fade-in"
          style={{ animationDelay: '1s', animationFillMode: 'backwards' }}
        >
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-4">
            <a
              href="mailto:info@maadihousing.com"
              className="text-brand-copper hover:text-brand-gold transition-colors duration-300 text-sm"
            >
              info@maadihousing.com
            </a>
            <span className="text-brand-slate text-xs hidden sm:block">•</span>
            <p className="text-brand-slate text-sm">
              © {new Date().getFullYear()} Maadi Housing. All rights reserved.
            </p>
          </div>
        </footer>
      </div>
    </main>
  )
}

