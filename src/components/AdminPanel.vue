<template>
  <div class="admin-panel">
    <div class="admin-header">
      <div class="header-content">
        <h1>Panel de Administración</h1>
        <div class="header-actions">
          <button @click="showAddForm = true" class="btn-primary">
            <font-awesome-icon :icon="['fas', 'plus']" />
            Agregar Producto
          </button>
          <button @click="handleLogout" class="btn-secondary">
            <font-awesome-icon :icon="['fas', 'sign-out-alt']" />
            Cerrar Sesión
          </button>
        </div>
      </div>
    </div>

    <div class="admin-content">
      <!-- Formulario para agregar/editar producto -->
      <div v-if="showAddForm || editingItem" class="product-form-overlay" @click="closeForm">
        <div class="product-form" @click.stop>
          <div class="form-header">
            <h3>{{ editingItem ? 'Editar Producto' : 'Agregar Nuevo Producto' }}</h3>
            <button @click="closeForm" class="close-btn">
              <font-awesome-icon :icon="['fas', 'times']" />
            </button>
          </div>
          
          <form @submit.prevent="saveProduct" class="form-body">
            <div class="form-group">
              <label for="name">Nombre del Producto</label>
              <input
                id="name"
                v-model="formData.name"
                type="text"
                required
                class="form-input"
                placeholder="Ej: Café Van Gogh"
              />
            </div>
            
            <div class="form-group">
              <label for="description">Descripción</label>
              <textarea
                id="description"
                v-model="formData.description"
                required
                class="form-input"
                rows="3"
                placeholder="Describe el producto..."
              ></textarea>
            </div>
            
            <div class="form-group">
              <label for="price">Precio (CUP)</label>
              <input
                id="price"
                v-model="formData.price"
                type="number"
                step="0.01"
                min="0"
                required
                class="form-input"
                placeholder="0.00"
              />
            </div>
            
            <div class="form-group">
              <label for="image_url">URL de la Imagen</label>
              <input
                id="image_url"
                v-model="formData.image_url"
                type="url"
                class="form-input"
                placeholder="https://ejemplo.com/imagen.jpg"
              />
            </div>
            
            <div v-if="formError" class="error-message">
              {{ formError }}
            </div>
            
            <div class="form-actions">
              <button type="button" @click="closeForm" class="btn-secondary">
                Cancelar
              </button>
              <button type="submit" :disabled="saving" class="btn-primary">
                <span v-if="saving">
                  <font-awesome-icon :icon="['fas', 'spinner']" class="fa-spin" />
                  Guardando...
                </span>
                <span v-else>
                  {{ editingItem ? 'Actualizar' : 'Guardar' }}
                </span>
              </button>
            </div>
          </form>
        </div>
      </div>

      <!-- Lista de productos -->
      <div class="products-section">
        <div class="section-header">
          <h2>Productos del Menú</h2>
          <p>{{ menuItems.length }} productos en total</p>
        </div>
        
        <div v-if="loading" class="loading-state">
          <font-awesome-icon :icon="['fas', 'spinner']" class="fa-spin loading-icon" />
          <p>Cargando productos...</p>
        </div>
        
        <div v-else-if="menuItems.length === 0" class="empty-state">
          <font-awesome-icon :icon="['fas', 'coffee']" class="empty-icon" />
          <p>No hay productos en el menú</p>
          <button @click="showAddForm = true" class="btn-primary">
            Agregar el primer producto
          </button>
        </div>
        
        <div v-else class="products-grid">
          <div v-for="item in menuItems" :key="item.id" class="product-card">
            <div class="product-image">
              <img :src="item.image_url || defaultImage" :alt="item.name" @error="handleImageError" />
            </div>
            <div class="product-info">
              <h3>{{ item.name }}</h3>
              <p class="product-description">{{ item.description }}</p>
              <div class="product-price">${{ Number(item.price).toFixed(2) }} CUP</div>
            </div>
            <div class="product-actions">
              <button @click="editProduct(item)" class="action-btn edit-btn">
                <font-awesome-icon :icon="['fas', 'edit']" />
              </button>
              <button @click="deleteProduct(item)" class="action-btn delete-btn">
                <font-awesome-icon :icon="['fas', 'trash']" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, reactive } from 'vue'
import { supabase } from '../lib/supabase'
import type { MenuItem } from '../types/menu'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faPlus, faSignOutAlt, faTimes, faSpinner, faCoffee, faEdit, faTrash } from '@fortawesome/free-solid-svg-icons'

library.add(faPlus, faSignOutAlt, faTimes, faSpinner, faCoffee, faEdit, faTrash)

const emit = defineEmits(['logout'])

const menuItems = ref<MenuItem[]>([])
const loading = ref(true)
const showAddForm = ref(false)
const editingItem = ref<MenuItem | null>(null)
const saving = ref(false)
const formError = ref('')

const defaultImage = 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=400'

const formData = reactive({
  name: '',
  description: '',
  price: 0,
  image_url: ''
})

const resetForm = () => {
  formData.name = ''
  formData.description = ''
  formData.price = 0
  formData.image_url = ''
  formError.value = ''
}

const closeForm = () => {
  showAddForm.value = false
  editingItem.value = null
  resetForm()
}

const fetchMenuItems = async () => {
  try {
    loading.value = true
    const { data, error } = await supabase
      .from('menu_items')
      .select('*')
      .order('created_at', { ascending: true })
    
    if (error) throw error
    menuItems.value = data || []
  } catch (error) {
    console.error('Error fetching menu items:', error)
  } finally {
    loading.value = false
  }
}

