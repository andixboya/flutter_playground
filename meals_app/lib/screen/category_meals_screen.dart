import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/widget/stateless/meal_item.dart';

class CategoryMealsScreen extends StatelessWidget {
  // 163) !!!!
  // this is with route , the below is with namedRoute!
  // this involves having direct link to the other widget, which has reference to this.
  // while the below way, you don`t have to pass any args.
  // On one hand you pass them through constructor, on the other , you pass them through namedRoutes and GET PARAMS FROM CONTEXT!
  //  [imp/164] BUT , with named routes you have information all gathered within the main App starting widget!
  // final String categoryId;
  // final String categoryTitle;

  // CategoryMealsScreen(this.categoryId, this.categoryTitle);
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
    
    // 167-169) => here we include the meals from our 'data'
    final categoryMeals = DUMMY_MEALS.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        // 167-169) and here we put them within the widget
        itemBuilder: (ctx, index) {
          return MealItem(
            title: categoryMeals[index].title,
            imageUrl: categoryMeals[index].imageUrl,
            duration: categoryMeals[index].duration,
            affordability: categoryMeals[index].affordability,
            complexity: categoryMeals[index].complexity,
          );
        },
        itemCount: categoryMeals.length,
      ),
    );
  }
}
