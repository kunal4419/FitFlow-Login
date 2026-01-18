-- Migration Script for Existing Users
-- This script creates user_profiles entries for existing users who signed up before the trigger was added
-- Run this AFTER you have run the main database_schema.sql updates

-- Create profiles for existing users from their user_metadata
INSERT INTO public.user_profiles (id, name, email)
SELECT 
  id,
  COALESCE(raw_user_meta_data->>'name', 'User') as name,
  email
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.user_profiles)
ON CONFLICT (id) DO NOTHING;

-- Verify the migration
SELECT 
  u.email,
  u.raw_user_meta_data->>'name' as metadata_name,
  p.name as profile_name,
  p.created_at
FROM auth.users u
LEFT JOIN user_profiles p ON u.id = p.id
ORDER BY u.created_at DESC;
