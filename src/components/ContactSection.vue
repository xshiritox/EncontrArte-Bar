<template>
    <section id="contacto" class="contact-section section-spacing van-gogh-texture">
      <font-awesome-icon :icon="['fas', 'map-marker-alt']" class="section-icon" />
      <div class="container">
        <div class="section-header fade-in">
          <h2>Encuéntranos</h2>
          <p>Un espacio donde el arte cobra vida y las conexiones florecen</p>
        </div>
        
        <div class="contact-content">
          <div class="contact-info brush-stroke">
            <div class="info-card swirl-effect">
              <div class="info-icon">
                <font-awesome-icon :icon="['fas', 'map-marker-alt']" />
              </div>
              <div class="info-details">
                <h3>Dirección</h3>
                <p>Ubicado en la Avenida<br>Frente al parque del Palín<br>Jesús Menéndez, Las Tunas</p>
              </div>
            </div>
            
            <div class="info-card swirl-effect">
              <div class="info-icon">
                <font-awesome-icon :icon="['far', 'clock']" />
              </div>
              <div class="info-details">
                <h3>Horarios</h3>
                <div class="schedule">
                  <div class="schedule-item">
                    <span>Lunes - Jueves</span>
                    <span>6:30 PM</span>
                  </div>
                  <div class="schedule-item">
                    <span>Viernes - Domingo</span>
                    <span>8:00 PM</span>
                  </div>
                </div>
              </div>
            </div>
            
            <div class="info-card swirl-effect">
              <div class="info-icon">
                <font-awesome-icon :icon="['fas', 'share-alt']" />
              </div>
              <div class="info-details">
                <h3>Síguenos</h3>
                <div class="social-links">
                  <a href="https://www.instagram.com/encontr_arte_bar/" class="social-link" target="_blank">
                    <font-awesome-icon :icon="['fab', 'instagram']" class="social-icon" />
                    @encontrarte.bar
                  </a>
                  <a href="https://chat.whatsapp.com/DVds3t9T1vfJvI2bnpnS56" class="social-link" target="_blank">
                    <font-awesome-icon :icon="['fab', 'whatsapp']" class="social-icon" />
                    Unirse al Grupo de WhatsApp
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </template>
  
  <script setup lang="ts">
  import { library } from '@fortawesome/fontawesome-svg-core'
  import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
  import { faMapMarkerAlt, faClock, faShareAlt } from '@fortawesome/free-solid-svg-icons'
  import { faInstagram } from '@fortawesome/free-brands-svg-icons'
  
  // Add icons to the library
  library.add(faMapMarkerAlt, faClock, faShareAlt, faInstagram)
  </script>
  
  <style scoped>
  @import url('https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css');
  .contact-section {
    background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #10b981 100%);
    color: white;
    position: relative;
    overflow: hidden;
  }
  
  .contact-section::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="10" cy="10" r="3" fill="rgba(251,191,36,0.2)"/><circle cx="90" cy="20" r="2" fill="rgba(16,185,129,0.2)"/><circle cx="70" cy="90" r="2.5" fill="rgba(249,115,22,0.2)"/><circle cx="30" cy="80" r="2" fill="rgba(59,130,246,0.2)"/></svg>');
    background-size: 150px 150px;
    animation: floatingStars 25s linear infinite;
  }
  
  @keyframes floatingStars {
    0% { transform: translateX(0) translateY(0); }
    100% { transform: translateX(-150px) translateY(-150px); }
  }
  
  .section-header {
    text-align: center;
    margin-bottom: 3rem;
    position: relative;
    z-index: 1;
  }
  
  .section-header h2 {
    font-size: 3rem;
    color: #fbbf24;
    margin-bottom: 1rem;
    font-family: 'Playfair Display', serif;
  }
  
  .section-header p {
    font-size: 1.2rem;
    color: #e5e7eb;
    font-style: italic;
  }
  
  .contact-content {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 2rem;
    padding: 2rem 0;
  }

  .contact-info {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
    width: 100%;
    max-width: 600px;
  }
  
  .info-card {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    padding: 1.5rem;
    border: 1px solid rgba(255, 255, 255, 0.2);
    transition: all 0.3s ease;
    display: flex;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .info-card:hover {
    background: rgba(255, 255, 255, 0.15);
    transform: translateY(-5px);
    box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
  }
  
  .info-icon {
    font-size: 1.5rem;
    margin-right: 1rem;
    color: #fbbf24;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 50%;
  }
  
  .social-icon {
    margin-right: 8px;
    color: #fbbf24;
  }
  
  .section-icon {
    position: absolute;
    top: -25px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 3rem;
    color: #fbbf24;
    background: #1e3a8a;
    padding: 0 1rem;
    border-radius: 50%;
  }
  
  .info-details h3 {
    font-size: 1.3rem;
    color: #fbbf24;
    margin-bottom: 0.5rem;
    font-family: 'Playfair Display', serif;
  }
  
  .info-details p {
    color: #e5e7eb;
    line-height: 1.6;
  }
  
  .schedule {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .schedule-item {
    display: flex;
    gap: 1.5rem;
    align-items: center;
    padding: 0.25rem 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }

  .schedule-item:last-child {
    border-bottom: none;
  }

  .schedule-item span:first-child {
    font-weight: 500;
  }

  .schedule-item span:last-child {
    color: #fbbf24;
    font-weight: 600;
  }
  
  .social-links {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }
  
  .social-link {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: #e5e7eb;
    text-decoration: none;
    transition: color 0.3s ease;
  }
  
  .social-link:hover {
    color: #fbbf24;
  }
  
  .social-icon {
    font-size: 1.2rem;
  }
  
  .contact-form {
    position: relative;
  }
  
  .form-container {
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    padding: 2rem;
    border: 1px solid rgba(255, 255, 255, 0.2);
  }
  
  .form-container h3 {
    font-size: 2rem;
    color: #fbbf24;
    margin-bottom: 0.5rem;
    font-family: 'Playfair Display', serif;
  }
  
  .form-container p {
    color: #e5e7eb;
    margin-bottom: 2rem;
  }
  
  .form-group {
    margin-bottom: 1.5rem;
  }
  
  .form-input {
    width: 100%;
    padding: 1rem;
    border: 2px solid rgba(255, 255, 255, 0.2);
    border-radius: 15px;
    background: rgba(255, 255, 255, 0.1);
    color: white;
    font-size: 1rem;
    transition: all 0.3s ease;
  }
  
  .form-input::placeholder {
    color: rgba(255, 255, 255, 0.7);
  }
  
  .form-input:focus {
    outline: none;
    border-color: #fbbf24;
    background: rgba(255, 255, 255, 0.15);
    box-shadow: 0 0 20px rgba(251, 191, 36, 0.3);
  }
  
  .form-submit {
    width: 100%;
    margin-top: 1rem;
  }
  
  @media (max-width: 768px) {
    .contact-content {
      grid-template-columns: 1fr;
      gap: 2rem;
    }
    
    .section-header h2 {
      font-size: 2rem;
    }
    
    .info-card {
      padding: 1rem;
    }
    
    .form-container {
      padding: 1.5rem;
    }
    
    .schedule-item {
      flex-direction: column;
      align-items: flex-start;
      gap: 0.25rem;
    }
  }
  </style>