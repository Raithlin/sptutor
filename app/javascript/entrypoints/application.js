// Import application CSS
import '../stylesheets/application.css'

// Import Alpine.js and alpine-ajax
import Alpine from 'alpinejs'
import ajax from '@imacrayon/alpine-ajax'

// Register Alpine plugins
Alpine.plugin(ajax)

// Start Alpine
window.Alpine = Alpine
Alpine.start()

console.log('Smarty Pants Tutoring - Vite ⚡️ Rails + Alpine.js')
