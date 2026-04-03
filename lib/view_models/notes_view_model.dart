import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/app_config.dart';
import '../models/note_model.dart';
import '../strings/app_strings.dart';

/// ViewModel for managing notes state and operations
/// Handles business logic, state management, and Supabase integration
class NotesViewModel extends ChangeNotifier {
  late final SupabaseClient _supabase;
  
  // State variables
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';
  String? _errorMessage;
  
  // Category filters
  int _activeCategory = 0; // 0: All notes, 1: Favourites, 2: Pinned
  int _activeSubCategory = 0; // 0: ALL, 1: PERSONAL, 2: WORK, 3: URGENT, 4: PEACE

  // Constructor
  NotesViewModel({SupabaseClient? supabaseClient}) {
    if (supabaseClient != null) {
      _supabase = supabaseClient;
      return;
    }
    // Initialize Supabase with error handling
    try {
      _supabase = Supabase.instance.client;
    } catch (e) {
      debugPrint('Error initializing Supabase: $e');
      // Fallback to default initialization
      _supabase = Supabase.instance.client;
    }
  }

  // Getters
  List<Note> get notes => _notes;
  List<Note> get filteredNotes => _filteredNotes;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  String? get errorMessage => _errorMessage;
  int get activeCategory => _activeCategory;
  int get activeSubCategory => _activeSubCategory;

  /// Initialize the ViewModel and load notes
  Future<void> initialize() async {
    await loadNotes();
  }

  /// Load all notes from Supabase
  Future<void> loadNotes() async {
    _setLoading(true);
    _clearError();
    
    int retryCount = 0;
    const maxRetries = 3;
    
    while (retryCount < maxRetries) {
      try {
        // For now, use hardcoded user ID. Later, this will be auth.uid()
        const userId = AppConfig.hardcodedUserId;
        
        final response = await _supabase
            .from('notes')
            .select()
            .eq('user_id', userId)
            .order('updated_at', ascending: false);

        // Empty list is valid (e.g. user deleted all notes). Only retry on exceptions.
        _notes = response.map((data) => Note.fromSupabase(data)).toList();
        _applyFilters();
        break;
      } catch (e) {
        retryCount++;
        debugPrint('Attempt $retryCount: Error loading notes: $e');
        
        if (retryCount < maxRetries) {
          await Future<void>.delayed(Duration(seconds: 2 * retryCount));
          continue;
        } else {
          _setError('Network error: Failed to connect to Supabase after $maxRetries attempts. Please check your internet connection.');
          break;
        }
      }
    }
    
    _setLoading(false);
  }

  /// Create a new note in Supabase
  Future<void> createNote(Note note) async {
    _setLoading(true);
    _clearError();
    
    try {
      final noteData = note.toSupabase();
      noteData['user_id'] = AppConfig.hardcodedUserId;
      
      await _supabase.from('notes').insert(noteData);
      await loadNotes(); // Refresh the list
    } catch (e) {
      _setError('Failed to create note: ${e.toString()}');
      debugPrint('Error creating note: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing note in Supabase
  Future<void> updateNote(Note note) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _supabase
          .from('notes')
          .update(note.toSupabase())
          .eq('id', note.id)
          .eq('user_id', AppConfig.hardcodedUserId);
      
      await loadNotes(); // Refresh the list
    } catch (e) {
      _setError('Failed to update note: ${e.toString()}');
      debugPrint('Error updating note: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a note from Supabase
  Future<void> deleteNote(String noteId) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _supabase
          .from('notes')
          .delete()
          .eq('id', noteId)
          .eq('user_id', AppConfig.hardcodedUserId);
      
      await loadNotes(); // Refresh the list
    } catch (e) {
      _setError('Failed to delete note: ${e.toString()}');
      debugPrint('Error deleting note: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Toggle pin status of a note
  Future<void> togglePinStatus(String noteId) async {
    final note = _notes.firstWhere((n) => n.id == noteId);
    final updatedNote = note.copyWith(NotePatch(isPinned: !note.isPinned));
    await updateNote(updatedNote);
  }

  /// Toggle favourite status of a note
  Future<void> toggleFavouriteStatus(String noteId) async {
    final note = _notes.firstWhere((n) => n.id == noteId);
    final updatedNote = note.copyWith(NotePatch(isFavourite: !note.isFavourite));
    await updateNote(updatedNote);
  }

  /// Set search query and filter notes
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Set searching state
  void setIsSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  /// Filter notes by main category (All, Favourites, Pinned)
  void filterByCategory(int categoryIndex) {
    _activeCategory = categoryIndex;
    _applyFilters();
    notifyListeners();
  }

  /// Filter notes by sub-category (ALL, PERSONAL, WORK, URGENT, PEACE)
  void filterBySubCategory(int subCategoryIndex) {
    _activeSubCategory = subCategoryIndex;
    _applyFilters();
    notifyListeners();
  }

  /// Apply all filters to the notes list
  void _applyFilters() {
    List<Note> filtered = List.from(_notes);

    // Apply main category filter
    if (_activeCategory == 1) {
      filtered = filtered.where((note) => note.isFavourite).toList();
    } else if (_activeCategory == 2) {
      filtered = filtered.where((note) => note.isPinned).toList();
    }

    // Apply sub-category filter
    if (_activeSubCategory > 0) {
      final categories = [
        AppStrings.personal,
        AppStrings.work,
        AppStrings.urgent,
        AppStrings.peace
      ];
      final selectedCategory = categories[_activeSubCategory - 1];
      filtered = filtered.where((note) => note.category == selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((note) =>
        note.title.toLowerCase().contains(query) ||
        note.body.toLowerCase().contains(query)
      ).toList();
    }

    _filteredNotes = filtered;
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Refresh notes from Supabase
  Future<void> refresh() async {
    await loadNotes();
  }
}
