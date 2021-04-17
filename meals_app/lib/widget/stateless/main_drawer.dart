import 'package:flutter/material.dart';
import 'package:meals_app/screen/filters_screen.dart';

// 174-175) was added back then.
class MainDrawer extends StatelessWidget {
  // 174-175) here, the func is added from outside.
  Widget buildListTile(String title, IconData icon, Function tabHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      // 174-175) here we extract the re-routing func.
      onTap: tabHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            // 174-175) this is useful to remember!
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // 174-175) we add these from outside, forr better readability.
          //  this is towards home.
          buildListTile('Meals', Icons.restaurant, () {
            Navigator.of(context).pushNamed("/");
          }),
          // 174-175) here we add to filters screen.
          buildListTile('Filters', Icons.settings, () {
            Navigator.of(context).pushNamed(FiltersScreen.routeName);
          }),
        ],
      ),
    );
  }
}
