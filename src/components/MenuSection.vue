<template>
  <section id="menu" class="menu-section section-spacing van-gogh-texture">
    <div class="container">
      <div class="section-header fade-in">
        <h2>Nuestro Menú</h2>
        <p>Sabores únicos inspirados en el arte de Van Gogh</p>
      </div>

      <div class="menu-content">
        <div v-if="loading" class="loading-state">
          <div class="loading-spinner"></div>
          <p>Cargando nuestras deliciosas creaciones...</p>
        </div>

        <div v-else-if="error" class="error-state">
          <font-awesome-icon :icon="['fas', 'exclamation-triangle']" class="error-icon" />
          <p>{{ error }}</p>
          <button @click="fetchMenuItems" class="btn-primary">Intentar de nuevo</button>
        </div>

        <div v-else-if="menuItems.length === 0" class="empty-state">
          <font-awesome-icon :icon="['fas', 'coffee']" class="empty-icon" />
          <p>Próximamente tendremos nuestro menú disponible</p>
        </div>

        <div v-else class="menu-grid">
          <div v-for="item in menuItems" :key="item.id" class="menu-item brush-stroke swirl-effect">
            <div class="item-image">
              <img :src="item.image_url || defaultImage" :alt="item.name" @error="handleImageError" />
              <div class="image-overlay">
                <div class="overlay-content">
                  <font-awesome-icon :icon="['fas', 'star']" class="star-icon" />
                </div>
              </div>
            </div>
            <div class="item-details">
              <h3 class="item-name">{{ item.name }}</h3>
              <p class="item-description">{{ item.description }}</p>
              <div class="item-price">
                <span class="price-amount">${{ Number(item.price).toFixed(2) }}</span>
                <span class="price-currency">CUP</span>
              </div>
            </div>
          </div>
        </div>

        <div v-if="menuItems.length > 0" class="menu-footer">
          <div class="menu-note">
            <font-awesome-icon :icon="['fas', 'palette']" class="palette-icon" />
            <p>Cada bebida es preparada con la pasión y dedicación que Van Gogh ponía en sus obras</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabase'
import type { MenuItem } from '../types/menu'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { faStar, faPalette, faCoffee, faExclamationTriangle } from '@fortawesome/free-solid-svg-icons'

// Add icons to the library
library.add(faStar, faPalette, faCoffee, faExclamationTriangle)

const menuItems = ref<MenuItem[]>([])
const loading = ref(true)
const error = ref<string | null>(null)

const defaultImage = 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=400'

const fetchMenuItems = async () => {
  try {
    loading.value = true
    error.value = null
    
    const { data, error: fetchError } = await supabase
      .from('menu_items')
      .select('*')
      .order('created_at', { ascending: true })
    
    if (fetchError) {
      throw fetchError
    }
    
    menuItems.value = data || []
  } catch (err) {
    console.error('Error fetching menu items:', err)
    error.value = 'No pudimos cargar el menú en este momento. Por favor, intenta de nuevo.'
  } finally {
    loading.value = false
  }
}

const handleImageError = (event: Event) => {
  const target = event.target as HTMLImageElement
  target.src = defaultImage
}

onMounted(() => {
  fetchMenuItems()
})
</script>

<style scoped>
.menu-section {
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  position: relative;
  overflow: hidden;
}

.menu-section::before {
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
  margin-bottom: 4rem;
  position: relative;
  z-index: 1;
}

.section-header h2 {
  font-size: 3.5rem;
  color: #1e3a8a;
  margin-bottom: 1rem;
  font-family: 'Playfair Display', serif;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
}

.section-header p {
  font-size: 1.3rem;
  color: #64748b;
  font-style: italic;
  max-width: 600px;
  margin: 0 auto;
}

.menu-content {
  position: relative;
  z-index: 1;
}

.loading-state,
.error-state,
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  color: #64748b;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 4px solid #e2e8f0;
  border-top: 4px solid #fbbf24;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error-icon,
.empty-icon {
  font-size: 3rem;
  color: #fbbf24;
  margin-bottom: 1rem;
}

.menu-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.menu-item {
  background: white;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  position: relative;
}

.menu-item:hover {
  transform: translateY(-10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.item-image {
  position: relative;
  height: 250px;
  overflow: hidden;
}

.item-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.menu-item:hover .item-image img {
  transform: scale(1.1);
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, rgba(30, 58, 138, 0.8), rgba(251, 191, 36, 0.8));
  opacity: 0;
  transition: opacity 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.menu-item:hover .image-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
  color: white;
}

.star-icon {
  font-size: 2rem;
  animation: pulse 2s infinite;
}

.item-details {
  padding: 2rem;
}

.item-name {
  font-size: 1.5rem;
  color: #1e3a8a;
  margin-bottom: 0.75rem;
  font-family: 'Playfair Display', serif;
  font-weight: 600;
}

.item-description {
  color: #64748b;
  line-height: 1.6;
  margin-bottom: 1.5rem;
  font-size: 0.95rem;
}

.item-price {
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
}

.price-amount {
  font-size: 2rem;
  font-weight: 700;
  color: #fbbf24;
  font-family: 'Playfair Display', serif;
}

.price-currency {
  font-size: 1rem;
  color: #64748b;
  font-weight: 500;
}

.menu-footer {
  text-align: center;
  margin-top: 3rem;
}

.menu-note {
  background: white;
  border-radius: 20px;
  padding: 2rem;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  max-width: 600px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.palette-icon {
  font-size: 2rem;
  color: #fbbf24;
  flex-shrink: 0;
}

.menu-note p {
  color: #64748b;
  font-style: italic;
  line-height: 1.6;
  margin: 0;
}

@media (max-width: 768px) {
  .section-header h2 {
    font-size: 2.5rem;
  }
  
  .section-header p {
    font-size: 1.1rem;
  }
  
  .menu-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }
  
  .menu-item {
    margin: 0 1rem;
  }
  
  .item-image {
    height: 200px;
  }
  
  .item-details {
    padding: 1.5rem;
  }
  
  .item-name {
    font-size: 1.3rem;
  }
  
  .price-amount {
    font-size: 1.8rem;
  }
  
  .menu-note {
    flex-direction: column;
    text-align: center;
    margin: 0 1rem;
  }
}

@media (max-width: 480px) {
  .menu-grid {
    grid-template-columns: 1fr;
  }
  
  .menu-item {
    margin: 0 0.5rem;
  }
  
  .item-details {
    padding: 1rem;
  }
  
  .section-header h2 {
    font-size: 2rem;
  }
}
</style>