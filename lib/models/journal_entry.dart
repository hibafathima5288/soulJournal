import 'package:flutter/material.dart';
import '../theme/scrapbook_theme.dart';

enum PastelTone {
  mint,
  pink,
  lavender,
  butter,
  sky,
  peach,
}

enum TapePosition {
  left,
  center,
  right,
  none,
}

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final PastelTone tone;
  final String mood;
  final String moodEmoji;
  final double tiltAngle; // in radians or small degrees
  final TapePosition tapePosition;
  final String? imageAsset;
  final bool isBookmarked;

  const JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.tone,
    required this.mood,
    this.moodEmoji = '✨',
    this.tiltAngle = 0.0,
    this.tapePosition = TapePosition.center,
    this.imageAsset,
    this.isBookmarked = false,
  });

  Color get cardColor {
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

  Color get accentColor {
    switch (tone) {
      case PastelTone.mint:
        return ScrapbookTheme.pastelMintAccent;
      case PastelTone.pink:
        return ScrapbookTheme.pastelPinkAccent;
      case PastelTone.lavender:
        return ScrapbookTheme.pastelLavenderAccent;
      case PastelTone.butter:
        return ScrapbookTheme.pastelButterAccent;
      case PastelTone.sky:
        return ScrapbookTheme.pastelSkyAccent;
      case PastelTone.peach:
        return ScrapbookTheme.pastelPeachAccent;
    }
  }

  Color get tapeColor {
    switch (tone) {
      case PastelTone.mint:
        return ScrapbookTheme.tapeMint;
      case PastelTone.pink:
        return ScrapbookTheme.tapePink;
      case PastelTone.lavender:
        return ScrapbookTheme.tapeLavender;
      default:
        return ScrapbookTheme.tapeIvory;
    }
  }

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[createdAt.month - 1]} ${createdAt.day}';
  }

  String get formattedTime {
    final hour = createdAt.hour > 12
        ? createdAt.hour - 12
        : (createdAt.hour == 0 ? 12 : createdAt.hour);
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final ampm = createdAt.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $ampm';
  }

  JournalEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    PastelTone? tone,
    String? mood,
    String? moodEmoji,
    double? tiltAngle,
    TapePosition? tapePosition,
    String? imageAsset,
    bool? isBookmarked,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      tone: tone ?? this.tone,
      mood: mood ?? this.mood,
      moodEmoji: moodEmoji ?? this.moodEmoji,
      tiltAngle: tiltAngle ?? this.tiltAngle,
      tapePosition: tapePosition ?? this.tapePosition,
      imageAsset: imageAsset ?? this.imageAsset,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'tone': tone.name,
      'mood': mood,
      'moodEmoji': moodEmoji,
      'tiltAngle': tiltAngle,
      'tapePosition': tapePosition.name,
      'imageAsset': imageAsset,
      'isBookmarked': isBookmarked,
    };
  }

  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] as String? ?? 'Untitled Note',
      content: map['content'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      tone: PastelTone.values.firstWhere(
        (t) => t.name == (map['tone'] as String?),
        orElse: () => PastelTone.mint,
      ),
      mood: map['mood'] as String? ?? 'Peaceful',
      moodEmoji: map['moodEmoji'] as String? ?? '🌿',
      tiltAngle: (map['tiltAngle'] as num?)?.toDouble() ?? 0.0,
      tapePosition: TapePosition.values.firstWhere(
        (p) => p.name == (map['tapePosition'] as String?),
        orElse: () => TapePosition.center,
      ),
      imageAsset: map['imageAsset'] as String?,
      isBookmarked: map['isBookmarked'] as bool? ?? false,
    );
  }
}
