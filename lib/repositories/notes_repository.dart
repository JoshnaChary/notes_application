import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note_model.dart';
import '../core/config/app_config.dart';

class NotesRepository {
  final SupabaseClient _client;

  NotesRepository({SupabaseClient? client}) 
      : _client = client ?? Supabase.instance.client;

  Future<Note> createNote(Note note) async {
    final noteData = note.toJson();
    // Inject the hardcoded user id
    noteData['user_id'] = AppConfig.hardcodedUserId;
    
    final response = await _client
        .from('notes')
        .insert(noteData)
        .select()
        .single();
        
    return Note.fromJson(response);
  }

  Future<List<Note>> getAllNotes() async {
    final response = await _client
        .from('notes')
        .select()
        .eq('user_id', AppConfig.hardcodedUserId)
        .order('created_at', ascending: false);
        
    return response.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> getPinnedNotes() async {
    final response = await _client
        .from('notes')
        .select()
        .eq('user_id', AppConfig.hardcodedUserId)
        .eq('is_pinned', true)
        .order('created_at', ascending: false);
        
    return response.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> getFavouriteNotes() async {
    final response = await _client
        .from('notes')
        .select()
        .eq('user_id', AppConfig.hardcodedUserId)
        .eq('is_favourite', true)
        .order('created_at', ascending: false);
        
    return response.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> getNotesByCategory(String category) async {
    final response = await _client
        .from('notes')
        .select()
        .eq('user_id', AppConfig.hardcodedUserId)
        .ilike('category', category)
        .order('created_at', ascending: false);
        
    return response.map((json) => Note.fromJson(json)).toList();
  }

  Future<List<Note>> searchNotes(String query) async {
    // Basic search on multiple columns using or syntax
    final response = await _client
        .from('notes')
        .select()
        .eq('user_id', AppConfig.hardcodedUserId)
        .or('title.ilike.%$query%,body.ilike.%$query%')
        .order('created_at', ascending: false);
        
    return response.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> updateNote(Note note) async {
    final response = await _client
        .from('notes')
        .update(note.toJson())
        .eq('id', note.id)
        .eq('user_id', AppConfig.hardcodedUserId)
        .select()
        .single();
        
    return Note.fromJson(response);
  }

  Future<Note> togglePin(String id, bool value) async {
    final response = await _client
        .from('notes')
        .update({'is_pinned': value})
        .eq('id', id)
        .eq('user_id', AppConfig.hardcodedUserId)
        .select()
        .single();
        
    return Note.fromJson(response);
  }

  Future<Note> toggleFavourite(String id, bool value) async {
    final response = await _client
        .from('notes')
        .update({'is_favourite': value})
        .eq('id', id)
        .eq('user_id', AppConfig.hardcodedUserId)
        .select()
        .single();
        
    return Note.fromJson(response);
  }

  Future<void> deleteNote(String id) async {
    await _client
        .from('notes')
        .delete()
        .eq('id', id)
        .eq('user_id', AppConfig.hardcodedUserId);
  }
}
