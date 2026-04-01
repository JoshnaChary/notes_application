class AppConfig {
  static const String supabaseUrl = 'https://rfbvrhrmezxxstgdbqsa.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJmYnZyaHJtZXp4eHN0Z2RicXNhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzUwMjI3NTYsImV4cCI6MjA5MDU5ODc1Nn0.M0G1_u9d0Q9i-Ht7NkRryBqqiRoQvIcJ5xMkYQNxy08';
  
  // Your actual user ID from Supabase
  static const String hardcodedUserId = '1911a7ca-4527-48c4-b5e1-8fdf0283aab5';
  
  // Database table names
  static const String notesTable = 'notes';
  static const String categoriesTable = 'categories';
  static const String usersTable = 'users';
}
