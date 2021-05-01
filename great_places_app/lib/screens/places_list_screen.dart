import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        // initially starts with this and listens to it.
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            :
            // 302-303) in case they are found will not be loaded from db.
            // 299-300) here a listener is added, in case there is changes in any models, they will be rendered
            Consumer<GreatPlaces>(
                // 299-300) static element, which will not be rendered.
                child: Center(
                  child: const Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    // 299-300) and view of all of the images
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          // and here the image is consumed.
                          leading: CircleAvatar(
                            backgroundImage: FileImage(
                              greatPlaces.items[i].image,
                            ),
                          ),
                          title: Text(greatPlaces.items[i].title),
                          // 299-300) here each will be loaded on to details places
                          onTap: () {
                            // Go to detail page ...
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
