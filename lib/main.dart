import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/journal_home_screen.dart';
import 'theme/scrapbook_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set seamless status bar and navigation bar styling to match cream aesthetic
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ScrapbookTheme.creamBackground,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SoulJournalApp());
}

class SoulJournalApp extends StatelessWidget {
  const SoulJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'soulJournal',
      debugShowCheckedModeBanner: false,
      theme: ScrapbookTheme.lightTheme,
      home: const JournalHomeScreen(),
    );
  }
}
