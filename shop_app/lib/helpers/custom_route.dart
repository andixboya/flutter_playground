import 'package:flutter/material.dart';

// 290) custom way of routing pages (with different effects than the built-in ones.)
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
          builder: builder,
          settings: settings,
        );

  // this method is overriden to build different routes.
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // settings.isInitialRoute for older versions
    if (settings.name == '/') {
      return child;
    }
    // this is enough to make it different (just the widget being returned)
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// 290) and a separate class is necessary to be inserted within the theme
//  so that each route can be given this custom route class
// it extends pageTransitionBuilder and you oveeride buildTransactions.
// but the logic is exactly the same for the page builder and for single route.
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // route.settings.isInitialRoute  for older versions
    if (route.settings.name == '/') {
      return child;
    }

// this is enough to make it different (just the widget being returned)
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
