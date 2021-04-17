import 'package:flutter/material.dart';
import 'package:meals_app/screen/bottom_tabs_screen.dart';
import 'package:meals_app/screen/category_meals_screen.dart';
import 'package:meals_app/screen/filters_screen.dart';
import 'package:meals_app/screen/meal_detail_screen.dart';
import 'package:meals_app/screen/tabs_screen.dart';
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

        //[imp/] 170-171) => in case no route is found it goes to this one !!
        // you can do some dynamic loading of pages and push it within a map and its better for really big apps i think!
        // onGenerateRoute: (settings) =>
        // const name=settings.name (you can check the route and do sth. form map with funcs of MaterialPageRoutes!)
        //     MaterialPageRoute(builder: (ctx) => CategoriesScreen()),

        // 170-171) => in case nothing is found,  what should be visualized! (as last resort, like not found!)
        // [imp/]  should return a MaterialPageRoute!
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => CategoriesScreen());
        },
        routes: {
          // default is pointing towards the screen.
          // 173-174) here we`ll replacethe categoriesScreen with the tabController!
          // choose between tabController or bottomTabScreen widget!
          '/': (ctx) => BottomTabScreen(), // 17
          // 162-164)  we`ll have a routeName, so its more readable.
          CategoryMealsScreen.routeName: (ctx) => CategoryMealsScreen(),
          // 170-171 we register mealDetailScreen here
          MealDetailScreen.routeName: (ctx) => MealDetailScreen(),
          // 174-175) filtersScreen is added
          FiltersScreen.routeName: (ctx) => FiltersScreen(),
        });
  }
}
