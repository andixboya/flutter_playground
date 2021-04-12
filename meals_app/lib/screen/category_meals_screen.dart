import 'package:flutter/material.dart';

class CategoryMealsScreen extends StatelessWidget {
  // 163) !!!!
  // this is with route , the below is with namedRoute!
  // this involves having direct link to the other widget, which has reference to this.
  // while the below way, you don`t have to pass any args.
  // On one hand you pass them through constructor, on the other , you pass them through namedRoutes and GET PARAMS FROM CONTEXT!
  //  [imp/164] BUT , with named routes you have information all gathered within the main App starting widget!
  final String categoryId;
  final String categoryTitle;

  CategoryMealsScreen(this.categoryId, this.categoryTitle);
  //  this is the alternative way to pass args!

  static const routeName = '/category-meals';
  @override
  Widget build(BuildContext context) {
    // 164) *** THIS IS HOW YOU SHOULD BE DOING THINGS( the above way is not the correct one!)
    // here you tell it what object it should be (the map!)
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
        child: Text(
          'The Recipes For The Category!',
        ),
      ),
    );
  }
}
