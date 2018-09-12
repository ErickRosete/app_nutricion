import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/recipes.dart';
import './pages/recipe.dart';
import './pages/auth.dart';
import './pages/recipes_admin.dart';
import './scoped-models/main.dart';
import './models/recipe.dart';

// void main() => runApp(MyApp());

// Not typed variables
// main() {
//   runApp(MyApp());
// }

// Typed variables
void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _model.autoAuthenticate();
    _model.userSubject.listen((dynamic isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        theme: ThemeData(
          primarySwatch: Colors.green,
          buttonColor: Colors.greenAccent,
//        fontFamily: 'Oswald',
//        brightness: Brightness.light,
//        accentColor: Colors.deepPurple,
//        buttonColor: Colors.purple[200]
        ),
//        home: AuthPage(),
        routes: {
          '/admin': (BuildContext context) =>
              _isAuthenticated ? RecipeAdminPage(_model) : AuthPage(),
          '/': (BuildContext context) =>
              _isAuthenticated ? RecipesPage(_model) : AuthPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute(
                builder: (BuildContext context) => AuthPage());
          }

          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'Recipe') {
            final String recipeId = pathElements[2];
            final Recipe recipe =
                _model.getRecipes.firstWhere((Recipe recipe) {
              return recipe.id == recipeId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  _isAuthenticated ? RecipePage(recipe) : AuthPage(),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  _isAuthenticated ? RecipesPage(_model) : AuthPage());
        },
      ),
    );
  }
}
