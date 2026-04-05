import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../view_models/notes_view_model.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';
import '../strings/app_strings.dart';

// Sidebar item helper
class _SidebarItem {
  final String label;
  final IconData icon;
  const _SidebarItem(this.label, this.icon);
}

/// Maps tab label to Maestro/test key id (extracted from build for Sonar S3776).
String _chipKeyForTab(String tab) {
  switch (tab) {
    case AppStrings.all:
      return 'chip_all';
    case AppStrings.work:
      return 'chip_work';
    case AppStrings.urgent:
      return 'chip_urgent';
    case AppStrings.personal:
      return 'chip_personal';
    case AppStrings.peace:
      return 'chip_peace';
    default:
      return 'chip_${tab.toLowerCase()}';
  }
}

Key? _semanticKeyForNoteTitle(String title) {
  if (title.contains('Favourite')) return const Key('favourite_test_note');
  if (title.contains('Pinned')) return const Key('pinned_test_note');
  return null;
}

// Helper for category badge
Widget buildCategoryBadge(String category) {
  final cat = category.toUpperCase();
  Color bg;
  switch (cat) {
    case AppStrings.urgent:
      bg = AppColors.urgentBg;
      break;
    case AppStrings.personal:
      bg = AppColors.personalBg;
      break;
    case AppStrings.work:
      bg = AppColors.workBg;
      break;
    case AppStrings.peace:
      bg = AppColors.peaceBg;
      break;
    default:
      bg = AppColors.personalBg;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      cat,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        letterSpacing: 1.1,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Sidebar and tab state mapping
  final List<_SidebarItem> _sidebarItems = [
    const _SidebarItem(AppStrings.allNotes, Icons.description),
    const _SidebarItem(AppStrings.favourites, Icons.star),
    const _SidebarItem(AppStrings.pinned, Icons.push_pin),
  ];
  final List<String> _tabs = [
    AppStrings.all,
    AppStrings.personal,
    AppStrings.work,
    AppStrings.urgent,
    AppStrings.peace,
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotesViewModel>();
    final filteredNotes = viewModel.filteredNotes;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF0F2F5),
      drawer: _buildDrawer(viewModel),
      appBar: _buildAppBar(viewModel),
      body: _buildBody(viewModel, filteredNotes),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildBody(NotesViewModel viewModel, List<Note> filteredNotes) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabBar(viewModel),
          if (viewModel.errorMessage != null)
            _buildErrorBanner(viewModel.errorMessage!),
          Expanded(child: _buildNotesBody(viewModel, filteredNotes)),
        ],
      ),
    );
  }

  Widget _buildDrawer(NotesViewModel viewModel) {
    return Drawer(
      backgroundColor: const Color(0xFFF0F2F5),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            ...List.generate(_sidebarItems.length, (idx) {
              final item = _sidebarItems[idx];
              final selected = viewModel.activeCategory == idx;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Material(
                  color: selected
                      ? const Color(0xFFCCE0FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      viewModel.filterByCategory(idx);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: selected
                                ? const Color(0xFF003366)
                                : Colors.grey,
                            size: 28,
                          ),
                          const SizedBox(width: 18),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected
                                  ? const Color(0xFF003366)
                                  : Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(NotesViewModel viewModel) {
    final title = _buildAppBarTitle(viewModel);
    final centerTitle = !viewModel.isSearching;

    return AppBar(
      backgroundColor: Colors.white,
      title: title,
      centerTitle: centerTitle,
      actions: [
        IconButton(
          key: const Key('search_button'),
          icon: Icon(viewModel.isSearching ? Icons.close : Icons.search),
          onPressed: () {
            final newSearching = !viewModel.isSearching;
            viewModel.setIsSearching(newSearching);
            if (!newSearching) {
              _searchController.clear();
              viewModel.setSearchQuery('');
            }
          },
        ),
      ],
    );
  }

  Widget _buildAppBarTitle(NotesViewModel viewModel) {
    return viewModel.isSearching
        ? TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: AppStrings.searchNotes,
              border: InputBorder.none,
              hintStyle: AppTypography.hint,
            ),
            style: AppTypography.body1.copyWith(
              color: AppColors.textPrimary,
              fontSize: 18,
            ),
            onChanged: viewModel.setSearchQuery,
          )
        : Text(AppStrings.appName, style: AppTypography.h2);
  }

  Widget _buildTabBar(NotesViewModel viewModel) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: List.generate(_tabs.length, (idx) {
          return _buildTabChip(viewModel, idx);
        }),
      ),
    );
  }

  Widget _buildTabChip(NotesViewModel viewModel, int idx) {
    final selected = viewModel.activeSubCategory == idx;
    final padding = _getTabPadding(idx);

    return Padding(
      padding: padding,
      child: InkWell(
        key: Key(_chipKeyForTab(_tabs[idx])),
        onTap: () => viewModel.filterBySubCategory(idx),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _tabs[idx],
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? AppColors.primary : Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 3,
                width: selected ? 28 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsets _getTabPadding(int idx) {
    return const EdgeInsets.symmetric(horizontal: AppSpacing.sm);
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: Colors.red.shade100,
      child: Text(message, style: TextStyle(color: Colors.red.shade900)),
    );
  }

  Widget _buildNotesBody(NotesViewModel viewModel, List<Note> filteredNotes) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filteredNotes.isEmpty) {
      return _buildEmptyState();
    }
    return ListView.builder(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: 24,
      ),
      itemCount: filteredNotes.length,
      itemBuilder: (context, idx) =>
          _buildNoteListItem(filteredNotes[idx], viewModel),
    );
  }

  Widget _buildNoteListItem(Note note, NotesViewModel viewModel) {
    final bool isPinned = note.isPinned;
    final bool isFavourite = note.isFavourite;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.pushNamed(context, '/edit', arguments: note);
        },
        child: Container(
          decoration: BoxDecoration(
            color: isPinned ? AppColors.placeholder : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (viewModel.activeSubCategory == 0) ...[
                      buildCategoryBadge(note.category),
                      const SizedBox(height: 14),
                    ],
                    Text(
                      key: _semanticKeyForNoteTitle(note.title),
                      note.title,
                      style: AppTypography.h2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      note.body,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isFavourite || isPinned) ...[
                const SizedBox(width: 12),
                _buildNoteActions(isFavourite, isPinned, note, viewModel),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteActions(
    bool isFavourite,
    bool isPinned,
    Note note,
    NotesViewModel viewModel,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFavourite)
          GestureDetector(
            key: const Key('favourite_button'),
            onTap: () {
              final provider = Provider.of<NotesViewModel>(
                context,
                listen: false,
              );
              provider.toggleFavouriteStatus(note.id);
            },
            child: const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.star, color: Colors.grey, size: 22),
            ),
          ),
        if (isPinned)
          GestureDetector(
            key: const Key('pin_button'),
            onTap: () {
              final provider = Provider.of<NotesViewModel>(
                context,
                listen: false,
              );
              provider.togglePinStatus(note.id);
            },
            child: const Icon(
              Icons.push_pin,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
      ],
    );
  }

  Widget _buildFab() {
    return Semantics(
      label: 'Create Note',
      hint: 'Create a new note',
      identifier: 'fab_create_note',
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.pushNamed(context, '/edit');
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.placeholder,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: AppColors.textHint,
                size: 36,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.noMoreEntries,
              style: AppTypography.h2.copyWith(
                color: AppColors.textTertiary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.noNotesYet,
              textAlign: TextAlign.center,
              style: AppTypography.body2.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
