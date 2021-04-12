import 'package:flutter/material.dart';
import 'package:meals_app/screen/category_meals_screen.dart';
import './screen/categories_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        // 161) adding some fonts as FILES in assets>fonts
        // 161) then referring them as some types in publicspecs.yaml
        // and then using them here.
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
          canvasColor: Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Raleway',
          textTheme: ThemeData.light().textTheme.copyWith(
              body1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              body2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              title: TextStyle(
                fontSize: 20,
                // 162) we are using them here with the key words from the spec files.
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.bold,
              )),
        ),

        // home: CategoriesScreen(),
        // 162-164) how to register the routes in the main starting screen.
        initialRoute: '/',
        routes: {
          // default is pointing towards the screen.
          '/': (ctx) => CategoriesScreen(),
          // 162-164)  we`ll have a routeName, so its more readable.
          CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
        });
  }
}
