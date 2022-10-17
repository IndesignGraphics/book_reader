import 'package:book_reader/screens/about_us.dart';
import 'package:book_reader/screens/feedback.dart';
import 'package:book_reader/screens/recent_page.dart';
import 'package:book_reader/screens/favourite_page.dart';
import 'package:book_reader/screens/home_page.dart';
import 'package:book_reader/screens/recommended_page.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
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
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: 'Home'),
          TabData(iconData: Icons.thumb_up, title: 'Recommended'),
          TabData(iconData: Icons.history, title: 'Recent'),
          TabData(iconData: Icons.star, title: 'Favourites'),
        ],
        onTabChangedListener: _selectPage,
      ),
    );
  }
}
