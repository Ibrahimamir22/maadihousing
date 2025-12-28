export function BackgroundElements() {
  return (
    <>
      {/* Base gradient */}
      <div className="fixed inset-0 bg-brand-midnight" />
      
      {/* Radial glow from top */}
      <div className="fixed inset-0 radial-glow" />
      
      {/* Geometric pattern overlay */}
      <div className="fixed inset-0 geo-pattern opacity-50" />
      
      {/* Floating orbs */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        {/* Large copper orb - top right */}
        <div 
          className="absolute -top-32 -right-32 w-96 h-96 rounded-full 
                     bg-gradient-to-br from-brand-copper/10 to-transparent 
                     blur-3xl animate-float"
        />
        
        {/* Medium gold orb - bottom left */}
        <div 
          className="absolute -bottom-24 -left-24 w-80 h-80 rounded-full 
                     bg-gradient-to-tr from-brand-gold/8 to-transparent 
                     blur-3xl animate-float"
          style={{ animationDelay: '-3s' }}
        />
        
        {/* Small accent orb - center right */}
        <div 
          className="absolute top-1/2 right-0 w-64 h-64 rounded-full 
                     bg-gradient-to-l from-brand-copper/5 to-transparent 
                     blur-2xl animate-float"
          style={{ animationDelay: '-1.5s' }}
        />
      </div>
      
      {/* Subtle grid lines */}
      <div 
        className="fixed inset-0 opacity-[0.02]"
        style={{
          backgroundImage: `
            linear-gradient(to right, rgba(245, 240, 232, 0.1) 1px, transparent 1px),
            linear-gradient(to bottom, rgba(245, 240, 232, 0.1) 1px, transparent 1px)
          `,
          backgroundSize: '80px 80px',
        }}
      />
      
      {/* Vignette effect */}
      <div 
        className="fixed inset-0 pointer-events-none"
        style={{
          background: 'radial-gradient(ellipse at center, transparent 0%, rgba(10, 10, 15, 0.4) 100%)',
        }}
      />
    </>
  )
}

