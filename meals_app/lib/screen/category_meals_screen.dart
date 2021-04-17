import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/model/meal.dart';
import 'package:meals_app/widget/stateless/meal_item.dart';

// 177-78) The widget is transformed into stateful, because we`ll take info back from the deleted details and
// its going to be removed . The args will be received from the Future when openning a screen.

class CategoryMealsScreen extends StatefulWidget {
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
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
//177-178) here we initialize the state from our dummy data (normally they would be loaded from some api.)

  String categoryTitle;
  List<Meal> displayedMeals;
  var _loadedInitData = false;

// 177-178) initState won`t do, because it is initialized before the loading of data or sth. like that
// instead didChangeDependencies will be used. Its like afterViewInit or afterLoadInit!
  @override
  void initState() {
    // ...
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      categoryTitle = routeArgs['title'];
      final categoryId = routeArgs['id'];
      
      // here we remove category , which is deleted.
      displayedMeals = DUMMY_MEALS.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
      _loadedInitData = true;
    }
    super.didChangeDependencies();
  }

  void _removeMeal(String mealId) {
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 164) *** THIS IS HOW YOU SHOULD BE DOING THINGS( the above way is not the correct one!)
    // here you tell it what object it should be (the map!)
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];

    // 167-169) => here we include the meals from our 'data'
    // 178-179) you need to remove this, because its final, and it takes it from the local var!
    // final displayedMeals = DUMMY_MEALS.where((meal) {
    //   return meal.categories.contains(categoryId);
    // }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        // 167-169) and here we put them within the widget
        itemBuilder: (ctx, index) {
          return MealItem(
            id: displayedMeals[index].id,
            title: displayedMeals[index].title,
            imageUrl: displayedMeals[index].imageUrl,
            duration: displayedMeals[index].duration,
            affordability: displayedMeals[index].affordability,
            complexity: displayedMeals[index].complexity,
            removeItem: _removeMeal,
            
          );
        },
        itemCount: displayedMeals.length,
      ),
    );
  }
}
