import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import '../theme/scrapbook_theme.dart';
import '../widgets/washi_tape.dart';

/// Modal bottom sheet or screen for creating a new scrapbook memory
class CreateEntrySheet extends StatefulWidget {
  final Function(JournalEntry) onEntryCreated;

  const CreateEntrySheet({
    super.key,
    required this.onEntryCreated,
  });

  @override
  State<CreateEntrySheet> createState() => _CreateEntrySheetState();
}

class _CreateEntrySheetState extends State<CreateEntrySheet> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  PastelTone _selectedTone = PastelTone.mint;
  TapePosition _selectedTape = TapePosition.center;
  String _selectedMood = 'Peaceful';
  String _selectedMoodEmoji = '🌿';

  final List<(String, String)> _moodOptions = [
    ('Peaceful', '🌿'),
    ('Dreamy', '🌸'),
    ('Gratitude', '✨'),
    ('Stillness', '☁️'),
    ('Coffee & Rain', '☕'),
    ('Warmth', '☀️'),
    ('Reflection', '🕯️'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Write something in your scrapbook note first.',
            style: ScrapbookTheme.inter(color: Colors.white, fontSize: 13),
          ),
          backgroundColor: ScrapbookTheme.inkPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Small random tilt between -1.2 and +1.2 degrees for scrapbook aesthetic
    final random = math.Random();
    final tilt = (random.nextDouble() * 2.4) - 1.2;

    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Untitled Thought' : title,
      content: content.isEmpty ? 'A quiet moment captured...' : content,
      createdAt: DateTime.now(),
      tone: _selectedTone,
      mood: _selectedMood,
      moodEmoji: _selectedMoodEmoji,
      tiltAngle: tilt,
      tapePosition: _selectedTape,
    );

    widget.onEntryCreated(newEntry);
    Navigator.of(context).pop();
  }

  Color _getColorForTone(PastelTone tone) {
    switch (tone) {
      case PastelTone.mint:
        return ScrapbookTheme.pastelMint;
      case PastelTone.pink:
        return ScrapbookTheme.pastelPink;
      case PastelTone.lavender:
        return ScrapbookTheme.pastelLavender;
      case PastelTone.butter:
        return ScrapbookTheme.pastelButter;
      case PastelTone.sky:
        return ScrapbookTheme.pastelSky;
      case PastelTone.peach:
        return ScrapbookTheme.pastelPeach;
    }
  }

  String _getToneName(PastelTone tone) {
    switch (tone) {
      case PastelTone.mint:
        return 'Soft Mint';
      case PastelTone.pink:
        return 'Pale Pink';
      case PastelTone.lavender:
        return 'Lavender';
      case PastelTone.butter:
        return 'Buttercream';
      case PastelTone.sky:
        return 'Sky Mist';
      case PastelTone.peach:
        return 'Soft Peach';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardBgColor = _getColorForTone(_selectedTone);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      decoration: const BoxDecoration(
        color: ScrapbookTheme.creamBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: ScrapbookTheme.inkMuted.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pin New Memory',
                      style: ScrapbookTheme.poppins(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        color: ScrapbookTheme.inkPrimary,
                      ),
                    ),
                    Text(
                      'Choose your pastel tone and pen your thought',
                      style: ScrapbookTheme.inter(
                        fontSize: 12.0,
                        color: ScrapbookTheme.inkSecondary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: ScrapbookTheme.creamSubtle,
                      shape: BoxShape.circle,
                      border: Border.all(color: ScrapbookTheme.inkBorder),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18.0,
                      color: ScrapbookTheme.inkSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Pastel Tone Selector (Mint, Pink, Lavender, etc.)
            Text(
              'PASTEL CARD COLOUR',
              style: ScrapbookTheme.poppins(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: ScrapbookTheme.inkMuted,
              ),
            ),
            const SizedBox(height: 10.0),
            SizedBox(
              height: 48.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: PastelTone.values.map((tone) {
                  final isSelected = _selectedTone == tone;
                  final color = _getColorForTone(tone);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTone = tone),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 12.0),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(
                          color: isSelected ? ScrapbookTheme.inkPrimary : ScrapbookTheme.inkBorder,
                          width: isSelected ? 1.8 : 1.0,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: ScrapbookTheme.inkPrimary.withOpacity(0.12),
                              blurRadius: 6.0,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              color: isSelected ? ScrapbookTheme.inkPrimary : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(color: ScrapbookTheme.inkPrimary, width: 1.2),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            _getToneName(tone),
                            style: ScrapbookTheme.inter(
                              fontSize: 12.0,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: ScrapbookTheme.inkPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),

            // Card Preview & Form
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(color: ScrapbookTheme.inkBorder),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2A2219).withOpacity(0.04),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4.0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Tape preview
                  if (_selectedTape != TapePosition.none)
                    Center(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: const WashiTape(
                          width: 50.0,
                          height: 13.0,
                          color: Color(0x66FFFFFF),
                        ),
                      ),
                    ),

                  // Title input
                  TextField(
                    controller: _titleController,
                    style: ScrapbookTheme.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: ScrapbookTheme.inkPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Entry Title / Moment...',
                      hintStyle: ScrapbookTheme.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: ScrapbookTheme.inkMuted,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const Divider(height: 20.0, thickness: 0.7, color: Color(0x18000000)),

                  // Body input
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    style: ScrapbookTheme.inter(
                      fontSize: 13.5,
                      height: 1.5,
                      color: ScrapbookTheme.inkPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write down a memory, poetry snippet, gratitude, or quiet observation...',
                      hintStyle: ScrapbookTheme.inter(
                        fontSize: 13.0,
                        color: ScrapbookTheme.inkMuted,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18.0),

            // Mood Tags
            Text(
              'MOOD & VIBE',
              style: ScrapbookTheme.poppins(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: ScrapbookTheme.inkMuted,
              ),
            ),
            const SizedBox(height: 10.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _moodOptions.map((item) {
                final isSelected = _selectedMood == item.$1;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = item.$1;
                      _selectedMoodEmoji = item.$2;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ScrapbookTheme.inkPrimary
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: isSelected
                            ? ScrapbookTheme.inkPrimary
                            : ScrapbookTheme.inkBorder,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.$2, style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 5.0),
                        Text(
                          item.$1,
                          style: ScrapbookTheme.inter(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? Colors.white : ScrapbookTheme.inkSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24.0),

            // Pin to Scrapbook action button
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _saveEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ScrapbookTheme.inkPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.push_pin_rounded, size: 17.0),
                    const SizedBox(width: 8.0),
                    Text(
                      'Pin to soulJournal',
                      style: ScrapbookTheme.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
