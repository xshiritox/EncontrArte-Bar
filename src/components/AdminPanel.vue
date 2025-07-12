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
              <label for="image">Imagen del Producto</label>
              <input
                id="image"
                type="file"
                accept="image/*"
                class="form-input"
                @change="handleImageChange"
              />
              <div v-if="formData.image" class="preview-image">
                <img :src="previewImage" alt="Preview" />
                <button @click="clearImage" class="clear-image-btn">
                  <font-awesome-icon :icon="['fas', 'times']" />
                </button>
              </div>
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
              <img v-if="item.image_url" :src="item.image_url" :alt="item.name" @error="handleImageError" />
              <div v-else class="no-image-placeholder">
                <font-awesome-icon :icon="['fas', 'images']" class="no-image-icon" />
                <span>No hay imagen</span>
              </div>
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
import { faPlus, faSignOutAlt, faTimes, faSpinner, faCoffee, faEdit, faTrash, faImages } from '@fortawesome/free-solid-svg-icons'

library.add(faPlus, faSignOutAlt, faTimes, faSpinner, faCoffee, faEdit, faTrash, faImages)

const emit = defineEmits(['logout'])

const menuItems = ref<MenuItem[]>([])
const loading = ref(true)
const showAddForm = ref(false)
const editingItem = ref<MenuItem | null>(null)
const saving = ref(false)
const formError = ref('')

const defaultImage = 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=400'

interface FormData {
  name: string;
  description: string;
  price: number;
  image: File | null;
}

const formData = reactive<FormData>({
  name: '',
  description: '',
  price: 0,
  image: null
})

const previewImage = ref('')

const resetForm = () => {
  formData.name = ''
  formData.description = ''
  formData.price = 0
  formData.image = null
  previewImage.value = ''
  formError.value = ''
}

const handleImageChange = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (file) {
    formData.image = file
    const reader = new FileReader()
    reader.onload = (e) => {
      previewImage.value = e.target?.result as string
    }
    reader.readAsDataURL(file)
  }
}

const clearImage = () => {
  formData.image = null
  previewImage.value = ''
  const input = document.getElementById('image') as HTMLInputElement
  if (input) {
    input.value = ''
  }
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
    
    let imageUrl = null
    if (formData.image) {
      // Subir la imagen a Supabase Storage
      const file = formData.image
      const fileName = `${Date.now()}-${file.name}`
      
      const { error: storageError } = await supabase
        .storage
        .from('menu-images')
        .upload(fileName, file)
      
      if (storageError) throw storageError
      
      // Obtener la URL pública de la imagen
      const { data } = await supabase
        .storage
        .from('menu-images')
        .getPublicUrl(fileName)
      
      imageUrl = data.publicUrl
    }
    
    const productData = {
      name: formData.name,
      description: formData.description,
      price: Number(formData.price),
      image_url: imageUrl || null
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
  // No necesitamos setear image_url ya que usamos image en formData
}

const deleteProduct = async (item: MenuItem) => {
  if (!confirm(`¿Estás seguro de que quieres eliminar "${item.name}"?`)) {
    return;
  }

  try {
    console.log('Iniciando eliminación de producto:', item.id);
    
    // Si el producto tiene imagen
    if (item.image_url) {
      try {
        console.log('URL de la imagen:', item.image_url);
        
        // Extraer el nombre del archivo de la URL
        const urlParts = new URL(item.image_url);
        const fileName = urlParts.pathname.split('/').pop();
        console.log('Nombre del archivo:', fileName);
        
        if (fileName) {
          // Intentar eliminar la imagen
          const { error: storageError } = await supabase
            .storage
            .from('menu-images')
            .remove([fileName]);
          
          if (storageError) {
            console.error('Error al eliminar imagen:', storageError);
            throw new Error(`Error al eliminar imagen: ${storageError.message}`);
          }
          
          console.log('Imagen eliminada exitosamente');
        }
      } catch (imageError) {
        console.error('Error en bloque de imagen:', imageError);
        throw imageError;
      }
    }

    // Eliminar el producto
    const { error: deleteError } = await supabase
      .from('menu_items')
      .delete()
      .eq('id', item.id);
    
    if (deleteError) {
      console.error('Error al eliminar producto:', deleteError);
      throw new Error(`Error al eliminar producto: ${deleteError.message}`);
    }
    
    console.log('Producto eliminado exitosamente');
    await fetchMenuItems();
    alert('Producto eliminado exitosamente');
  } catch (error: any) {
    console.error('Error total:', error);
    alert(`Error: ${error.message}`);
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
  height: 100vh;
  background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
  overflow-y: auto;
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */
  padding: 0;
}

.admin-panel::-webkit-scrollbar {
  display: none;  /* Chrome, Safari and Opera */
}

.admin-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
  flex: 1;
}

.admin-header {
  background: linear-gradient(135deg, #1e3a8a, #3b82f6);
  color: white;
  padding: 1rem 0;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  position: sticky;
  top: 0;
  z-index: 10;
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
  display: flex;
  flex-direction: column;
  gap: 2rem;
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

.preview-image {
  position: relative;
  margin-top: 1rem;
}

.preview-image img {
  max-width: 100%;
  max-height: 200px;
  object-fit: contain;
  border-radius: 10px;
  background: white;
}

.clear-image-btn {
  position: absolute;
  top: -10px;
  right: -10px;
  background: white;
  border: none;
  border-radius: 50%;
  padding: 5px;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.clear-image-btn:hover {
  background: #f8fafc;
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
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
}

.no-image-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 1rem;
  color: #64748b;
  background: #f8fafc;
  width: 100%;
  height: 100%;
  border-radius: 15px;
  font-size: 1.1rem;
  padding: 2rem;
}

.no-image-placeholder .fa-image-slash {
  font-size: 4rem;
  color: #94a3b8;
}

.no-image-placeholder span {
  font-size: 1.2rem;
  font-weight: 500;
}

.no-image-icon {
  font-size: 3rem;
  color: #94a3b8;
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