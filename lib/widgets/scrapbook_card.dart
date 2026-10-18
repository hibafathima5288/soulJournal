import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/scrapbook_theme.dart';
import 'washi_tape.dart';

/// A minimalist digital scrapbook card with pastel paper tone,
/// subtle washi tape, organic tilt, and Poppins/Inter typography.
class ScrapbookCard extends StatefulWidget {
  final JournalEntry entry;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;

  const ScrapbookCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onToggleBookmark,
  });

  @override
  State<ScrapbookCard> createState() => _ScrapbookCardState();
}

class _ScrapbookCardState extends State<ScrapbookCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final cardColor = entry.cardColor;
    final accentColor = entry.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..rotateZ(entry.tiltAngle * (math.pi / 180.0))
            ..scale(_isHovered ? 1.02 : 1.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              // Main paper card container
              Container(
                margin: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                padding: const EdgeInsets.fromLTRB(16.0, 18.0, 16.0, 16.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(
                    color: accentColor.withOpacity(0.12),
                    width: 1.0,
                  ),
                  boxShadow: [
                    // Ambient paper shadow
                    BoxShadow(
                      color: const Color(0xFF382E24).withOpacity(_isHovered ? 0.09 : 0.05),
                      blurRadius: _isHovered ? 16.0 : 10.0,
                      offset: Offset(0, _isHovered ? 6.0 : 4.0),
                      spreadRadius: _isHovered ? 1.0 : 0.0,
                    ),
                    // Fine paper edge highlight
                    const BoxShadow(
                      color: Colors.white,
                      blurRadius: 1.0,
                      offset: Offset(-0.5, -0.5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top row: Date stamp & Mood Pill
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Date stamp
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: accentColor.withOpacity(0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            entry.formattedDate.toUpperCase(),
                            style: ScrapbookTheme.poppins(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: accentColor,
                            ),
                          ),
                        ),
                        // Mood Tag pill
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              entry.moodEmoji,
                              style: const TextStyle(fontSize: 12.0),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              entry.mood.toLowerCase(),
                              style: ScrapbookTheme.inter(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                                color: ScrapbookTheme.inkSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Title
                    Text(
                      entry.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: ScrapbookTheme.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: ScrapbookTheme.inkPrimary,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Snippet content in Inter font
                    Text(
                      entry.content,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: ScrapbookTheme.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: ScrapbookTheme.inkSecondary.withOpacity(0.9),
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 14.0),

                    // Bottom info: Time and Bookmark
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.formattedTime,
                          style: ScrapbookTheme.inter(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w400,
                            color: ScrapbookTheme.inkMuted,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onToggleBookmark,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: entry.isBookmarked
                                  ? accentColor.withOpacity(0.15)
                                  : Colors.transparent,
                            ),
                            child: Icon(
                              entry.isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_border_rounded,
                              size: 15.0,
                              color: entry.isBookmarked
                                  ? accentColor
                                  : ScrapbookTheme.inkMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Realistic Washi Tape pinned to top of card
              if (entry.tapePosition != TapePosition.none)
                Positioned(
                  top: 0,
                  left: entry.tapePosition == TapePosition.left
                      ? 22.0
                      : (entry.tapePosition == TapePosition.right ? null : null),
                  right: entry.tapePosition == TapePosition.right ? 22.0 : null,
                  child: WashiTape(
                    width: 52.0,
                    height: 15.0,
                    color: entry.tapeColor,
                    angle: entry.tapePosition == TapePosition.left
                        ? -0.05
                        : (entry.tapePosition == TapePosition.right ? 0.05 : 0.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
