import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/journal_entry.dart';

/// Manages local persistent storage of journal entries across app restarts
/// using SharedPreferences and JSON serialization.
class JournalStorageService {
  static const String _storageKey = 'souljournal_entries_v1';

  /// Initial curated scrapbook notes to populate on first app launch
  static List<JournalEntry> get initialSampleEntries => [
        JournalEntry(
          id: '1',
          title: 'Rain on Cedar Shingles',
          content:
              'Spent thirty minutes watching droplets trace slow, deliberate rivers down the window pane. Brewing jasmine green tea while the wind whispered through the pines.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          tone: PastelTone.mint,
          mood: 'Peaceful',
          moodEmoji: '🌿',
          tiltAngle: -0.9,
          tapePosition: TapePosition.center,
          isBookmarked: true,
        ),
        JournalEntry(
          id: '2',
          title: 'Pressed Cherry Blossoms',
          content:
              'Found an old book from Kyoto with delicate pink petals tucked between pages 84 and 85. The scent of vanilla paper and fleeting springtime never really fades.',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
          tone: PastelTone.pink,
          mood: 'Dreamy',
          moodEmoji: '🌸',
          tiltAngle: 1.1,
          tapePosition: TapePosition.left,
          isBookmarked: false,
        ),
        JournalEntry(
          id: '3',
          title: 'Twilight & Dusty Vinyl',
          content:
              'Put on Debussy’s Clair de Lune at dusk. The sky turned that exquisite shade of smoky violet right before dusk surrendered to indigo.',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          tone: PastelTone.lavender,
          mood: 'Stillness',
          moodEmoji: '🕯️',
          tiltAngle: -1.2,
          tapePosition: TapePosition.center,
          isBookmarked: true,
        ),
        JournalEntry(
          id: '4',
          title: 'Morning Matcha & Silence',
          content:
              'The first ten minutes of the day belong entirely to silence. Whisking matcha foam until bright green jade bubbles rise. No notifications yet.',
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 7)),
          tone: PastelTone.mint,
          mood: 'Gratitude',
          moodEmoji: '🍵',
          tiltAngle: 0.8,
          tapePosition: TapePosition.right,
          isBookmarked: false,
        ),
        JournalEntry(
          id: '5',
          title: 'Postcard from Montmartre',
          content:
              '“To live is the rarest thing in the world. Most people exist, that is all.” Found a vintage hand-lettered postcard in a thrift tin today.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          tone: PastelTone.pink,
          mood: 'Wanderlust',
          moodEmoji: '💌',
          tiltAngle: -0.7,
          tapePosition: TapePosition.center,
          isBookmarked: true,
        ),
        JournalEntry(
          id: '6',
          title: 'Midnight Musings',
          content:
              'Ideas always seem softer and more honest at 1:00 AM. What would happen if we stopped rushing toward the next milestone and just occupied this breath?',
          createdAt: DateTime.now().subtract(const Duration(days: 2, hours: 5)),
          tone: PastelTone.lavender,
          mood: 'Reflection',
          moodEmoji: '🌙',
          tiltAngle: 1.0,
          tapePosition: TapePosition.left,
          isBookmarked: false,
        ),
      ];

  /// Loads entries from local storage. If first launch, seeds initial entries.
  Future<List<JournalEntry>> loadEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        // First run: save and return defaults
        final defaultList = initialSampleEntries;
        await saveEntries(defaultList);
        return defaultList;
      }

      final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
      return decodedList
          .map((item) => JournalEntry.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      // In case of parsing error, return defaults safely
      return initialSampleEntries;
    }
  }

  /// Persists the list of entries to local storage
  Future<bool> saveEntries(List<JournalEntry> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mapList = entries.map((e) => e.toMap()).toList();
      final jsonString = jsonEncode(mapList);
      return await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Adds a new entry to storage and returns updated list
  Future<List<JournalEntry>> addEntry(JournalEntry entry, List<JournalEntry> currentEntries) async {
    final updated = [entry, ...currentEntries];
    await saveEntries(updated);
    return updated;
  }

  /// Toggles bookmark state for an entry and saves
  Future<List<JournalEntry>> toggleBookmark(String id, List<JournalEntry> currentEntries) async {
    final updated = currentEntries.map((e) {
      if (e.id == id) {
        return e.copyWith(isBookmarked: !e.isBookmarked);
      }
      return e;
    }).toList();
    await saveEntries(updated);
    return updated;
  }

  /// Deletes an entry by ID and saves
  Future<List<JournalEntry>> deleteEntry(String id, List<JournalEntry> currentEntries) async {
    final updated = currentEntries.where((e) => e.id != id).toList();
    await saveEntries(updated);
    return updated;
  }
}
