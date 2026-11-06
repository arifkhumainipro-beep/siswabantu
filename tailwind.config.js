/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        selangor: {
          red: '#4F46E5', // Professional Indigo 600
          'red-dark': '#4338CA', // Indigo 700
          'red-light': '#6366F1', // Indigo 500
          yellow: '#06B6D4', // Modern Cyan 500
          'yellow-light': '#22D3EE', // Cyan 400
          amber: '#0891B2', // Cyan 600
        },
        brand: {
          50: '#EEF2FF',
          100: '#E0E7FF',
          200: '#C7D2FE',
          500: '#4F46E5',
          600: '#4338CA',
          700: '#3730A3',
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'Inter', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        'card': '0 4px 20px -2px rgba(0, 0, 0, 0.06), 0 2px 6px -1px rgba(0, 0, 0, 0.04)',
        'float': '0 20px 35px -8px rgba(79, 70, 229, 0.25)',
      }
    },
  },
  plugins: [],
}
