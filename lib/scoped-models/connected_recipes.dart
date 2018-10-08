import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/date.dart';
import '../models/food.dart';

////////////////////////////////////////CONNECTED RECIPES MODEL////////////////////////////////////////////
class ConnectedRecipesModel extends Model {
  List<Recipe> _recipes = [];
  List<Ingredient> _ingredients = [];
  int _selectedRecipeId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<bool> addRecipe(
      String name, String directions, String image, double price) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> recipeData = {
      'Name': name,
      'Directions': directions,
      'Image':
          'http://as01.epimg.net/deporteyvida/imagenes/2018/05/07/portada/1525714597_852564_1525714718_noticia_normal.jpg',
    };

    try {
      final http.Response response = await http.post(
          'http://astradev-001-site10.ftempurl.com/api/Recipes/AddRecipe',
          body: json.encode(recipeData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      Recipe newRecipe = Recipe(
          id: responseData['id'],
          name: name,
          directions: directions,
          image: image,
          ingredients: new List<Ingredient>());

      _recipes.add(newRecipe);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> addIngredientToRecipe(
      Recipe recipe, Ingredient ingredient) async {
    http.Response response = await http.put(
        'http://astradev-001-site10.ftempurl.com/api/Recipes/AddIngredientToRecipe?IngredientId=${ingredient.id}&RecipeId=${recipe.id}',
        body: json.encode(true));

    if (response.statusCode == 200 || response.statusCode == 201) {
      recipe.ingredients.add(ingredient);
      return true;
    }

    return false;
  }
}

//////////////////////////////////////// RECIPES MODEL////////////////////////////////////////////

class RecipesModel extends ConnectedRecipesModel {
  bool _showRecipesFavorites = false;

  List<Recipe> get getRecipes {
    return List.from(_recipes);
  }

  List<Recipe> get displayedRecipes {
    if (_showRecipesFavorites)
      return _recipes.where((Recipe recipe) => recipe.isFavorite).toList();
    return List.from(_recipes);
  }

  int get getSelectedRecipeId {
    return _selectedRecipeId;
  }

  int get getSelectedRecipeIndex {
    return _recipes.indexWhere((Recipe recipe) {
      return recipe.id == _selectedRecipeId;
    });
  }

  bool get displayRecipesFavoritesOnly {
    return _showRecipesFavorites;
  }

  Recipe get selectedRecipe {
    if (_selectedRecipeId == null) return null;
    return _recipes.firstWhere((Recipe recipe) {
      return recipe.id == _selectedRecipeId;
    });
  }

  Recipe getRecipeById(int id) {
    if (id == null) return null;
    return _recipes.firstWhere((Recipe recipe) {
      return recipe.id == id;
    }, orElse: null);
  }

  Future<bool> updateRecipe(String name, String directions, String image) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'Id': selectedRecipe.id,
      'Name': name,
      'Directions': directions,
      'Image':
          'http://as01.epimg.net/deporteyvida/imagenes/2018/05/07/portada/1525714597_852564_1525714718_noticia_normal.jpg',
    };

    return http
        .put('http://astradev-001-site10.ftempurl.com/api/Recipes/UpdateRecipe',
            body: json.encode(updateData))
        .then((http.Response response) {
      Recipe updatedRecipe = Recipe(
          id: selectedRecipe.id,
          name: name,
          directions: directions,
          image: image,
          ingredients: selectedRecipe.ingredients);
      _recipes[getSelectedRecipeIndex] = updatedRecipe;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteRecipe() {
    _isLoading = true;
    final int deletedRecipeId = selectedRecipe.id;
    _recipes.removeAt(getSelectedRecipeIndex);
    _selectedRecipeId = null;
    notifyListeners();

    return http
        .delete(
            'http://astradev-001-site10.ftempurl.com/api/Recipes/UpdateRecipe?Id=$deletedRecipeId')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void setSelectedRecipe(int recipeId) {
    _selectedRecipeId = recipeId;
    if (recipeId != null) {
      notifyListeners();
    }
  }

  List<Ingredient> fetchIngredientsByIds(List<int> ingredientsIds) {
    List<Ingredient> ingredients = new List<Ingredient>();

    ingredientsIds.forEach(
      (int ingredientId) {
        ingredients.add(_ingredients.firstWhere(
          (Ingredient ingredient) {
            return ingredient.id == ingredientId;
          },
        ));
      },
    );
    return ingredients;
  }

  Future<bool> fetchIngredients() {
    _isLoading = true;
    notifyListeners();

    return http
        .get(
            'http://astradev-001-site10.ftempurl.com/api/Ingredients/GetIngredients')
        .then((http.Response response) {
      final List<Ingredient> fetchedIngredientList = [];
      final List<dynamic> ingredientListData = json.decode(response.body);
      if (ingredientListData != null) {
        ingredientListData.forEach((dynamic ingredientData) {
          ingredientData['Image'] = ingredientData['Image'] == null
              ? 'https://i.blogs.es/36938e/istock-840527124/450_1000.jpg'
              : ingredientData['Image'];

          final Ingredient ingredient = Ingredient(
              id: ingredientData['Id'],
              name: ingredientData['Name'],
              description: ingredientData['Description'],
              image: ingredientData['Image'],
              quantity: ingredientData['Quantity'],
              calories: ingredientData['Calories'],
              isFavorite: ingredientData['WishlistUsers'] != null
                  ? (ingredientData['WishlistUsers'])
                      .contains(_authenticatedUser.id)
                  : false);
          fetchedIngredientList.add(ingredient);
        });
        _ingredients = fetchedIngredientList;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();

    //Make sure _ingredients have been fetched
    await fetchIngredients();

    return http
        .get('http://astradev-001-site10.ftempurl.com/api/Recipes/GetRecipes')
        .then((http.Response response) {
      final List<Recipe> fetchedRecipeList = [];
      final List<dynamic> recipeListData = json.decode(response.body);
      if (recipeListData != null) {
        recipeListData.forEach((dynamic recipeData) {
          recipeData['Image'] = recipeData['image'] == null
              ? 'https://i.blogs.es/36938e/istock-840527124/450_1000.jpg'
              : recipeData['image'];

          final Recipe recipe = Recipe(
            id: recipeData['Id'],
            name: recipeData['Name'],
            directions: recipeData['Directions'],
            image: recipeData['Image'],
            isFavorite: recipeData['WishlistUsers'] != null
                ? (recipeData['WishlistUsers']).contains(_authenticatedUser.id)
                : false,
            ingredients: recipeData['Ingredients'] != null
                ? fetchIngredientsByIds(recipeData['Ingredients'].cast<int>())
                : new List<Ingredient>(),
          );
          fetchedRecipeList.add(recipe);

          // //Adding manually first ingredient
          // if (recipe.ingredients.length == 0) {
          //   addIngredientToRecipe(recipe, _ingredients[0]);
          // }
        });

        _recipes = fetchedRecipeList;
      }
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      print(error.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> toggleRecipeFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedRecipe.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    _recipes[getSelectedRecipeIndex] = Recipe(
        id: selectedRecipe.id,
        directions: selectedRecipe.directions,
        image: selectedRecipe.image,
        name: selectedRecipe.name,
        isFavorite: newFavoriteStatus,
        ingredients: selectedRecipe.ingredients);

    // _isLoading = true;
    // notifyListeners();

    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'http://astradev-001-site10.ftempurl.com/api/Recipes/AddRecipeToUserWishlist?RecipeId=${selectedRecipe.id}&UserId=${_authenticatedUser.id}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'http://astradev-001-site10.ftempurl.com/api/Recipes/DeleteRecipeFromUserWishlist?RecipeId=${selectedRecipe.id}&UserId=${_authenticatedUser.id}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      // _isLoading = false;
      // notifyListeners();
      _recipes[getSelectedRecipeIndex] = Recipe(
          id: selectedRecipe.id,
          directions: selectedRecipe.directions,
          image: selectedRecipe.image,
          name: selectedRecipe.name,
          isFavorite: !newFavoriteStatus,
          ingredients: selectedRecipe.ingredients);
      return false;
    }

    // _isLoading = false;
    notifyListeners();
    return true;
  }

  void toggleRecipeDisplayMode() {
    _showRecipesFavorites = !_showRecipesFavorites;
    notifyListeners();
  }
}

////////////////////////////////////////CONNECTED INGREDIENTS MODEL////////////////////////////////////////////

class ConnectedIngredientsModel extends ConnectedRecipesModel {
  int _selectedIngredientId;

  Future<bool> addIngredient(
      String name, String description, String image) async {
    String quantity = '50 gramos';
    double calories = 0.0;

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> ingredientData = {
      'Name': name,
      'Description': description,
      'Quantity': quantity,
      'Image':
          'https://media.phillyvoice.com/media/images/food-eggs.2e16d0ba.fill-735x490.jpg',
    };
    try {
      final http.Response response = await http.post(
          'http://astradev-001-site10.ftempurl.com/api/Ingredients/AddIngredient',
          body: json.encode(ingredientData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['Id'] != 0) {
        Ingredient newIngredient = Ingredient(
            id: responseData['Id'],
            quantity: quantity,
            name: name,
            description: description,
            image: image,
            calories: calories);
        _ingredients.add(newIngredient);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

////////////////////////////////////////INGREDIENTS MODEL////////////////////////////////////////////

class IngredientsModel extends ConnectedIngredientsModel {
  bool _showIngredientsFavorites = false;

  List<Ingredient> get getIngredients {
    return List.from(_ingredients);
  }

  List<Ingredient> get displayedIngredients {
    if (_showIngredientsFavorites)
      return _ingredients
          .where((Ingredient ingredient) => ingredient.isFavorite)
          .toList();
    return List.from(_ingredients);
  }

  bool get displayIngredientsFavoritesOnly {
    return _showIngredientsFavorites;
  }

  int get getSelectedIngredientId {
    return _selectedIngredientId;
  }

  int get getSelectedIngredientIndex {
    return _ingredients.indexWhere((Ingredient ingredient) {
      return ingredient.id == _selectedIngredientId;
    });
  }

  Ingredient get selectedIngredient {
    if (_selectedIngredientId == null) return null;
    return _ingredients.firstWhere((Ingredient ingredient) {
      return ingredient.id == _selectedIngredientId;
    });
  }

  Future<bool> updateIngredient(String name, String description, String image) {
    String quantity = '50 gramos';
    double calories = 0.0;

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'Id': selectedIngredient.id,
      'Name': name,
      'Description': description,
      'Quantity': quantity,
      'Image': image,
    };

    return http
        .put(
            'http://astradev-001-site10.ftempurl.com/api/Ingredients/UpdateIngredient',
            body: json.encode(updateData))
        .then((http.Response response) {
      Ingredient updatedIngredient = Ingredient(
          id: selectedIngredient.id,
          name: name,
          description: description,
          quantity: quantity,
          image: image,
          calories: calories);
      _ingredients[getSelectedIngredientIndex] = updatedIngredient;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteIngredient() {
    _isLoading = true;
    final int deletedIngredientId = selectedIngredient.id;
    _ingredients.removeAt(getSelectedIngredientIndex);
    _selectedIngredientId = null;
    notifyListeners();
    return http
        .delete(
            'http://astradev-001-site10.ftempurl.com/api/Ingredients/DeleteIngredient?Id=$deletedIngredientId')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void setSelectedIngredient(int ingredientId) {
    _selectedIngredientId = ingredientId;
    if (ingredientId != null) {
      notifyListeners();
    }
  }

  Future<bool> toggleIngredientFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedIngredient.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    _ingredients[getSelectedIngredientIndex] = Ingredient(
        id: selectedIngredient.id,
        description: selectedIngredient.description,
        quantity: selectedIngredient.quantity,
        image: selectedIngredient.image,
        name: selectedIngredient.name,
        calories: selectedIngredient.calories,
        isFavorite: newFavoriteStatus);

    // _isLoading = true;
    // notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'http://astradev-001-site10.ftempurl.com/api/Ingredients/AddIngredientToUserWishlist?IngredientId=${selectedIngredient.id}&UserId=${_authenticatedUser.id}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'http://astradev-001-site10.ftempurl.com/api/Ingredients/DeleteIngredientFromUserWishlist?IngredientId=${selectedIngredient.id}&UserId=${_authenticatedUser.id}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      // _isLoading = false;
      // notifyListeners();
      _ingredients[getSelectedIngredientIndex] = Ingredient(
          id: selectedIngredient.id,
          description: selectedIngredient.description,
          quantity: selectedIngredient.quantity,
          image: selectedIngredient.image,
          name: selectedIngredient.name,
          calories: selectedIngredient.calories,
          isFavorite: !newFavoriteStatus);
      return false;
    }

    // _isLoading = false;
    notifyListeners();
    return true;
  }

  void toggleIngredientDisplayMode() {
    _showIngredientsFavorites = !_showIngredientsFavorites;
    notifyListeners();
  }
}

////////////////////////////////////////USER MODEL////////////////////////////////////////////

class UserModel extends ConnectedRecipesModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(
      String email, String password, AuthMode _authMode) async {
    String postUrl = _authMode == AuthMode.Login
        ? 'http://astradev-001-site10.ftempurl.com/api/Users/VerifyPassword'
        : 'http://astradev-001-site10.ftempurl.com/api/Users/SignupNewUser';

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'Email': email,
      'Password': password,
      'ReturnSecureToken': true
    };

    final http.Response response = await http.post(postUrl,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    bool success = false;
    String message = 'Something went wrong';
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData.containsKey('Token')) {
      message = 'Authentication succeeded!';
      success = true;
      _authenticatedUser = User(
          email: email, id: responseData['Id'], token: responseData['Token']);
      _userSubject.add(true);
      setAuthTimeout(responseData['ExpiresIn']);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['Token']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['Id'].toString());
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: responseData['ExpiresIn']));
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['Error'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (responseData['Error'] == 'EMAIL_NOT_FOUND') {
      message = 'The email was not found';
    } else if (responseData['Error'] == 'INVALID_PASSWORD') {
      message = 'Invalid Password';
    }

    _isLoading = false;
    notifyListeners();
    return {'success': success, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final DateTime now = DateTime.now();
      final String expiryTimeString = prefs.getString('expiryTime');
      final DateTime parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        //User token already expired
        _authenticatedUser = null;
      } else {
        final String userEmail = prefs.getString('userEmail');
        final int userId = int.parse(prefs.getString('userId'));
        _authenticatedUser = User(
          email: userEmail,
          id: userId,
          token: token,
        );
        _userSubject.add(true);
        final int tokenLifeSpan = parsedExpiryTime.difference(now).inSeconds;
        setAuthTimeout(tokenLifeSpan);
      }
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    // Logout when token expires
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

///////////////////////////////////////////////////////////Date Model/////////////////////////////////////////////////

class DatesModel extends RecipesModel {
  List<Date> _dates = [];
  int _selectedDate;

  Future<bool> fetchDates() {
    _isLoading = true;
    notifyListeners();
    List<Date> fetchedDates = [];

    return http
        .get(
            'http://astradev-001-site10.ftempurl.com/api/Dates/GetDatesFromUser?id=${_authenticatedUser.id}')
        .then((http.Response response) {
      final List<dynamic> calendarData = json.decode(response.body);
      if (calendarData != null) {
        calendarData.forEach((dynamic dateData) {
          final DateTime dateTime = DateTime.parse(dateData['DateTime']);
          final List<Food> foods = new List<Food>();

          dateData['Foods'].forEach((dynamic foodData) {
            final Food food = Food(
              recipe: getRecipeById(foodData['RecipeId']),
              timeToEat: foodData['TimeToEat'],
            );
            foods.add(food);
          });

          Date date = new Date(dateTime: dateTime, foods: foods);
          fetchedDates.add(date);
        });
        _dates = fetchedDates;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  List<Date> get getDates {
    return List.from(_dates);
  }

  void setSelectedDate(int index) {
    _selectedDate = index;
  }

  Date get getSelectedDate {
    return _dates[_selectedDate];
  }
}

/////////////////////////////////////////////////////////Utility Model////////////////////////////////////////////////////

class UtilityModel extends ConnectedRecipesModel {
  bool get isLoading {
    return _isLoading;
  }
}
