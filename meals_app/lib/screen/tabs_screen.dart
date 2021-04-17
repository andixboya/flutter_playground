import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/screen/tabs/favourites_screen_tab.dart';
import 'package:meals_app/widget/stateless/main_drawer.dart';

import 'categories_screen.dart';

class TabScreen extends StatefulWidget {

  @override
  _TabScreenState createState() => _TabScreenState();
}

// 173) it needs to be stateful!
class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(

      // 173) how many items will it have, this can be loaded dynamically with routing!
      length: 2,
      // 173) you can set initial index, which is nice or have some other logic too.
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          // 173) again you have app bar , but it contains the tabs, which will dispaly your tabViews
          title: Text('Meals'),
          bottom: TabBar(
            tabs: <Widget>[
              // 173) here you could put tabs or.. some other widgets (but its probably preferrable tabs)
              // unless you really want to customize it yourself.
              Tab(
                icon: Icon(
                  Icons.category,
                ),
                text: 'Categories',
              ),
              Tab(
                icon: Icon(
                  Icons.star,
                ),
                text: 'Favorites',
              ),
            ],
          ),
        ),
        // 173) tabview is kind of like the routing map within the main scaffold, only difference is that it points
        // towards your tabs above. The indexes must match (between the tabs and the tabViews!)
        body: TabBarView(
          children: <Widget>[
            CategoriesScreen(),
            FavouritesScreenTab(),
          ],
        ),
      
      ),
    );
  
  }
}