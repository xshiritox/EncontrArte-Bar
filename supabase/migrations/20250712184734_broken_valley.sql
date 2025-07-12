/*
  # Configurar todos los usuarios como administradores

  1. Cambios en la tabla profiles
    - Cambiar el valor por defecto del rol a 'admin'
    - Actualizar todos los usuarios existentes a admin
  
  2. Función actualizada
    - El trigger ahora crea perfiles con rol 'admin' por defecto
*/

-- Actualizar todos los usuarios existentes para que sean admin
UPDATE profiles SET role = 'admin' WHERE role = 'user';

-- Cambiar el valor por defecto de la columna role a 'admin'
ALTER TABLE profiles ALTER COLUMN role SET DEFAULT 'admin';

-- Actualizar la función para crear perfiles con rol admin por defecto
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, role)
  VALUES (new.id, 'admin');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;