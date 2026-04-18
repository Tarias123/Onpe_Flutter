import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets/app_header.dart';
import 'pages/presidencial_page.dart';
import 'pages/actas_page.dart';
import 'pages/participacion_page.dart';

void main() {
  runApp(const OnpeApp());
}

class OnpeApp extends StatelessWidget {
  const OnpeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ONPE – Resultados Electorales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(primary: AppColors.navyDark),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [
    PresidencialPage(),
    ActasPage(),
    ParticipacionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppColors.gold,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.how_to_vote_outlined), label: 'Precidencial'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Actas'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Participacion'),
        ],
      ),
    );
  }
}
