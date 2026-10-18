# 🌿 soulJournal

A minimalist **Digital Scrapbook** journal app crafted in Flutter, evoking the warmth, tactile paper charm, and quiet reflection of a physical journal desk.

---

## ✨ Design & Aesthetic Highlights

- **Off-White Cream Palette**: Warm, soothing background (`#F9F6F0`) reminiscent of artisanal cotton parchment.
- **Film-Grain Texture**: Built-in deterministic micro-grain noise overlay (`GrainBackground`) that simulates genuine analog photo paper texture.
- **Pastel Card Collage**:
  - 🌿 **Soft Mint** (`#E2EFE7`)
  - 🌸 **Pale Pink** (`#F8E2E6`)
  - 💜 **Lavender** (`#EBE5F7`)
  - 🍯 *Buttercream & Sky accents*
- **Scrapbook Details**:
  - Semi-translucent torn-edge **Washi Tape** pinning cards.
  - Organic subtle card tilts (`-1.2°` to `+1.2°`) for a natural collage feel.
  - Tactile paper drop shadows with micro-sheen edge borders.
- **No AppBar**: Uncluttered, distraction-free top header with live date stamp, subtle entry counter, and memory search.
- **Typography**:
  - **Poppins**: Semi-bold, geometric headings and date badges.
  - **Inter**: Clean, legible, high-comfort typography for reflections and thoughts.
- **Minimalist Floating Action Button**:
  - Positioned at the bottom right.
  - Sleek ink-black circular pebble with a simple `+` icon (`Icons.add_rounded`).
  - Launches an interactive modal to pick pastel tones, mood stamps, and pen new journal scraps.

---

## 📁 Project Structure

```text
personal journal app/
├── lib/
│   ├── main.dart                      # App entry point & system UI theming
│   ├── models/
│   │   └── journal_entry.dart         # Journal data model, tones, mood tags & tilt
│   ├── theme/
│   │   └── scrapbook_theme.dart       # Cream palette, pastel shades & Inter/Poppins typography
│   ├── widgets/
│   │   ├── film_grain_overlay.dart    # Procedural film-grain paper texture
│   │   ├── scrapbook_card.dart        # Pastel scrapbook card with washi tape & tilt
│   │   ├── washi_tape.dart            # Torn-edge translucent washi tape painter
│   │   ├── scrapbook_header.dart      # Minimalist date & title header (no AppBar)
│   │   └── filter_capsule_bar.dart    # Pastel tone & bookmark filter capsules
│   └── screens/
│       ├── journal_home_screen.dart   # Main vertical grid & minimalist '+' FAB
│       ├── create_entry_screen.dart   # Compose new memory with pastel picker
│       └── entry_detail_modal.dart    # Full scrapbook card viewer & manager
├── web/
│   ├── index.html                     # Web configuration with preloaded fonts
│   └── manifest.json                  # Web manifest
├── pubspec.yaml                       # Dependencies & Flutter metadata
└── analysis_options.yaml              # Linting rules
```

---

## 🚀 Running the App

Once Flutter is installed in your system PATH:

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run on Chrome (Web)
flutter run -d chrome

# 3. Run on connected mobile device or emulator
flutter run
```
