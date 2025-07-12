<template>
  <section id="ubicacion" class="map-section section-spacing">
    <div class="container">
      <div class="section-header fade-in">
        <h2>Nuestra Ubicación</h2>
        <p>Jesús Menéndez, Las Tunas</p>
      </div>

        <div class="map-wrapper">
          <div ref="mapContainer" class="map"></div>
          <div class="map-overlay">
            <div class="map-controls">
              <button @click="() => map?.zoomIn()" class="map-control-btn">+</button>
              <button @click="() => map?.zoomOut()" class="map-control-btn">−</button>
            </div>
          </div>
        </div>
      </div>
  </section>
</template>

<script setup lang="ts">
import { onMounted, ref, onBeforeUnmount } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

const mapContainer = ref<HTMLElement | null>(null);
let map: L.Map | null = null;

onMounted(() => {
  if (!mapContainer.value) return;
  
  // Initialize map with the new coordinates
  map = L.map(mapContainer.value).setView([21.163998, -76.478945], 15);

  // Add tile layer
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '© OpenStreetMap contributors'
  }).addTo(map as L.Map);

  // Custom marker icon
  const customIcon = L.divIcon({
    html: `
      <div style="
        background: linear-gradient(135deg, #8B5CF6, #A855F7);
        width: 30px;
        height: 30px;
        border-radius: 50% 50% 50% 0;
        transform: rotate(-45deg);
        border: 3px solid white;
        box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        justify-content: center;
      ">
        <div style="
          width: 8px;
          height: 8px;
          background: white;
          border-radius: 50%;
          transform: rotate(45deg);
        "></div>
      </div>
    `,
    className: 'custom-marker',
    iconSize: [30, 30],
    iconAnchor: [15, 30]
  });

  // Add marker
  L.marker([21.163998, -76.478945], { icon: customIcon })
    .addTo(map)
    .bindPopup(`
      <div style="text-align: center; padding: 10px;">
        <h3 style="color: #8B5CF6; margin: 0 0 5px 0;">Bar Encontrarte</h3>
        <p style="margin: 0; color: #666;">Ubicado en la Avenida<br>Frente al parque del Palín<br>Jesús Menéndez, Las Tunas</p>
        <p style="margin: 5px 0 0 0; font-size: 12px; color: #8B5CF6;">📍 ¡Te esperamos!</p>
      </div>
    `)
    .openPopup();

  // Handle window resize
  const handleResize = () => {
    map?.invalidateSize();
  };
  
  window.addEventListener('resize', handleResize);
  
  // Cleanup
  onBeforeUnmount(() => {
    window.removeEventListener('resize', handleResize);
    map?.remove();
    map = null;
  });
});
</script>

<style scoped>
.map-section {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  position: relative;
  overflow: hidden;
  padding: 4rem 0;
}

.map-container-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 1rem;
}

.map-header {
  text-align: center;
  margin-bottom: 2.5rem;
}

.section-title {
  font-size: 2.5rem;
  color: #1e293b;
  margin-bottom: 0.5rem;
  font-weight: 700;
}

.section-subtitle {
  color: #64748b;
  font-size: 1.1rem;
  max-width: 600px;
  margin: 0 auto;
}

.map-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2rem;
  margin-top: 2rem;
}

.map-info {
  padding: 1.5rem;
}

.info-card {
  background: white;
  border-radius: 1rem;
  padding: 2rem;
  box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  height: 100%;
}

.info-card h3 {
  color: #1e293b;
  font-size: 1.5rem;
  margin-bottom: 1.5rem;
  position: relative;
  padding-bottom: 0.75rem;
}

.info-card h3::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 60px;
  height: 4px;
  background: linear-gradient(90deg, #8B5CF6, #A855F7);
  border-radius: 2px;
}

.address {
  color: #475569;
  line-height: 1.7;
  margin-bottom: 2rem;
  font-size: 1.05rem;
}

.visit-info {
  background: #f8fafc;
  padding: 1.5rem;
  border-radius: 0.75rem;
  margin-top: 2rem;
}

.visit-info h4 {
  color: #1e293b;
  font-size: 1.25rem;
  margin-bottom: 1rem;
}

.visit-info p {
  color: #475569;
  line-height: 1.7;
  margin-bottom: 1.5rem;
  font-size: 0.95rem;
}

.schedule-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #8B5CF6, #A855F7);
  color: white;
  font-weight: 600;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  text-decoration: none;
  transition: all 0.3s ease;
  box-shadow: 0 4px 6px -1px rgba(139, 92, 246, 0.3), 0 2px 4px -1px rgba(139, 92, 246, 0.1);
}

.schedule-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 15px -3px rgba(139, 92, 246, 0.3), 0 4px 6px -2px rgba(139, 92, 246, 0.1);
}

.map-wrapper {
  position: relative;
  border-radius: 1rem;
  overflow: hidden;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  height: 100%;
  min-height: 500px;
}

.map {
  width: 100%;
  height: 100%;
  min-height: 500px;
  border-radius: 1rem;
}

