'use client'

import { useEffect, useState } from 'react'

interface TimeLeft {
  days: number
  hours: number
  minutes: number
  seconds: number
}

interface CountdownTimerProps {
  targetDate: Date
}

function calculateTimeLeft(targetDate: Date): TimeLeft {
  const difference = targetDate.getTime() - new Date().getTime()
  
  if (difference <= 0) {
    return { days: 0, hours: 0, minutes: 0, seconds: 0 }
  }
  
  return {
    days: Math.floor(difference / (1000 * 60 * 60 * 24)),
    hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
    minutes: Math.floor((difference / (1000 * 60)) % 60),
    seconds: Math.floor((difference / 1000) % 60),
  }
}

export function CountdownTimer({ targetDate }: CountdownTimerProps) {
  const [timeLeft, setTimeLeft] = useState<TimeLeft>({ days: 0, hours: 0, minutes: 0, seconds: 0 })
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    setTimeLeft(calculateTimeLeft(targetDate))
    
    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft(targetDate))
    }, 1000)

    return () => clearInterval(timer)
  }, [targetDate])

  if (!mounted) {
    return <CountdownSkeleton />
  }

  const timeUnits = [
    { value: timeLeft.days, label: 'Days' },
    { value: timeLeft.hours, label: 'Hours' },
    { value: timeLeft.minutes, label: 'Minutes' },
    { value: timeLeft.seconds, label: 'Seconds' },
  ]

  return (
    <div className="flex gap-3 sm:gap-6">
      {timeUnits.map((unit, index) => (
        <div key={unit.label} className="flex flex-col items-center">
          <div className="glass-panel rounded-2xl p-4 sm:p-6 min-w-[70px] sm:min-w-[90px]">
            <span className="font-display text-3xl sm:text-4xl md:text-5xl font-bold text-gradient tabular-nums">
              {String(unit.value).padStart(2, '0')}
            </span>
          </div>
          <span className="mt-2 text-xs sm:text-sm text-brand-sand/50 uppercase tracking-wider">
            {unit.label}
          </span>
          {/* Separator dots */}
          {index < timeUnits.length - 1 && (
            <div className="hidden sm:flex absolute right-0 top-1/2 -translate-y-1/2 translate-x-1/2 flex-col gap-1.5">
              <div className="w-1.5 h-1.5 rounded-full bg-brand-copper/40" />
              <div className="w-1.5 h-1.5 rounded-full bg-brand-copper/40" />
            </div>
          )}
        </div>
      ))}
    </div>
  )
}

function CountdownSkeleton() {
  return (
    <div className="flex gap-3 sm:gap-6">
      {['Days', 'Hours', 'Minutes', 'Seconds'].map((label) => (
        <div key={label} className="flex flex-col items-center">
          <div className="glass-panel rounded-2xl p-4 sm:p-6 min-w-[70px] sm:min-w-[90px]">
            <span className="font-display text-3xl sm:text-4xl md:text-5xl font-bold text-brand-slate/30 tabular-nums">
              --
            </span>
          </div>
          <span className="mt-2 text-xs sm:text-sm text-brand-sand/50 uppercase tracking-wider">
            {label}
          </span>
        </div>
      ))}
    </div>
  )
}

