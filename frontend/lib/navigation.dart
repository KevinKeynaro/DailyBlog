import 'package:flutter/material.dart';
import 'homepage.dart';
import 'addarticle.dart';
import 'categories.dart';
import 'profile.dart';
import 'searchpage.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  // GlobalKey untuk memanggil HomepageState.getArticles() dari luar,
  // dipakai supaya list artikel refresh otomatis setelah tambah artikel baru.
  final GlobalKey<HomepageState> homepageKey = GlobalKey<HomepageState>();

  // TIDAK bisa const lagi karena AddArticlePage sekarang butuh callback
  late final List<Widget> pages = [
    Homepage(key: homepageKey),
    const SearchPage(),
    AddArticlePage(
      onArticleAdded: () {
        homepageKey.currentState?.getArticles();
        setState(() => currentIndex = 0);
      },
    ),
    const CategoriesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.add_circle), label: 'Add'),
          NavigationDestination(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