.map-overlay {
  position: absolute;
  top: 1rem;
  right: 1rem;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.map-control-btn {
  background: white;
  border: none;
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  color: #4b5563;
  cursor: pointer;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  transition: all 0.2s ease;
}

.map-control-btn:hover {
  background: #f3f4f6;
  transform: translateY(-1px);
}

/* Responsive styles */
@media (max-width: 1024px) {
  .map-content {
    grid-template-columns: 1fr;
  }
  
  .map-wrapper {
    min-height: 400px;
  }
  
  .map {
    min-height: 400px;
  }
}

@media (max-width: 640px) {
  .section-title {
    font-size: 2rem;
  }
  
  .section-subtitle {
    font-size: 1rem;
  }
  
  .info-card {
    padding: 1.5rem;
  }
  
  .map-wrapper, .map {
    min-height: 350px;
  }
}

.map-section::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><path d="M10,10 C20,5 30,15 40,10 C50,5 60,15 70,10 C80,5 90,15 100,10" stroke="rgba(251,191,36,0.1)" stroke-width="2" fill="none"/><path d="M0,30 C10,25 20,35 30,30 C40,25 50,35 60,30 C70,25 80,35 90,30" stroke="rgba(16,185,129,0.1)" stroke-width="2" fill="none"/></svg>');
  background-size: 200px 200px;
  animation: waveMove 15s ease-in-out infinite;
}

@keyframes waveMove {
  0%, 100% { transform: translateX(0) translateY(0); }
  50% { transform: translateX(-50px) translateY(-30px); }
}

.section-header {
  text-align: center;
  margin-bottom: 3rem;
  position: relative;
  z-index: 1;
}

.section-header h2 {
  font-size: 3rem;
  color: #1e3a8a;
  margin-bottom: 1rem;
  font-family: 'Playfair Display', serif;
}

.section-header p {
  font-size: 1.2rem;
  color: #64748b;
  font-style: italic;
}

.map-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  margin-bottom: 3rem;
  position: relative;
  z-index: 1;
}

.map-frame {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  position: relative;
  overflow: hidden;
}

.map-placeholder {
  width: 100%;
  height: 400px;
  background: linear-gradient(135deg, #1e3a8a 0%, #3b82f6 50%, #10b981 100%);
  border-radius: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.map-content {
  text-align: center;
  color: white;
  z-index: 2;
  position: relative;
}

.location-pin {
  font-size: 3rem;
  margin-bottom: 1rem;
  animation: bounce 2s infinite;
}

.map-content h3 {
  font-size: 2rem;
  color: #fbbf24;
  margin-bottom: 1rem;
  font-family: 'Playfair Display', serif;
}

.map-content p {
  color: #e5e7eb;
  margin-bottom: 2rem;
  font-size: 1.1rem;
}

.map-actions {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  align-items: center;
}

.map-actions .btn-primary,
.map-actions .btn-secondary {
  padding: 0.8rem 1.5rem;
  font-size: 1rem;
  border-radius: 25px;
  text-decoration: none;
  transition: all 0.3s ease;
}

.map-actions .btn-secondary {
  background: transparent;
  color: white;
  border: 2px solid #fbbf24;
}

.map-actions .btn-secondary:hover {
  background: #fbbf24;
  color: #1e3a8a;
}

.map-artistic-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  pointer-events: none;
}

.art-element {
  position: absolute;
  width: 20px;
  height: 20px;
  opacity: 0.3;
}

.art-star {
  background: radial-gradient(circle, #fbbf24 0%, transparent 70%);
  border-radius: 50%;
  animation: twinkle 3s ease-in-out infinite;
}

.art-swirl {
  width: 30px;
  height: 30px;
  border: 3px solid #10b981;
  border-top-color: transparent;
  border-radius: 50%;
  animation: spin 4s linear infinite;
}

@keyframes twinkle {
  0%, 100% { opacity: 0.3; transform: scale(1); }
  50% { opacity: 0.8; transform: scale(1.2); }
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.location-details {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.detail-card {
  background: white;
  border-radius: 15px;
  padding: 1.5rem;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  border-left: 4px solid #fbbf24;
  transition: all 0.3s ease;
}

.detail-card:hover {
  transform: translateX(10px);
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.detail-card h3 {
  color: #1e3a8a;
  margin-bottom: 0.5rem;
  font-size: 1.3rem;
  font-family: 'Playfair Display', serif;
}

.detail-card p {
  color: #64748b;
  line-height: 1.6;
}

.directions-info {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
  position: relative;
  z-index: 1;
}

.transport-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
}

.transport-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem;
  background: linear-gradient(135deg, #f8fafc, #e2e8f0);
  border-radius: 15px;
  transition: all 0.3s ease;
}

.transport-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.transport-icon {
  font-size: 2rem;
  flex-shrink: 0;
}

.transport-details h4 {
  color: #1e3a8a;
  margin-bottom: 0.25rem;
  font-size: 1.1rem;
}

.transport-details p {
  color: #64748b;
  font-size: 0.9rem;
}

@media (max-width: 768px) {
  .map-container {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  
  .section-header h2 {
    font-size: 2rem;
  }
  
  .map-placeholder {
    height: 300px;
  }
  
  .map-content h3 {
    font-size: 1.5rem;
  }
  
  .map-actions {
    flex-direction: column;
  }
  
  .transport-options {
    grid-template-columns: 1fr;
  }
  
  .transport-item {
    flex-direction: column;
    text-align: center;
  }
}

@media (max-width: 768px) {
  .map-container {
    grid-template-columns: 1fr;
    gap: 2rem;
  }
  
  .section-header h2 {
    font-size: 2rem;
  }
  
  .map-placeholder {
    height: 300px;
  }
  
  .map-content h3 {
    font-size: 1.5rem;
  }
  
  .map-actions {
    flex-direction: column;
  }
  
  .transport-options {
    grid-template-columns: 1fr;
  }
  
  .transport-item {
    flex-direction: column;
    text-align: center;
  }
}
</style>