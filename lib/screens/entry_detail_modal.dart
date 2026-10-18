import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/scrapbook_theme.dart';
import '../widgets/washi_tape.dart';

/// Modal displaying the full scrapbook entry with paper styling and actions
class EntryDetailModal extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onToggleBookmark;
  final VoidCallback onDelete;

  const EntryDetailModal({
    super.key,
    required this.entry,
    required this.onToggleBookmark,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = entry.cardColor;
    final accentColor = entry.accentColor;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Paper Card Container
          Container(
            margin: const EdgeInsets.only(top: 14.0),
            padding: const EdgeInsets.all(24.0),
            constraints: const BoxConstraints(maxWidth: 480.0),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(
                color: accentColor.withOpacity(0.2),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E241E).withOpacity(0.12),
                  blurRadius: 28.0,
                  offset: const Offset(0, 10.0),
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                // Top row: Date Stamp, Mood Tag, Close
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: accentColor.withOpacity(0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        '${entry.formattedDate.toUpperCase()} • ${entry.formattedTime}',
                        style: ScrapbookTheme.poppins(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.7,
                          color: accentColor,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(entry.moodEmoji, style: const TextStyle(fontSize: 14.0)),
                        const SizedBox(width: 4.0),
                        Text(
                          entry.mood,
                          style: ScrapbookTheme.inter(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: ScrapbookTheme.inkSecondary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.close_rounded, size: 20.0),
                          color: ScrapbookTheme.inkSecondary,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18.0),

                // Title in Poppins
                Text(
                  entry.title,
                  style: ScrapbookTheme.poppins(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                    color: ScrapbookTheme.inkPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 14.0),

                // Content in Inter
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      entry.content,
                      style: ScrapbookTheme.inter(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w400,
                        color: ScrapbookTheme.inkPrimary.withOpacity(0.92),
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Bottom toolbar: Bookmark & Delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        onDelete();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete_outline_rounded, size: 16.0, color: Color(0xFFAC4B4B)),
                      label: Text(
                        'Remove',
                        style: ScrapbookTheme.inter(
                          fontSize: 12.0,
                          color: const Color(0xFFAC4B4B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onToggleBookmark,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ScrapbookTheme.inkPrimary,
                        side: BorderSide(color: accentColor.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      icon: Icon(
                        entry.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        size: 16.0,
                        color: entry.isBookmarked ? accentColor : ScrapbookTheme.inkPrimary,
                      ),
                      label: Text(
                        entry.isBookmarked ? 'Saved' : 'Save',
                        style: ScrapbookTheme.inter(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Pinned Washi Tape on top
          Positioned(
            top: 6.0,
            child: WashiTape(
              width: 64.0,
              height: 16.0,
              color: entry.tapeColor,
            ),
          ),
        ],
      ),
    );
  }
}
