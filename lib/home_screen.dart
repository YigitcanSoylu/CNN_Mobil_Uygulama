import 'package:bitki_teshis/gecmis.dart';
import 'package:bitki_teshis/home_content.dart';
import 'package:bitki_teshis/profil.dart';
//import 'package:bitki_teshis/ayarlar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomeContent(), HistoryPage(), ProfilePage()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Pladidi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
          ).copyWith(color: const Color.fromARGB(255, 236, 235, 235)),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Geçmiş"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profil",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[700],
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        showSelectedLabels: true,
      ),
    );
  }
}