const saveProduct = async () => {
  try {
    saving.value = true
    formError.value = ''
    
    const productData = {
      name: formData.name,
      description: formData.description,
      price: Number(formData.price),
      image_url: formData.image_url || null
    }
    
    if (editingItem.value) {
      // Actualizar producto existente
      const { error } = await supabase
        .from('menu_items')
        .update(productData)
        .eq('id', editingItem.value.id)
      
      if (error) throw error
    } else {
      // Crear nuevo producto
      const { error } = await supabase
        .from('menu_items')
        .insert([productData])
      
      if (error) throw error
    }
    
    await fetchMenuItems()
    closeForm()
  } catch (error: any) {
    formError.value = error.message || 'Error al guardar el producto'
  } finally {
    saving.value = false
  }
}

const editProduct = (item: MenuItem) => {
  editingItem.value = item
  formData.name = item.name
  formData.description = item.description
  formData.price = Number(item.price)
  formData.image_url = item.image_url || ''
}

const deleteProduct = async (item: MenuItem) => {
  if (!confirm(`¿Estás seguro de que quieres eliminar "${item.name}"?`)) {
    return
  }
  
  try {
    const { error } = await supabase
      .from('menu_items')
      .delete()
      .eq('id', item.id)
    
    if (error) throw error
    await fetchMenuItems()
  } catch (error) {
    console.error('Error deleting product:', error)
    alert('Error al eliminar el producto')
  }
}

const handleLogout = async () => {
  await supabase.auth.signOut()
  emit('logout')
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
.admin-panel {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
}

.admin-header {
  background: linear-gradient(135deg, #1e3a8a, #3b82f6);
  color: white;
  padding: 2rem 0;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-content h1 {
  font-family: 'Playfair Display', serif;
  font-size: 2.5rem;
  margin: 0;
  color: white;
}

.header-actions {
  display: flex;
  gap: 1rem;
}

.admin-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.product-form-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.8);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  backdrop-filter: blur(5px);
}

.product-form {
  background: white;
  border-radius: 20px;
  width: 90%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
}

.form-header {
  background: linear-gradient(135deg, #1e3a8a, #3b82f6);
  color: white;
  padding: 1.5rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-radius: 20px 20px 0 0;
}

.form-header h3 {
  margin: 0;
  font-family: 'Playfair Display', serif;
  color: white;
}

.close-btn {
  background: none;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
  padding: 0.5rem;
  border-radius: 50%;
  transition: background 0.3s ease;
}

.close-btn:hover {
  background: rgba(255, 255, 255, 0.2);
}

.form-body {
  padding: 2rem;
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 600;
  color: #1e3a8a;
}

.form-input {
  padding: 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 10px;
  font-size: 1rem;
  transition: border-color 0.3s ease;
  font-family: inherit;
}

.form-input:focus {
  outline: none;
  border-color: #fbbf24;
  box-shadow: 0 0 0 3px rgba(251, 191, 36, 0.1);
}

.form-actions {
  display: flex;
  gap: 1rem;
  justify-content: flex-end;
  margin-top: 1rem;
}

.error-message {
  background: #fee2e2;
  color: #dc2626;
  padding: 1rem;
  border-radius: 10px;
  font-size: 0.9rem;
}

.section-header {
  text-align: center;
  margin-bottom: 2rem;
}

.section-header h2 {
  font-size: 2.5rem;
  color: #1e3a8a;
  margin-bottom: 0.5rem;
  font-family: 'Playfair Display', serif;
}

.section-header p {
  color: #64748b;
  font-size: 1.1rem;
}

.loading-state,
.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  color: #64748b;
}

.loading-icon,
.empty-icon {
  font-size: 3rem;
  color: #fbbf24;
  margin-bottom: 1rem;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
}

.product-card {
  background: white;
  border-radius: 15px;
  overflow: hidden;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.product-card:hover {
  transform: translateY(-5px);
}

.product-image {
  height: 200px;
  overflow: hidden;
}

.product-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.product-info {
  padding: 1.5rem;
}

.product-info h3 {
  font-size: 1.3rem;
  color: #1e3a8a;
  margin-bottom: 0.5rem;
  font-family: 'Playfair Display', serif;
}

.product-description {
  color: #64748b;
  line-height: 1.6;
  margin-bottom: 1rem;
  font-size: 0.9rem;
}

.product-price {
  font-size: 1.5rem;
  font-weight: 700;
  color: #fbbf24;
  font-family: 'Playfair Display', serif;
}

.product-actions {
  padding: 1rem 1.5rem;
  background: #f8fafc;
  display: flex;
  gap: 0.5rem;
  justify-content: flex-end;
}

.action-btn {
  padding: 0.5rem;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.edit-btn {
  background: #3b82f6;
  color: white;
}

.edit-btn:hover {
  background: #2563eb;
}

.delete-btn {
  background: #ef4444;
  color: white;
}

.delete-btn:hover {
  background: #dc2626;
}

.fa-spin {
  animation: fa-spin 1s infinite linear;
}

@keyframes fa-spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 1rem;
    text-align: center;
  }
  
  .header-content h1 {
    font-size: 2rem;
  }
  
  .header-actions {
    flex-direction: column;
    width: 100%;
  }
  
  .products-grid {
    grid-template-columns: 1fr;
  }
  
  .form-actions {
    flex-direction: column;
  }
}
</style>