import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../view_models/notes_view_model.dart';
import '../widgets/delete_confirmation_dialog.dart';
import 'package:uuid/uuid.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';
import '../strings/app_strings.dart';

class EditNoteScreen extends StatefulWidget {
  final Note? note;
  const EditNoteScreen({super.key, this.note});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late String _category;
  late Color _categoryColor;
  bool _isPinned = false;
  bool _isFavourite = false;
  final List<Map<String, dynamic>> _categories = [
    {'name': AppStrings.work, 'color': AppColors.workColor},
    {'name': AppStrings.personal, 'color': AppColors.personalText},
    {'name': AppStrings.peace, 'color': AppColors.peaceText},
    {'name': AppStrings.urgent, 'color': AppColors.urgentText},
  ];
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    _titleController = TextEditingController(text: note?.title ?? '');
    _bodyController = TextEditingController(text: note?.body ?? '');
    _isPinned = note?.isPinned ?? false;
    _isFavourite = note?.isFavourite ?? false;
    if (note != null) {
      _selectedCategory = _categories.indexWhere((c) => c['name'] == note.category);
      if (_selectedCategory == -1) _selectedCategory = 0;
    }
    _category = _categories[_selectedCategory]['name'];
    _categoryColor = _categories[_selectedCategory]['color'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeleteConfirmationDialog(
        onDelete: _deleteNote,
        onCancel: () {},
      ),
    );
  }

  void _saveNote() {
    final provider = Provider.of<NotesViewModel>(context, listen: false);
    final now = DateTime.now();
    final String hexString = '#${_categoryColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
    if (widget.note == null) {
      final note = Note(
        id: const Uuid().v4(),
        title: _titleController.text.trim().isEmpty ? AppStrings.untitledMaster : _titleController.text.trim(),
        body: _bodyController.text.trim(),
        category: _category,
        colorHex: hexString,
        createdAt: now,
        updatedAt: now,
        isPinned: _isPinned,
        isFavourite: _isFavourite,
      );
      provider.createNote(note);
    } else {
      final note = widget.note!.copyWith(
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
        category: _category,
        colorHex: hexString,
        updatedAt: now,
        isPinned: _isPinned,
        isFavourite: _isFavourite,
      );
      provider.updateNote(note);
    }
    Navigator.pop(context);
  }

  void _deleteNote() {
    final provider = Provider.of<NotesViewModel>(context, listen: false);
    if (widget.note != null) {
      provider.deleteNote(widget.note!.id);
      Navigator.popUntil(context, ModalRoute.withName('/'));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.noteDeleted),
          action: SnackBarAction(
            label: AppStrings.undo,
            onPressed: () {
              provider.createNote(widget.note!);
            },
          ),
        ),
      );
    } else {
      // For unsaved new notes, just go back without saving
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppStrings.notes, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ElevatedButton(
              key: Key('save_note_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              ),
              onPressed: _saveNote,
              child: Text(AppStrings.save, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onSelected: (value) {
              if (value == 'pin') {
                setState(() {
                  _isPinned = !_isPinned;
                });
              } else if (value == 'favourite') {
                setState(() {
                  _isFavourite = !_isFavourite;
                });
              } else if (value == 'delete') {
                _showDeleteConfirmation();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pin',
                child: Row(
                  children: [
                    Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(_isPinned ? AppStrings.unpinNote : AppStrings.pinNote),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'favourite',
                child: Row(
                  children: [
                    Icon(_isFavourite ? Icons.star : Icons.star_border, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(_isFavourite ? AppStrings.unfavourite : AppStrings.markAsFavourite),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    const Text(AppStrings.deleteNote, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_categories.length, (idx) {
                  final bool selected = _selectedCategory == idx;
                  final Color catColor = _categories[idx]['color'] as Color;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(
                        _categories[idx]['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected ? catColor : Colors.grey.shade300,
                        ),
                      ),
                      selected: selected,
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: selected ? catColor : Colors.grey.shade300,
                      ),
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: selected ? catColor : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = idx;
                          _category = _categories[idx]['name'];
                          _categoryColor = _categories[idx]['color'];
                        });
                      },
                    ),
                  );
                }),
              ),
              ),
              const SizedBox(height: 16),
              Text(
                _formatDate(widget.note?.createdAt ?? DateTime.now()),
                style: const TextStyle(fontSize: 15, color: Colors.black54, letterSpacing: 1.1),
              ),
              const SizedBox(height: 24),
              TextField(
                key: Key('note_title_field'),
                controller: _titleController,
                style: AppTypography.h1.copyWith(fontStyle: FontStyle.italic, color: Color.fromRGBO(0, 0, 0, 0.7)),
                decoration: const InputDecoration(
                  hintText: AppStrings.title,
                  hintStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 32, color: Colors.black26, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  key: Key('note_body_field'),
                  controller: _bodyController,
                  style: AppTypography.body1.copyWith(color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: AppStrings.startWriting,
                    hintStyle: TextStyle(color: Colors.black26, fontStyle: FontStyle.italic, fontSize: 20),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildFormattingToolbar(),
    );
  }

  Widget _buildFormattingToolbar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.format_bold),
            onPressed: () {},
            tooltip: AppStrings.bold,
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            onPressed: () {},
            tooltip: AppStrings.italic,
          ),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            onPressed: () {},
            tooltip: AppStrings.bulletedList,
          ),
          IconButton(
            icon: const Icon(Icons.check_box),
            onPressed: () {},
            tooltip: AppStrings.checkbox,
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {},
            tooltip: AppStrings.attachImage,
          ),
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: () {},
            tooltip: AppStrings.insertLink,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Example: OCTOBER 24, 2023
    return '${AppStrings.months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
