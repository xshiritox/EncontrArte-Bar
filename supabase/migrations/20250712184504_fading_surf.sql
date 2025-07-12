/*
  # Fix infinite recursion in profiles policies

  1. Problem
    - Current policies are causing infinite recursion when checking roles
    - The admin policy tries to read from profiles table to check if user is admin
    - This creates a circular dependency

  2. Solution
    - Drop existing problematic policies
    - Create simpler, non-recursive policies
    - Users can read their own profile
    - Users can update their own profile
    - Remove the recursive admin policy that was causing the issue

  3. Security
    - Maintain RLS protection
    - Ensure users can only access their own data
    - Admin functionality will be handled at application level
*/

-- Drop existing policies that cause recursion
DROP POLICY IF EXISTS "Admins can read all profiles" ON profiles;
DROP POLICY IF EXISTS "Users can read own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;

-- Create simple, non-recursive policies
CREATE POLICY "Users can read own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

-- Allow users to insert their own profile (for the trigger)
CREATE POLICY "Users can insert own profile"
  ON profiles
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);