-- Fix for hardcoded user ID access
-- Run this in your Supabase SQL Editor to allow the hardcoded user

-- Add this policy to allow your specific user ID
-- Define the hardcoded user id once and reuse it across all policies/queries.
DROP TABLE IF EXISTS policy_params;
CREATE TEMP TABLE policy_params AS
SELECT '1911a7ca-4527-48c4-b5e1-8fdf0283aab5'::uuid AS target_user_id;

CREATE POLICY "Allow hardcoded user access" ON notes
FOR ALL USING (user_id = (SELECT target_user_id FROM policy_params));

-- Alternative: Update existing policies to include your user ID
-- If the above doesn't work, drop existing policies and recreate:

DROP POLICY IF EXISTS "Users can insert their own notes" ON notes;
DROP POLICY IF EXISTS "Users can read their own notes" ON notes;
DROP POLICY IF EXISTS "Users can update their own notes" ON notes;
DROP POLICY IF EXISTS "Users can delete their own notes" ON notes;

-- Create new policies that allow your hardcoded user ID
CREATE POLICY "Users can insert their own notes" ON notes
FOR INSERT TO authenticated
WITH CHECK (user_id = (SELECT target_user_id FROM policy_params));

CREATE POLICY "Users can read their own notes" ON notes
FOR SELECT TO authenticated
USING (user_id = (SELECT target_user_id FROM policy_params));

CREATE POLICY "Users can update their own notes" ON notes
FOR UPDATE TO authenticated
USING (user_id = (SELECT target_user_id FROM policy_params))
WITH CHECK (user_id = (SELECT target_user_id FROM policy_params));

CREATE POLICY "Users can delete their own notes" ON notes
FOR DELETE TO authenticated
USING (user_id = (SELECT target_user_id FROM policy_params));

-- Also add a test note to verify everything works
INSERT INTO notes (
  user_id,
  title,
  body,
  category,
  color_hex,
  is_pinned,
  is_favourite
) VALUES (
  (SELECT target_user_id FROM policy_params),
  'Test Note from App',
  'This note was created to test the Supabase connection!',
  'PERSONAL',
  '#1E8E3E',
  false,
  false
);
