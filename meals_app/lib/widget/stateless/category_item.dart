import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meals_app/screen/category_meals_screen.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final Color color;

  CategoryItem(this.id, this.title, this.color);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      // 162-164) from context we get the route`s name!
      // then the appModule(material) gets the info and reroutes it.
      CategoryMealsScreen.routeName,
      arguments: {
        'id': id,
        'title': title,
      },
    );
  }
  // 163)  the below way is also an option but you have no global chekc on how things are done
  // its more like a quick solution!!
  void selectCategoryWithScreenPush(BuildContext ctx){
    // 163) here we use context.push, while with the other way we use namedRoutes(not just pilnig them up on top)
    // 163) also they are pushed through the CONSTRUCTOR!
    Navigator.of(ctx).push(MaterialPageRoute(builder: (_){
      return CategoryMealsScreen(id, title);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // 162-164) => inkwell is like an event listener, and its attached to a widget!
    return InkWell(
        onTap: () => selectCategory(context),
        //162) this is interesting stuff, to have!
        splashColor: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(15),

        // 159) we create a single item, so its more clear
        // 159) container is used so we start to stylize our own components, instead of relying on built ins!
        child: Container(
          padding: const EdgeInsets.all(10),
          // used margin here... because i can`t copy his... styles?!
          margin: const EdgeInsets.all(5),
          child: Text(
            title,
            style: TextStyle(fontSize: 15),
          ),
          // 159) used for... borders i think or maybe colors as background?
          decoration: BoxDecoration(
            // 159) used for... borders i think
            gradient: LinearGradient(
              // 159) from what color to what color it will transition? (from topleft to right , the difference)
              // 159) experiment with the props, its interestnig!
              colors: [
                color.withOpacity(0.7),
                color,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // 159) this is actually for the EDGES! (if they are cut or ronud or etc.)
            borderRadius: BorderRadius.circular(15),
          ),
        ));
  }
}
