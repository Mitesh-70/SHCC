import React, { ReactNode } from "react"

interface AuroraBackgroundProps extends React.HTMLProps<HTMLDivElement> {
  children: ReactNode
  showRadialGradient?: boolean
}

export const AuroraBackground = ({
  className = "",
  children,
  showRadialGradient = true,
  ...props
}: AuroraBackgroundProps) => {
  const whiteGradient =
    "repeating-linear-gradient(100deg,#ffffff 0%,#ffffff 7%,transparent 10%,transparent 12%,#ffffff 16%)"
  const aurora =
    "repeating-linear-gradient(100deg,#fb923c 10%,#fcd34d 15%,#fde047 20%,#fdba74 25%,#fbbf24 30%)"

  const backgroundImage = `${whiteGradient},${aurora}`
  const maskImage = showRadialGradient
    ? "radial-gradient(ellipse at 100% 0%,black 10%,transparent 70%)"
    : undefined

  return (
    <main>
      <div
        className={`relative flex flex-col h-screen items-center justify-center text-slate-950 overflow-hidden ${className}`}
        style={{ backgroundColor: "#FAF3EB" }}
        {...props}
      >
        {/* Aurora layer */}
        <div
          className="absolute pointer-events-none will-change-transform"
          style={{
            inset: "-10px",
            backgroundImage,
            backgroundSize: "300%, 200%",
            backgroundPosition: "50% 50%, 50% 50%",
            filter: "blur(10px)",
            opacity: 0.35,
            maskImage,
            WebkitMaskImage: maskImage,
            animation: "aurora 60s linear infinite",
          }}
        />
        {/* After pseudo-layer via a second div */}
        <div
          className="absolute pointer-events-none"
          style={{
            inset: "-10px",
            backgroundImage,
            backgroundSize: "200%, 100%",
            backgroundAttachment: "fixed",
            mixBlendMode: "difference",
            opacity: 0.15,
            animation: "aurora 60s linear infinite reverse",
          }}
        />
        {children}
      </div>

      <style>{`
        @keyframes aurora {
          from { background-position: 50% 50%, 50% 50%; }
          to   { background-position: 350% 50%, 350% 50%; }
        }
      `}</style>
    </main>
  )
}
