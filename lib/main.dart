import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Note: Firebase.initializeApp() would go here in a production app
  runApp(const ProviderScope(child: WealthOSApp()));
}

class WealthOSApp extends StatelessWidget {
  const WealthOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wealth OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        primaryColor: const Color(0xFFF0AF47),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFF0AF47),
          secondary: Color(0xFF1E2228),
          surface: Color(0xFF16191E),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
