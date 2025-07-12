<template>
    <section id="inicio" class="hero van-gogh-texture">
      <div class="container">
        <div class="hero-content fade-in">
          <h1 class="hero-title">EncontrArte</h1>
          <p class="hero-subtitle">Un lugar donde el arte y los sabores se encuentran</p>
          <p class="hero-description">
            Inspirado en la pasión y el color de Van Gogh, nuestro bar ofrece una experiencia única 
            donde cada bebida es una obra de arte y cada momento es una pincelada de felicidad.
          </p>
          <div class="hero-buttons">
            <a href="#menu" class="btn-primary">Ver Menú</a>
            <a href="#contacto" class="btn-secondary">Contáctanos</a>
          </div>
        </div>
        <div class="hero-artwork">
          <div class="artwork-frame swirl-effect">
            <div class="stars-background"></div>
            <div class="artwork-content">
              <h3>Noche Estrellada</h3>
              <p>Inspiración eterna</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  </template>
  
  <script setup lang="ts">
  </script>
  
  <style scoped>
  .hero {
    min-height: 100vh;
    display: flex;
    align-items: center;
    padding-top: 80px;
    background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #fbbf24 100%);
    position: relative;
    overflow: hidden;
  }
  
  .hero::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="20" cy="20" r="2" fill="rgba(251,191,36,0.3)"/><circle cx="80" cy="40" r="1.5" fill="rgba(16,185,129,0.4)"/><circle cx="60" cy="80" r="1" fill="rgba(249,115,22,0.3)"/><circle cx="30" cy="70" r="1.5" fill="rgba(59,130,246,0.4)"/></svg>');
    background-size: 200px 200px;
    animation: starsMove 30s linear infinite;
  }
  
  @keyframes starsMove {
    0% { transform: translateX(0) translateY(0); }
    100% { transform: translateX(-200px) translateY(-200px); }
  }
  
  .container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 4rem;
    align-items: center;
    position: relative;
    z-index: 1;
  }
  
  .hero-content {
    color: white;
    animation-delay: 0.2s;
  }
  
  .hero-title {
    font-size: 4rem;
    font-family: 'Playfair Display', serif;
    color: #fbbf24;
    margin-bottom: 1rem;
    text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.3);
    position: relative;
  }
  
  .hero-title::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 0;
    width: 100px;
    height: 4px;
    background: linear-gradient(90deg, #fbbf24, #f97316);
    border-radius: 2px;
    animation: titleUnderline 2s ease-in-out infinite alternate;
  }
  
  @keyframes titleUnderline {
    0% { width: 100px; }
    100% { width: 200px; }
  }
  
  .hero-subtitle {
    font-size: 1.5rem;
    margin-bottom: 1.5rem;
    color: #e5e7eb;
    font-style: italic;
  }
  
  .hero-description {
    font-size: 1.1rem;
    margin-bottom: 2rem;
    color: #d1d5db;
    line-height: 1.8;
  }
  
  .hero-buttons {
    display: flex;
    gap: 1rem;
  }
  
  .btn-secondary {
    background: transparent;
    color: white;
    border: 2px solid #fbbf24;
    padding: 1rem 2rem;
    border-radius: 50px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
  }
  
  .btn-secondary:hover {
    background: #fbbf24;
    color: #1e3a8a;
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  }
  
  .hero-artwork {
    display: flex;
    justify-content: center;
    align-items: center;
    animation-delay: 0.4s;
  }
  
  .artwork-frame {
    width: 300px;
    height: 400px;
    background: linear-gradient(135deg, #1e3a8a, #3b82f6);
    border-radius: 20px;
    padding: 2rem;
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
    position: relative;
    overflow: hidden;
  }
  
  .stars-background {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: radial-gradient(circle at 30% 20%, #fbbf24 2px, transparent 2px),
                radial-gradient(circle at 70% 30%, #10b981 1px, transparent 1px),
                radial-gradient(circle at 20% 70%, #f97316 1.5px, transparent 1.5px),
                radial-gradient(circle at 80% 80%, #fbbf24 1px, transparent 1px);
    background-size: 50px 50px, 70px 70px, 60px 60px, 40px 40px;
    animation: starsRotate 20s linear infinite;
  }
  
  @keyframes starsRotate {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  
  .artwork-content {
    position: relative;
    z-index: 1;
    text-align: center;
    color: white;
    padding-top: 8rem;
  }
  
  .artwork-content h3 {
    font-size: 1.8rem;
    color: #fbbf24;
    margin-bottom: 0.5rem;
  }
  
  .artwork-content p {
    color: #e5e7eb;
    font-style: italic;
  }
  
  @media (max-width: 768px) {
    .hero {
      padding-top: 100px;
    }
    
    .container {
      grid-template-columns: 1fr;
      gap: 2rem;
      text-align: center;
    }
    
    .hero-title {
      font-size: 2.5rem;
    }
    
    .hero-subtitle {
      font-size: 1.2rem;
    }
    
    .hero-buttons {
      flex-direction: column;
      align-items: center;
    }
    
    .artwork-frame {
      width: 250px;
      height: 300px;
    }
  }
  </style>