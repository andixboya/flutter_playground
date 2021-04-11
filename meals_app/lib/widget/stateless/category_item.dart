import 'dart:ui';

import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Color color;

  CategoryItem(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    // 159) we create a single item, so its more clear
    // 159) container is used so we start to stylize our own components, instead of relying on built ins!

    return Container(
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
    );
  }
}
