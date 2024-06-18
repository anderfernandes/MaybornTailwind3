const defaultTheme = require('tailwindcss/defaultTheme')

/** @type { import('tailwindcss').Config} */
module.exports = {
  content: [
    './templates/**/*.cfm'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        //sans: ['Inter', 'ui-sans-serif, system-ui'],
      },
    }
  },
  plugins: [require('@tailwindcss/forms')]
}