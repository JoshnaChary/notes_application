import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final List<String> _tabs = [AppStrings.all, AppStrings.personal, AppStrings.work, AppStrings.urgent, AppStrings.peace];
  
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
      drawer: Drawer(
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Material(
                    color: selected ? const Color(0xFFCCE0FF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        viewModel.filterByCategory(idx);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                        child: Row(
                          children: [
                            Icon(item.icon, color: selected ? const Color(0xFF003366) : Colors.grey, size: 28),
                            const SizedBox(width: 18),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                color: selected ? const Color(0xFF003366) : Colors.grey,
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
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: viewModel.isSearching
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
                onChanged: (value) {
                  viewModel.setSearchQuery(value);
                },
              )
            : Text(AppStrings.appName, style: AppTypography.h2),
        centerTitle: !viewModel.isSearching,
        actions: [
          IconButton(
            icon: Icon(viewModel.isSearching ? Icons.close : Icons.search),
            onPressed: () {
              final newSearching = !viewModel.isSearching;
              viewModel.setIsSearching(newSearching);
              if (!newSearching) {
                _searchController.clear();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab bar
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (idx) {
                    final selected = viewModel.activeSubCategory == idx;
                    return Padding(
                      padding: EdgeInsets.only(
                        left: idx == 0 ? AppSpacing.lg : AppSpacing.sm,
                        right: idx == _tabs.length - 1 ? AppSpacing.lg : AppSpacing.sm,
                      ),
                      child: InkWell(
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
                  }),
                ),
              ),
            ),
            if (viewModel.errorMessage != null)
              Container(
                margin: const EdgeInsets.all(AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.sm),
                color: Colors.red.shade100,
                child: Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredNotes.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.lg,
                            right: AppSpacing.md,
                            top: AppSpacing.sm,
                            bottom: 24,
                          ),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, idx) {
                            final note = filteredNotes[idx];
                            final bool isPinned = note.isPinned;
                            final bool isFavourite = note.isFavourite;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/edit',
                                    arguments: note,
                                  );
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
                                      // Main content area with flexible width
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Line 1: Category badge (only in ALL tab)
                                            if (viewModel.activeSubCategory == 0) ...[
                                              buildCategoryBadge(note.category),
                                              const SizedBox(height: 14),
                                            ],
                                            // Line 2: Title
                                            Text(
                                              note.title,
                                              style: AppTypography.h2,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 10),
                                            // Line 3: Description
                                            Text(
                                              note.body,
                                              style: AppTypography.body2.copyWith(color: AppColors.textTertiary),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Icons area with fixed width
                                      if (isFavourite || isPinned) ...[
                                        const SizedBox(width: 12),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isFavourite)
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 4),
                                                child: Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                  size: 22,
                                                ),
                                              ),
                                            if (isPinned)
                                              Icon(
                                                Icons.push_pin,
                                                color: AppColors.secondary,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
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
