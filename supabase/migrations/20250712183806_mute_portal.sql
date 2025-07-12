/*
  # Crear tabla de productos del menú

  1. Nueva tabla
    - `menu_items`
      - `id` (uuid, clave primaria)
      - `name` (text, nombre del producto)
      - `price` (numeric, precio del producto)
      - `description` (text, descripción del producto)
      - `image_url` (text, URL de la imagen)
      - `created_at` (timestamp, fecha de creación)
      - `updated_at` (timestamp, fecha de actualización)

  2. Seguridad
    - Habilitar RLS en la tabla `menu_items`
    - Agregar política para permitir a todos leer los productos
    - Agregar políticas para que solo admins puedan crear, actualizar y eliminar productos

  3. Datos de ejemplo
    - Insertar algunos productos de ejemplo para mostrar el menú
*/

-- Crear tabla menu_items
CREATE TABLE IF NOT EXISTS menu_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  price numeric NOT NULL,
  description text NOT NULL,
  image_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Habilitar RLS
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;

-- Política para permitir a todos ver los productos
CREATE POLICY "Permitir a todos ver los productos"
  ON menu_items
  FOR SELECT
  TO public
  USING (true);

-- Política para permitir a admins insertar productos
CREATE POLICY "Permitir a admins insertar productos"
  ON menu_items
  FOR INSERT
  TO public
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Política para permitir a admins actualizar productos
CREATE POLICY "Permitir a admins actualizar productos"
  ON menu_items
  FOR UPDATE
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Política para permitir a admins eliminar productos
CREATE POLICY "Permitir a admins eliminar productos"
  ON menu_items
  FOR DELETE
  TO public
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE profiles.id = auth.uid()
      AND profiles.role = 'admin'
    )
  );

-- Trigger para actualizar updated_at automáticamente
CREATE TRIGGER update_menu_items_updated_at
  BEFORE UPDATE ON menu_items
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insertar datos de ejemplo
INSERT INTO menu_items (name, price, description, image_url) VALUES
  (
    'Café Noche Estrellada',
    4.50,
    'Un espresso intenso con notas de chocolate y vainilla, inspirado en la famosa obra de Van Gogh',
    'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=400'
  ),
  (
    'Latte Los Girasoles',
    5.25,
    'Café con leche cremoso decorado con arte latte en forma de girasol, dulce y reconfortante',
    'https://images.pexels.com/photos/851555/pexels-photo-851555.jpeg?auto=compress&cs=tinysrgb&w=400'
  ),
  (
    'Cappuccino Campo de Trigo',
    4.75,
    'Cappuccino tradicional con espuma dorada como los campos de trigo bajo el sol',
    'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=400'
  ),
  (
    'Mocha Autorretrato',
    5.50,
    'Deliciosa mezcla de café, chocolate y crema, tan compleja como las emociones del artista',
    'https://images.pexels.com/photos/1695052/pexels-photo-1695052.jpeg?auto=compress&cs=tinysrgb&w=400'
  ),
  (
    'Frappé Cipreses',
    6.00,
    'Bebida fría refrescante con café, hielo y crema, alta y elegante como los cipreses',
    'https://images.pexels.com/photos/1251175/pexels-photo-1251175.jpeg?auto=compress&cs=tinysrgb&w=400'
  ),
  (
    'Té Terraza del Café',
    3.75,
    'Té aromático servido en nuestra terraza, perfecto para contemplar el arte y la vida',
    'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg?auto=compress&cs=tinysrgb&w=400'
  );