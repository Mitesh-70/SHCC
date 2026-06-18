// Pure CSS progressive blur — no framer-motion, no external deps
type ProgressiveBlurProps = {
  direction?: 'left' | 'right' | 'top' | 'bottom'
  className?: string
  blurIntensity?: number
}

export function ProgressiveBlur({ direction = 'right', className, blurIntensity = 0.8 }: ProgressiveBlurProps) {
  const gradientMap = {
    left:   'linear-gradient(to right, white, transparent)',
    right:  'linear-gradient(to left, white, transparent)',
    top:    'linear-gradient(to bottom, white, transparent)',
    bottom: 'linear-gradient(to top, white, transparent)',
  }

  return (
    <div
      className={className}
      style={{
        backdropFilter: `blur(${blurIntensity * 4}px)`,
        WebkitBackdropFilter: `blur(${blurIntensity * 4}px)`,
        maskImage: gradientMap[direction],
        WebkitMaskImage: gradientMap[direction],
        backgroundColor: 'transparent',
        pointerEvents: 'none',
      }}
    />
  )
}
