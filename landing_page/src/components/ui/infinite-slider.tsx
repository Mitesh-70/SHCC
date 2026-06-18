// Pure CSS infinite slider — no external deps, no React 19 issues
import { ReactNode } from 'react'

type InfiniteSliderProps = {
  children: ReactNode
  gap?: number
  duration?: number
  className?: string
}

export function InfiniteSlider({ children, gap = 20, duration = 35, className }: InfiniteSliderProps) {
  return (
    <div className={`overflow-hidden flex items-center ${className ?? ''}`}>
      <div
        className="flex w-max min-w-max flex-shrink-0"
        style={{
          animation: `marquee ${duration}s linear infinite`,
        }}
      >
        <div className="flex flex-shrink-0 items-center" style={{ gap: `${gap}px`, paddingRight: `${gap}px` }}>{children}</div>
        <div className="flex flex-shrink-0 items-center" style={{ gap: `${gap}px`, paddingRight: `${gap}px` }}>{children}</div>
        <div className="flex flex-shrink-0 items-center" style={{ gap: `${gap}px`, paddingRight: `${gap}px` }}>{children}</div>
        <div className="flex flex-shrink-0 items-center" style={{ gap: `${gap}px`, paddingRight: `${gap}px` }}>{children}</div>
      </div>

      <style>{`
        @keyframes marquee {
          0%   { transform: translateX(0); }
          100% { transform: translateX(-25%); }
        }
      `}</style>
    </div>
  )
}
