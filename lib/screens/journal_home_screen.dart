import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/scrapbook_theme.dart';
import '../widgets/film_grain_overlay.dart';
import '../widgets/filter_capsule_bar.dart';
import '../widgets/scrapbook_card.dart';
import '../widgets/scrapbook_header.dart';
import '../services/journal_storage_service.dart';
import 'create_entry_screen.dart';
import 'entry_detail_modal.dart';

/// The main screen of soulJournal.
/// Features a subtle off-white cream background with light film-grain texture,
/// no appbar, Poppins & Inter typography, a vertical grid of pastel cards
/// (soft mint, pale pink, lavender), persistent local storage, and a minimalist '+' FAB.
class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({super.key});

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  final JournalStorageService _storageService = JournalStorageService();
  FilterCategory _selectedFilter = FilterCategory.all;
  String _searchQuery = '';
  List<JournalEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedEntries();
  }

  Future<void> _loadSavedEntries() async {
    final loaded = await _storageService.loadEntries();
    if (mounted) {
      setState(() {
        _entries = loaded;
        _isLoading = false;
      });
    }
  }

  List<JournalEntry> get _filteredEntries {
    return _entries.where((entry) {
      // Filter by category / tone
      if (_selectedFilter == FilterCategory.mint && entry.tone != PastelTone.mint) {
        return false;
      }
      if (_selectedFilter == FilterCategory.pink && entry.tone != PastelTone.pink) {
        return false;
      }
      if (_selectedFilter == FilterCategory.lavender && entry.tone != PastelTone.lavender) {
        return false;
      }
      if (_selectedFilter == FilterCategory.bookmarks && !entry.isBookmarked) {
        return false;
      }

      // Filter by search query
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchTitle = entry.title.toLowerCase().contains(query);
        final matchContent = entry.content.toLowerCase().contains(query);
        final matchMood = entry.mood.toLowerCase().contains(query);
        return matchTitle || matchContent || matchMood;
      }

      return true;
    }).toList();
  }

  Future<void> _addNewEntry(JournalEntry newEntry) async {
    final updated = await _storageService.addEntry(newEntry, _entries);
    if (mounted) {
      setState(() {
        _entries = updated;
      });
    }
  }

  Future<void> _toggleBookmark(String id) async {
    final updated = await _storageService.toggleBookmark(id, _entries);
    if (mounted) {
      setState(() {
        _entries = updated;
      });
    }
  }

  Future<void> _deleteEntry(String id) async {
    final updated = await _storageService.deleteEntry(id, _entries);
    if (mounted) {
      setState(() {
        _entries = updated;
      });
    }
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CreateEntrySheet(onEntryCreated: _addNewEntry),
    );
  }

  void _openEntryDetail(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (ctx) => EntryDetailModal(
        entry: entry,
        onToggleBookmark: () => _toggleBookmark(entry.id),
        onDelete: () => _deleteEntry(entry.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEntries;
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive grid columns: 1 on very narrow, 2 on phones/tablets, 3+ on large desktop
    final crossAxisCount = screenWidth > 860 ? 3 : (screenWidth > 520 ? 2 : 2);

    return Scaffold(
      backgroundColor: ScrapbookTheme.creamBackground,
      // No AppBar - Custom clean header inside SafeArea
      body: GrainBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: ScrapbookHeader(
                  totalCount: _entries.length,
                  searchQuery: _searchQuery,
                  onSearchChanged: (val) => setState(() => _searchQuery = val),
                  onClearSearch: () => setState(() => _searchQuery = ''),
                ),
              ),

              // Filter capsule tabs (All, Soft Mint, Pale Pink, Lavender, Bookmarks)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: FilterCapsuleBar(
                    selectedFilter: _selectedFilter,
                    onFilterSelected: (category) =>
                        setState(() => _selectedFilter = category),
                  ),
                ),
              ),

              // Vertical Grid of Pastel Cards
              if (_isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(ScrapbookTheme.inkPrimary),
                      ),
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: ScrapbookTheme.creamSubtle,
                              shape: BoxShape.circle,
                              border: Border.all(color: ScrapbookTheme.inkBorder),
                            ),
                            child: const Icon(
                              Icons.edit_note_rounded,
                              size: 32.0,
                              color: ScrapbookTheme.inkMuted,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'No journal scraps found',
                            style: ScrapbookTheme.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: ScrapbookTheme.inkPrimary,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Tap the + button below to pin your first memory.',
                            textAlign: TextAlign.center,
                            style: ScrapbookTheme.inter(
                              fontSize: 12.5,
                              color: ScrapbookTheme.inkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 100.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 14.0,
                      crossAxisSpacing: 14.0,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = filtered[index];
                        return ScrapbookCard(
                          entry: entry,
                          onTap: () => _openEntryDetail(entry),
                          onToggleBookmark: () => _toggleBookmark(entry.id),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // Minimalist Floating Action Button at bottom right: just a simple '+' icon
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, right: 6.0),
        child: SizedBox(
          width: 52.0,
          height: 52.0,
          child: FloatingActionButton(
            onPressed: _openCreateSheet,
            elevation: 0,
            hoverElevation: 2.0,
            focusElevation: 0,
            highlightElevation: 0,
            backgroundColor: ScrapbookTheme.fabBackground,
            foregroundColor: ScrapbookTheme.fabForeground,
            shape: const CircleBorder(),
            tooltip: 'New Entry',
            child: const Icon(
              Icons.add_rounded,
              size: 26.0,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
