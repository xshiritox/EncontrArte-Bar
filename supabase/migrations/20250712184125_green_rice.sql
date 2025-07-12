/*
  # Crear usuario administrador

  1. Función para crear perfil automáticamente
    - Trigger que crea un perfil cuando se registra un usuario
    - Asigna rol 'user' por defecto

  2. Función para actualizar timestamp
    - Actualiza automáticamente updated_at en profiles
*/

-- Función para actualizar updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Función para crear perfil automáticamente
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, role)
  VALUES (NEW.id, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'on_auth_user_created'
  ) THEN
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW EXECUTE FUNCTION handle_new_user();
  END IF;
END $$;

-- Insertar usuario admin de ejemplo (opcional)
-- NOTA: Este usuario debe ser creado manualmente en Supabase Auth
-- y luego actualizar su perfil a 'admin'

-- Para crear un admin, primero registra el usuario en tu aplicación
-- y luego ejecuta esta consulta con el ID real del usuario:
-- UPDATE profiles SET role = 'admin' WHERE id = 'USER_ID_AQUI';