import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  // 232-233) id is added for edit to be passed.
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  // 219-220) simple tile row which will be listed within the products of the managing section/screen.

  @override
  Widget build(BuildContext context) {
    // 253) here some possible bug, because in catch it re-sets context and it must be taken from outside to preserve the context?
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              // 232-233) link to edit screen.
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            // 232-233) link to edit screen.
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  // 252) deletion case from http.
                  // 253) its actually changed there!
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (err) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
