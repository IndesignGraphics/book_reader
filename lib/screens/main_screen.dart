import 'package:book_reader/screens/about_us.dart';
import 'package:book_reader/screens/feedback.dart';
import 'package:book_reader/screens/recent_page.dart';
import 'package:book_reader/screens/favourite_page.dart';
import 'package:book_reader/screens/home_page.dart';
import 'package:book_reader/screens/recommended_page.dart';
import 'package:flutter/material.dart';
import 'package:google_language_fonts/google_language_fonts.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {'page': const HomePage()},
      {'page': const RecommendedPage()},
      {'page': const RecentPage()},
      {'page': const FavouritePage()},
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ગોરધનદાસ જીવરાજભાઈ સોરઠિયા",
          style: GujaratiFonts.balooBhai(),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              switch (val) {
                case 'aboutUs':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutUs(),
                    ),
                  );
                  break;
                case 'feedback':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FeedBack(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuItem<String>>[
              const PopupMenuItem<String>(
                value: 'aboutUs',
                child: Text(
                  "About Us",
                ),
              ),
              const PopupMenuItem<String>(
                value: 'feedback',
                child: Text(
                  "FeedBack",
                ),
              ),
            ],
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: _selectedPageIndex == 0
                ? const Icon(Icons.home_filled)
                : const Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _selectedPageIndex == 1
                ? const Icon(Icons.thumb_up)
                : const Icon(Icons.thumb_up_alt_outlined),
            label: 'Recommended',
          ),
          BottomNavigationBarItem(
            icon: _selectedPageIndex == 2
                ? const Icon(Icons.history)
                : const Icon(Icons.history_outlined),
            label: 'Recent',
          ),
          BottomNavigationBarItem(
            icon: _selectedPageIndex == 3
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border_outlined),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
