# Supabase Setup for Your Notes App

## 🔧 **Current Situation:**
Your Supabase database is set up with proper authentication (`auth.uid()`), but the app currently uses a hardcoded user ID.

## 🚀 **Two Options to Connect:**

### **Option 1: Quick Fix (Recommended for Testing)**
Add this user to your Supabase database:

```sql
-- Create a test user that matches the hardcoded ID
-- Run this in your Supabase SQL Editor:

-- Insert a test user record (this creates the auth user reference)
INSERT INTO auth.users (
  id,
  email,
  phone,
  created_at,
  updated_at,
  aud,
  role,
  email_confirmed_at,
  phone_confirmed_at,
  last_sign_in_at,
  app_metadata,
  user_metadata,
  is_super_admin,
  banned_until,
  recovery_sent_at,
  invited_at,
  confirmation_token,
  reauthentication_token,
  password_change_token,
  email_change_token_new,
  email_change_token_current
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'test@notesapp.com',
  null,
  now(),
  now(),
  'authenticated',
  'authenticated',
  now(),
  null,
  now(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  false,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null
);

-- Or create a simple test note to verify connection
INSERT INTO notes (
  user_id,
  title,
  body,
  category,
  color_hex,
  is_pinned,
  is_favourite
) VALUES (
  '11111111-1111-1111-1111-111111111111',
  'Welcome to Notes App!',
  'This is your first note from Supabase. Edit me or create new notes!',
  'PERSONAL',
  '#1E8E3E',
  false,
  false
);
```

### **Option 2: Update Your Supabase Policy (Alternative)**
If you want to allow the hardcoded user ID temporarily:

```sql
-- Add this policy alongside your existing policies
CREATE POLICY "Test user can manage notes"
  ON notes FOR ALL
  TO authenticated
  USING (user_id = '11111111-1111-1111-1111-111111111111')
  WITH CHECK (user_id = '11111111-1111-1111-1111-111111111111');
```

## 📋 **Next Steps:**

1. **Choose Option 1 or 2** above and run the SQL in your Supabase project
2. **Provide your Supabase credentials:**
   - Project URL: `https://your-project-id.supabase.co`
   - Anon Key: `eyJ...` (from Project Settings → API)

3. **I'll update the AppConfig** with your credentials

## 🔍 **Testing the Connection:**
After setup, the app should:
- Load notes from your Supabase database
- Create new notes in the cloud
- Sync across devices
- Show real-time updates

## 🚨 **Important Notes:**
- The hardcoded user ID is temporary
- For production, you'll want proper authentication
- Your database schema is excellent and ready for real auth

**Which option would you prefer? Once you decide and provide your Supabase URL and Anon Key, I'll complete the setup!** 🔑
