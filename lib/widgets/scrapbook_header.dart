import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/scrapbook_theme.dart';

/// A minimalist top header for soulJournal (replaces standard AppBar).
/// Displays subtle date stamp, app title, and search/stats count.
class ScrapbookHeader extends StatelessWidget {
  final int totalCount;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onClearSearch;
  final String searchQuery;

  const ScrapbookHeader({
    super.key,
    required this.totalCount,
    this.onSearchChanged,
    this.onClearSearch,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateFormatted = DateFormat('EEEE, MMMM d').format(now);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtle Date Stamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormatted.toUpperCase(),
                style: ScrapbookTheme.poppins(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: ScrapbookTheme.inkMuted,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.5),
                decoration: BoxDecoration(
                  color: ScrapbookTheme.creamSubtle,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: ScrapbookTheme.inkBorder,
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '$totalCount entries',
                  style: ScrapbookTheme.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: ScrapbookTheme.inkSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),

          // Main App Title: "soulJournal"
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'soul',
                style: ScrapbookTheme.poppins(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                  color: ScrapbookTheme.inkPrimary,
                ),
              ),
              Text(
                'Journal',
                style: ScrapbookTheme.poppins(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  color: ScrapbookTheme.inkPrimary,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                width: 6.0,
                height: 6.0,
                margin: const EdgeInsets.only(bottom: 6.0),
                decoration: const BoxDecoration(
                  color: ScrapbookTheme.pastelPinkAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),

          // Tagline / Subtitle
          Text(
            'a quiet scrapbook for fragments & honest moments',
            style: ScrapbookTheme.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: ScrapbookTheme.inkSecondary,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 14.0),

          // Minimalist Search Bar
          Container(
            height: 42.0,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: BorderRadius.circular(14.0),
              border: Border.all(
                color: ScrapbookTheme.inkBorder,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E241E).withOpacity(0.03),
                  blurRadius: 8.0,
                  offset: const Offset(0, 2.0),
                ),
              ],
            ),
            child: TextField(
              onChanged: onSearchChanged,
              style: ScrapbookTheme.inter(
                fontSize: 13.0,
                color: ScrapbookTheme.inkPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search through memories...',
                hintStyle: ScrapbookTheme.inter(
                  fontSize: 13.0,
                  color: ScrapbookTheme.inkMuted,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 19.0,
                  color: ScrapbookTheme.inkMuted,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 16.0,
                          color: ScrapbookTheme.inkMuted,
                        ),
                        onPressed: onClearSearch,
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
