import { createApp } from 'vue'
import './style.css'
import App from './App.vue'

// Configuración de Font Awesome
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

// Importar iconos sólidos
import { faMapMarkerAlt, faPhoneAlt, faShareAlt } from '@fortawesome/free-solid-svg-icons'

// Importar iconos regulares
import { faClock, faEnvelope } from '@fortawesome/free-regular-svg-icons'

// Importar iconos de marcas
import { faInstagram, faFacebookF, faWhatsapp } from '@fortawesome/free-brands-svg-icons'

// Añadir iconos a la biblioteca
library.add(
  faMapMarkerAlt,
  faPhoneAlt,
  faShareAlt,
  faClock,
  faEnvelope,
  faInstagram,
  faFacebookF,
  faWhatsapp
)

const app = createApp(App)

// Registrar componente FontAwesome globalmente
app.component('font-awesome-icon', FontAwesomeIcon)

app.mount('#app')
