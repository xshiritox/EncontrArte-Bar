<template>
    <footer class="footer van-gogh-texture">
      <div class="container">
        <div class="footer-content">
          <div class="footer-section">
            <div class="footer-logo">
              <h3>EncontrArte Bar</h3>
              <p>Donde el arte cobra vida</p>
            </div>
            <div class="footer-social">
              <a href="https://www.instagram.com/encontr_arte_bar/" class="social-link" target="_blank">
                <font-awesome-icon :icon="['fab', 'instagram']" />
              </a>
              <a href="https://chat.whatsapp.com/DVds3t9T1vfJvI2bnpnS56" class="social-link" target="_blank">
                <font-awesome-icon :icon="['fab', 'whatsapp']" />
              </a>
            </div>
          </div>
          
          <div class="footer-section">
            <h4>Horarios</h4>
            <ul class="footer-links">
              <li>Lun - Jue: 6:30 PM</li>
              <li>Vie - Dom: 8:00 PM</li>
            </ul>
          </div>
          
          <div class="footer-section">
            <h4>Nuestra Misión</h4>
            <p>Crear un espacio donde el arte de Van Gogh inspire cada momento, cada sabor y cada conexión humana.</p>
          </div>
        </div>
        
        <div class="footer-bottom">
          <div class="footer-divider"></div>
          <div class="footer-copyright">
            <p>&copy; 2025 EncontrArte Bar. Todos los derechos reservados.</p>
            <p>Inspirado en la pasión artística de Vincent van Gogh</p>
          </div>
        </div>
      </div>
    </footer>
  </template>
  
  <script setup lang="ts">
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { faInstagram, faWhatsapp } from '@fortawesome/free-brands-svg-icons'
  
  // Añadir los iconos al library
  library.add(faInstagram, faWhatsapp)
  </script>
  
  <style scoped>
  @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css');

  .footer {
    background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #1e3a8a 100%);
    color: white;
    padding: 3rem 0 1rem;
    position: relative;
    overflow: hidden;
  }
  
  .footer::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="25" cy="25" r="1" fill="rgba(251,191,36,0.3)"/><circle cx="75" cy="25" r="1.5" fill="rgba(16,185,129,0.3)"/><circle cx="25" cy="75" r="1.2" fill="rgba(249,115,22,0.3)"/><circle cx="75" cy="75" r="1" fill="rgba(59,130,246,0.3)"/></svg>');
    background-size: 100px 100px;
    animation: starfield 20s linear infinite;
  }
  
  @keyframes starfield {
    0% { transform: translateX(0) translateY(0); }
    100% { transform: translateX(-100px) translateY(-100px); }
  }
  
  .footer-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 2rem;
    margin-bottom: 2rem;
    position: relative;
    z-index: 1;
  }
  
  .footer-section {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }
  
  .footer-logo h3 {
    font-size: 2rem;
    color: #fbbf24;
    margin-bottom: 0.5rem;
    font-family: 'Playfair Display', serif;
  }
  
  .footer-logo p {
    color: #e5e7eb;
    font-style: italic;
  }
  
  .footer-social {
    display: flex;
    gap: 1rem;
    margin-top: 1rem;
  }
  
  .social-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 40px;
    height: 40px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
    color: white;
    text-decoration: none;
    transition: all 0.3s ease;
    backdrop-filter: blur(10px);
  }

  .social-link svg {
    width: 24px;
    height: 24px;
  }
  
  .social-link:hover {
    background: #fbbf24;
    transform: translateY(-3px) rotate(10deg);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  }
  
  .footer-section h4 {
    font-size: 1.3rem;
    color: #fbbf24;
    margin-bottom: 1rem;
    font-family: 'Playfair Display', serif;
  }
  
  .footer-links {
    list-style: none;
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .footer-links li {
    color: #e5e7eb;
    font-size: 0.95rem;
    line-height: 1.6;
  }
  
  .footer-section p {
    color: #e5e7eb;
    line-height: 1.6;
    font-size: 0.95rem;
  }
  
  .footer-bottom {
    position: relative;
    z-index: 1;
  }
  
  .footer-divider {
    width: 100%;
    height: 2px;
    background: linear-gradient(90deg, transparent, #fbbf24, transparent);
    margin-bottom: 1rem;
    border-radius: 1px;
  }
  
  .footer-copyright {
    text-align: center;
    padding-top: 1rem;
  }
  
  .footer-copyright p {
    color: #cbd5e1;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
  }
  
  .footer-copyright p:last-child {
    color: #94a3b8;
    font-size: 0.8rem;
    font-style: italic;
  }
  
  @media (max-width: 768px) {
    .footer-content {
      grid-template-columns: 1fr;
      gap: 1.5rem;
    }
    
    .footer-section {
      text-align: center;
    }
    
    .footer-social {
      justify-content: center;
    }
    
    .footer-logo h3 {
      font-size: 1.5rem;
    }
  }
  </style>