'use client'

export function Logo() {
  return (
    <div className="flex flex-col items-center gap-4">
      {/* Icon mark */}
      <div className="relative w-16 h-16 sm:w-20 sm:h-20">
        <svg
          viewBox="0 0 80 80"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
          className="w-full h-full"
        >
          {/* House shape with modern geometric style */}
          <path
            d="M40 8L8 32V72H72V32L40 8Z"
            stroke="url(#copper-gradient)"
            strokeWidth="2.5"
            fill="none"
          />
          {/* Door */}
          <rect
            x="32"
            y="48"
            width="16"
            height="24"
            stroke="url(#copper-gradient)"
            strokeWidth="2"
            fill="none"
          />
          {/* Window left */}
          <rect
            x="16"
            y="40"
            width="10"
            height="10"
            stroke="url(#copper-gradient)"
            strokeWidth="1.5"
            fill="none"
          />
          {/* Window right */}
          <rect
            x="54"
            y="40"
            width="10"
            height="10"
            stroke="url(#copper-gradient)"
            strokeWidth="1.5"
            fill="none"
          />
          {/* Chimney */}
          <rect
            x="54"
            y="16"
            width="8"
            height="14"
            stroke="url(#copper-gradient)"
            strokeWidth="1.5"
            fill="none"
          />
          <defs>
            <linearGradient id="copper-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stopColor="#d4a574" />
              <stop offset="50%" stopColor="#c17f59" />
              <stop offset="100%" stopColor="#d4a574" />
            </linearGradient>
          </defs>
        </svg>
        
        {/* Animated glow */}
        <div className="absolute inset-0 blur-2xl bg-brand-copper/20 animate-pulse-slow" />
      </div>
      
      {/* Wordmark */}
      <div className="text-center">
        <h2 className="font-display text-2xl sm:text-3xl font-bold tracking-tight">
          <span className="text-brand-cream">maadi</span>
          <span className="text-gradient">housing</span>
        </h2>
      </div>
    </div>
  )
}

