<template>
    <div id="app">
      <NavBar />
      <HeroSection />
      <MenuSection />
      <ContactSection />
      <MapSection />
      <Footer />
    </div>
  </template>
  
  <script setup lang="ts">
  import NavBar from './components/NavBar.vue'
  import HeroSection from './components/HeroSection.vue'
  import MenuSection from './components/MenuSection.vue'
  import ContactSection from './components/ContactSection.vue'
  import MapSection from './components/MapSection.vue'
  import Footer from './components/Footer.vue'
  </script>
  
  <style>
  * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
  }
  
  body {
    font-family: 'Georgia', serif;
    line-height: 1.6;
    color: #2c3e50;
    overflow-x: hidden;
  }
  
  #app {
    min-height: 100vh;
    background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 25%, #fbbf24 50%, #f97316 75%, #10b981 100%);
    background-size: 400% 400%;
    animation: gradientShift 15s ease infinite;
  }
  
  @keyframes gradientShift {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
  }
  
  .brush-stroke {
    position: relative;
    overflow: hidden;
  }
  
  .brush-stroke::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(45deg, transparent 30%, rgba(255, 255, 255, 0.1) 50%, transparent 70%);
    transform: translateX(-100%);
    transition: transform 0.6s ease;
  }
  
  .brush-stroke:hover::before {
    transform: translateX(100%);
  }
  
  .van-gogh-texture {
    background-image: 
      radial-gradient(circle at 20% 50%, rgba(251, 191, 36, 0.3) 0%, transparent 50%),
      radial-gradient(circle at 80% 20%, rgba(16, 185, 129, 0.3) 0%, transparent 50%),
      radial-gradient(circle at 40% 80%, rgba(59, 130, 246, 0.3) 0%, transparent 50%);
    background-size: 200px 200px, 300px 300px, 250px 250px;
    animation: textureMove 20s linear infinite;
  }
  
  @keyframes textureMove {
    0% { background-position: 0% 0%, 0% 0%, 0% 0%; }
    100% { background-position: 100% 100%, -100% 100%, 100% -100%; }
  }
  
  .section-spacing {
    padding: 4rem 0;
  }
  
  .container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 1rem;
  }
  
  .btn-primary {
    background: linear-gradient(45deg, #fbbf24, #f97316);
    color: white;
    border: none;
    padding: 1rem 2rem;
    border-radius: 50px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
    position: relative;
    overflow: hidden;
  }
  
  .btn-primary::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: left 0.5s ease;
  }
  
  .btn-primary:hover::before {
    left: 100%;
  }
  
  .btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  }
  
  .fade-in {
    opacity: 0;
    transform: translateY(30px);
    animation: fadeInUp 0.8s ease forwards;
  }
  
  @keyframes fadeInUp {
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
  
  .swirl-effect {
    position: relative;
  }
  
  .swirl-effect::after {
    content: '';
    position: absolute;
    top: -10px;
    left: -10px;
    right: -10px;
    bottom: -10px;
    border: 3px solid transparent;
    border-top-color: #fbbf24;
    border-radius: 50%;
    animation: swirl 3s linear infinite;
    opacity: 0;
    transition: opacity 0.3s ease;
  }
  
  .swirl-effect:hover::after {
    opacity: 1;
  }
  
  @keyframes swirl {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  
  h1, h2, h3 {
    font-family: 'Playfair Display', serif;
    font-weight: 700;
    color: #1e3a8a;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  }
  
  p {
    font-family: 'Inter', sans-serif;
    line-height: 1.8;
    color: #374151;
  }
  
  @media (max-width: 768px) {
    .container {
      padding: 0 1rem;
    }
    
    .section-spacing {
      padding: 2rem 0;
    }
    
    .btn-primary {
      padding: 0.8rem 1.5rem;
      font-size: 1rem;
    }
  }
  </style>