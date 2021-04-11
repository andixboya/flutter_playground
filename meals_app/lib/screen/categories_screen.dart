import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../widget/stateless/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 158) returns grid view (but you need to read some doc, to getbetter  acquainted. )
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deli meal'),
      ),
      // 160) here we extract data and map it , so it can be visualized.
      body: GridView(
        children: DUMMY_CATEGORIES
            .map((catData) => CategoryItem(catData.title, catData.color))
            .toList(),
        // 158) means you`ll have slider on your grids? And also gridDelegate is required.
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          // 158)  max width
          maxCrossAxisExtent: 200,
          // 158) how big the children will be
          childAspectRatio: 1.5,
          // 158) padding or margin i think?
          crossAxisSpacing: 20,
          // 160) TODO: thedifferences between his styling and mine are here!
          mainAxisExtent: 100,
        ),
      ),
    );
  }
}
