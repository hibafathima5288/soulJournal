import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/scrapbook_theme.dart';

enum FilterCategory {
  all,
  mint,
  pink,
  lavender,
  bookmarks,
}

/// Minimalist horizontal filter capsules for pastel tones and favorites
class FilterCapsuleBar extends StatelessWidget {
  final FilterCategory selectedFilter;
  final ValueChanged<FilterCategory> onFilterSelected;

  const FilterCapsuleBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      (FilterCategory.all, 'All notes', null),
      (FilterCategory.mint, 'Soft Mint', ScrapbookTheme.pastelMint),
      (FilterCategory.pink, 'Pale Pink', ScrapbookTheme.pastelPink),
      (FilterCategory.lavender, 'Lavender', ScrapbookTheme.pastelLavender),
      (FilterCategory.bookmarks, 'Saved', null),
    ];

    return SizedBox(
      height: 38.0,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8.0),
        itemBuilder: (context, index) {
          final item = filters[index];
          final isSelected = selectedFilter == item.$1;
          final colorSwatch = item.$3;

          return GestureDetector(
            onTap: () => onFilterSelected(item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? ScrapbookTheme.inkPrimary
                    : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: isSelected
                      ? ScrapbookTheme.inkPrimary
                      : ScrapbookTheme.inkBorder,
                  width: 1.0,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: ScrapbookTheme.inkPrimary.withOpacity(0.18),
                      blurRadius: 8.0,
                      offset: const Offset(0, 3.0),
                    ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (colorSwatch != null) ...[
                    Container(
                      width: 9.0,
                      height: 9.0,
                      decoration: BoxDecoration(
                        color: colorSwatch,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white.withOpacity(0.6)
                              : ScrapbookTheme.inkBorder,
                          width: 0.8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6.0),
                  ],
                  if (item.$1 == FilterCategory.bookmarks) ...[
                    Icon(
                      Icons.bookmark_rounded,
                      size: 13.0,
                      color: isSelected ? Colors.white : ScrapbookTheme.inkSecondary,
                    ),
                    const SizedBox(width: 4.0),
                  ],
                  Text(
                    item.$2,
                    style: ScrapbookTheme.inter(
                      fontSize: 12.0,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : ScrapbookTheme.inkSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
