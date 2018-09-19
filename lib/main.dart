import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/calendar/calendar.dart';
import './pages/calendar/calendar_day.dart';
import './pages/media/images.dart';
import './pages/media/videos.dart';
import './pages/shopping/shopping_list.dart';
import './pages/recipe/recipes.dart';
import './pages/recipe/recipe.dart';
import './pages/recipe/recipe_ingredients_list.dart';
import './pages/auth/auth.dart';
import './pages/recipe/recipes_admin.dart';
import './pages/ingredient/ingredients_admin.dart';
import './pages/ingredient/ingredients.dart';
import './pages/ingredient/ingredient.dart';
import './scoped-models/main.dart';
import './models/recipe.dart';
import './models/ingredient.dart';

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
        title: "Nutrición",
        theme: ThemeData(
          primarySwatch: Colors.green,
          buttonColor: Colors.greenAccent,
        ),
//        home: AuthPage(),
        routes: {
          '/': (BuildContext context) =>
              _isAuthenticated ? RecipesPage(_model) : AuthPage(),
          '/calendar': (BuildContext context) =>
              _isAuthenticated ? CalendarPage() : AuthPage(),
          '/calendarDay': (BuildContext context) =>
              _isAuthenticated ? CalendarDayPage() : AuthPage(),
          '/images': (BuildContext context) =>
              _isAuthenticated ? ImagesPage() : AuthPage(),
          '/videos': (BuildContext context) =>
              _isAuthenticated ? VideosPage() : AuthPage(),
          '/shoppingList': (BuildContext context) =>
              _isAuthenticated ? ShoppingListPage() : AuthPage(),
          '/ingredients': (BuildContext context) =>
              _isAuthenticated ? IngredientsPage(_model) : AuthPage(),
          '/recipesAdmin': (BuildContext context) =>
              _isAuthenticated ? RecipesAdminPage(_model) : AuthPage(),
          '/ingredientsAdmin': (BuildContext context) =>
              _isAuthenticated ? IngredientsAdminPage(_model) : AuthPage(),
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
            final Recipe recipe = _model.getRecipes.firstWhere((Recipe recipe) {
              return recipe.id == recipeId;
            });

            if (pathElements.length < 4) {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    _isAuthenticated ? RecipePage(recipe) : AuthPage(),
              );
            }

            if (pathElements[3] == "Ingredients") {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => _isAuthenticated
                    ? RecipeIngredientsListPage(recipe)
                    : AuthPage(),
              );
            }
          }

          if (pathElements[1] == 'Ingredient') {
            final String ingredientId = pathElements[2];
            final Ingredient ingredient =
                _model.getIngredients.firstWhere((Ingredient ingredient) {
              return ingredient.id == ingredientId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  _isAuthenticated ? IngredientPage(ingredient) : AuthPage(),
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
