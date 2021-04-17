import 'package:flutter/material.dart';
import 'package:meals_app/screen/tabs/favourites_screen_tab.dart';
import 'package:meals_app/widget/stateless/main_drawer.dart';

import 'categories_screen.dart';

class BottomTabScreen extends StatefulWidget {
  @override
  _BottomTabScreenState createState() => _BottomTabScreenState();
}

// 174) this is just for readability
class _DisplayTab {
  final String title;
  final Widget page;
  _DisplayTab(this.title, this.page);
}

class _BottomTabScreenState extends State<BottomTabScreen> {
  
  // 174) and here we can load our pages, its preferrable that they match the indexes of the icons, otherwise it would be a mess.
  final List<_DisplayTab> _pages = [
    _DisplayTab("Categories", CategoriesScreen()),
    _DisplayTab('Your Favourite', FavouritesScreenTab()),
  ];

// we can set here, the initial index
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 174) and again,the bottomTab Widget does is not a scaffold itself, instead its part of the scaffold structure!
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex].title),
      ),
      body: _pages[_selectedPageIndex].page,
      bottomNavigationBar: BottomNavigationBar(
        // 174) what action will be executed , once you click on some of the icons
        // its logical , that you switch the index at least.
        // you change the index, and then its handed/passed to the currentIndex, that is how they are shifted!
        onTap: _selectPage,
        // 174) below is some styling.
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,

        // 174) here you give the index, which is changed in setState, otherwise it will not change anything
        // that is why we need stateful widget!
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        // 174) here we input the icons, which will be clicked
        //  they are more customizable i think
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.category),
            title: const Text('Categories'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            title: Text('Favorites'),
          ),
        ],
      ),
    // 174-175) drawer is added to out tab_screen
      drawer: MainDrawer(),
    );
  }
}
