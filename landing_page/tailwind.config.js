/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  safelist: [
    // Ensure these are never purged
    'bg-[#FAF3EB]',
    'text-brand-orange',
    'bg-brand-orange',
    'border-brand-orange',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        display: ['Syne', 'sans-serif'],
      },
      colors: {
        brand: {
          orange: '#F5821F',
          amber: '#FFA757',
          cream: '#FAF3EB',
          dark: '#1A1A1A',
          coal: '#2C2C2C',
          gold: '#E8941A',
        },
      },
      animation: {
        'fade-up': 'fadeUp 0.7s ease-out forwards',
        'slide-in': 'slideIn 0.5s ease-out forwards',
      },
      keyframes: {
        fadeUp: {
          '0%': { opacity: '0', transform: 'translateY(30px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        slideIn: {
          '0%': { opacity: '0', transform: 'translateX(-20px)' },
          '100%': { opacity: '1', transform: 'translateX(0)' },
        },
      },
    },
  },
  plugins: [],
}