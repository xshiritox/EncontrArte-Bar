export interface MenuItem {
  id: string
  name: string
  price: number
  description: string
  image_url: string
  created_at: string
}

export interface Profile {
  id: string
  role: 'admin' | 'user'
  created_at: string
  updated_at: string
}
