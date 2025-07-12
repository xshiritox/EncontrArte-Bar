<template>
    <nav class="navbar van-gogh-texture">
      <div class="container">
        <div class="nav-content">
            <div class="logo" @click="handleLogoClick">
                <h2>EncontrArte Bar</h2>
            </div>
          <ul class="nav-links">
            <li><a href="#inicio" class="nav-link">Inicio</a></li>
            <li><a href="#menu" class="nav-link">Menú</a></li>
            <li><a href="#contacto" class="nav-link">Contacto</a></li>
            <li><a href="#ubicacion" class="nav-link">Ubicación</a></li>
          </ul>
          <button class="menu-toggle" @click="toggleMobileMenu">
            <span></span>
            <span></span>
            <span></span>
          </button>
        </div>
      </div>
    
    <!-- Admin Login Modal -->
    <AdminLogin v-if="showAdminLogin" @close="showAdminLogin = false" @login-success="handleLoginSuccess" />
    
    <!-- Admin Panel -->
    <AdminPanel v-if="showAdminPanel" @logout="handleLogout" />
    </nav>
  </template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { supabase } from '../lib/supabase'
import AdminLogin from './AdminLogin.vue'
import AdminPanel from './AdminPanel.vue'

const showAdminLogin = ref(false)
const showAdminPanel = ref(false)
const isAdmin = ref(false)

const handleLogoClick = () => {
  if (showAdminPanel.value) {
    // Si ya está en el panel admin, no hacer nada o cerrar
    return
  }
  showAdminLogin.value = true
}

const handleLoginSuccess = async () => {
  showAdminLogin.value = false
  showAdminPanel.value = true
  isAdmin.value = true
}

const handleLogout = () => {
  showAdminPanel.value = false
  isAdmin.value = false
}

// Verificar si ya hay una sesión de admin activa
onMounted(async () => {
  const { data: { session } } = await supabase.auth.getSession()
  
  if (session) {
    const { data: profile } = await supabase
      .from('profiles')
      .select('role')
      .eq('id', session.user.id)
      .single()
    
    if (profile?.role === 'admin') {
      isAdmin.value = true
      // No mostrar automáticamente el panel, solo marcar como admin
    }
  }
})
const toggleMobileMenu = () => {
  // Add your mobile menu toggle logic here
}
</script>

<style scoped>
@keyframes swirl {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

@keyframes stars {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
  }
}

.navbar {
  position: fixed;
  top: 0;
  width: 100%;
  padding: 1rem 0;
  background: linear-gradient(135deg, #1a237e 0%, #0d47a1 100%);
  background-size: 400% 400%;
  animation: swirl 20s ease infinite;
  box-shadow: 0 2px 10px rgba(0,0,0,0.3);
  z-index: 1000;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  position: relative;
}

.nav-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  position: relative;
  z-index: 1;
}

.logo {
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: transform 0.3s ease;
}

.logo:hover {
  transform: scale(1.05);
}

.logo h2 {
  margin: 0;
  font-size: 2.5rem;
  font-family: 'Playfair Display', serif;
  color: #fbbf24;
  text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.3);
}

.nav-links {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  gap: 2.5rem;
}

.nav-link {
  color: #fff;
  text-decoration: none;
  font-size: 1rem;
  font-weight: 500;
  transition: all 0.3s ease;
  position: relative;
  padding: 0.5rem 0;
}

.nav-link::after {
  content: '';
  position: absolute;
  width: 0;
  height: 2px;
  bottom: 0;
  left: 0;
  background: linear-gradient(90deg, #e74c3c, #3498db);
  transition: width 0.3s ease;
}

.nav-link:hover {
  color: #ffd700;
}

.nav-link:hover::after {
  width: 100%;
}

.menu-toggle {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
}

.menu-toggle span {
  display: block;
  width: 25px;
  height: 3px;
  background-color: #fff;
  margin: 5px 0;
  transition: all 0.3s ease;
}

@media (max-width: 768px) {
  .menu-toggle {
    display: block;
  }

  .nav-links {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    width: 100%;
    background: rgba(44, 62, 80, 0.95);
    padding: 1rem;
    flex-direction: column;
    gap: 1rem;
    backdrop-filter: blur(10px);
  }

  .nav-links.active {
    display: flex;
  }

  .nav-link {
    padding: 1rem;
    width: 100%;
    text-align: center;
    border-radius: 8px;
    transition: background 0.3s ease;
  }

  .nav-link:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .menu-toggle span {
    background: #fff;
  }

  .menu-toggle.active span:nth-child(1) {
    transform: rotate(45deg) translate(5px, 6px);
  }

  .menu-toggle.active span:nth-child(2) {
    opacity: 0;
  }

  .menu-toggle.active span:nth-child(3) {
    transform: rotate(-45deg) translate(7px, -6px);
  }
}</style>
