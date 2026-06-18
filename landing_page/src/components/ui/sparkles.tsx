// Pure CSS sparkle effect — replaces @tsparticles which has React 19 peer dep issues
import { useEffect, useRef } from 'react'

interface SparklesProps {
  className?: string
  density?: number
  color?: string
  opacity?: number
}

export function Sparkles({ className, density = 500, color = '#F5821F', opacity = 0.6 }: SparklesProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null)

  useEffect(() => {
    const canvas = canvasRef.current
    if (!canvas) return
    const ctx = canvas.getContext('2d')
    if (!ctx) return

    let animationId: number
    const particles: { x: number; y: number; r: number; alpha: number; speed: number; dir: number }[] = []

    const resize = () => {
      canvas.width = canvas.offsetWidth
      canvas.height = canvas.offsetHeight
    }
    resize()
    window.addEventListener('resize', resize)

    const count = Math.floor((canvas.width * canvas.height) / (800000 / density))
    for (let i = 0; i < count; i++) {
      particles.push({
        x: Math.random() * canvas.width,
        y: Math.random() * canvas.height,
        r: Math.random() * 1.5 + 0.3,
        alpha: Math.random() * opacity,
        speed: Math.random() * 0.015 + 0.005,
        dir: Math.random() > 0.5 ? 1 : -1,
      })
    }

    const hex = color.replace('#', '')
    const r = parseInt(hex.substring(0, 2), 16)
    const g = parseInt(hex.substring(2, 4), 16)
    const b = parseInt(hex.substring(4, 6), 16)

    const draw = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      for (const p of particles) {
        p.alpha += p.speed * p.dir
        if (p.alpha >= opacity) { p.alpha = opacity; p.dir = -1 }
        if (p.alpha <= 0) { p.alpha = 0; p.dir = 1 }
        ctx.beginPath()
        ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2)
        ctx.fillStyle = `rgba(${r},${g},${b},${p.alpha})`
        ctx.fill()
      }
      animationId = requestAnimationFrame(draw)
    }
    draw()

    return () => {
      cancelAnimationFrame(animationId)
      window.removeEventListener('resize', resize)
    }
  }, [density, color, opacity])

  return (
    <canvas
      ref={canvasRef}
      className={className}
      style={{ width: '100%', height: '100%', display: 'block' }}
    />
  )
}
