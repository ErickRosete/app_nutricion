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

////////////////////////////////////////CONNECTED RECIPES MODEL////////////////////////////////////////////
class ConnectedRecipesModel extends Model {
  List<Recipe> _recipes = [];
  List<Ingredient> _ingredients = [];
  String _selectedRecipeId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<bool> addRecipe(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> recipeData = {
      'title': title,
      'description': description,
      'image':
          'http://as01.epimg.net/deporteyvida/imagenes/2018/05/07/portada/1525714597_852564_1525714718_noticia_normal.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://app-de-nutricion.firebaseio.com/recipes.json?auth=${_authenticatedUser.token}',
          body: json.encode(recipeData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      Recipe newRecipe = Recipe(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id,
          ingredients: new List<Ingredient>());

      //Make sure ingredients have been fetched
      await fetchIngredients();
      //Adding manually first ingredient
      if (_ingredients != null && _ingredients.length > 0) {
        addIngredientToRecipe(newRecipe, _ingredients[0]);
      }

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
    // _isLoading = true;
    // notifyListeners();
    http.Response response;
    response = await http.put(
        'https://app-de-nutricion.firebaseio.com/recipes/${recipe.id}/ingredients/${ingredient.id}.json?auth=${_authenticatedUser.token}',
        body: json.encode(true));

    if (response.statusCode == 200 || response.statusCode == 201) {
      recipe.ingredients.add(ingredient);
      return true;
    }

    return false;
  }

  Future<bool> fetchIngredients({bool onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();

    return http
        .get(
            'https://app-de-nutricion.firebaseio.com/ingredients.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      final List<Ingredient> fetchedIngredientList = [];
      final Map<String, dynamic> ingredientListData =
          json.decode(response.body);
      if (ingredientListData != null) {
        ingredientListData
            .forEach((String ingredientId, dynamic ingredientData) {
          final Ingredient ingredient = Ingredient(
              id: ingredientId,
              title: ingredientData['title'],
              description: ingredientData['description'],
              image: ingredientData['image'],
              userEmail: ingredientData['userEmail'],
              userId: ingredientData['userId'],
              isFavorite: ingredientData['wishlistUsers'] != null
                  ? (ingredientData['wishlistUsers'] as Map<String, dynamic>)
                      .containsKey(_authenticatedUser.id)
                  : false);
          fetchedIngredientList.add(ingredient);
        });
        _ingredients = onlyForUser
            ? fetchedIngredientList.where((Ingredient ingredient) {
                return ingredient.userId == _authenticatedUser.id;
              }).toList()
            : fetchedIngredientList;
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

  String get getSelectedRecipeId {
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

  Future<bool> updateRecipe(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'http://as01.epimg.net/deporteyvida/imagenes/2018/05/07/portada/1525714597_852564_1525714718_noticia_normal.jpg',
      'price': price,
      'userEmail': selectedRecipe.userEmail,
      'userId': selectedRecipe.userId
    };

    return http
        .put(
            'https://app-de-nutricion.firebaseio.com/recipes/${selectedRecipe.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      Recipe updatedRecipe = Recipe(
          id: selectedRecipe.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedRecipe.userEmail,
          userId: selectedRecipe.userId,
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
    final String deletedRecipeId = selectedRecipe.id;
    _recipes.removeAt(getSelectedRecipeIndex);
    _selectedRecipeId = null;
    notifyListeners();
    return http
        .delete(
            'https://app-de-nutricion.firebaseio.com/recipes/$deletedRecipeId.json?auth=${_authenticatedUser.token}')
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

  void setSelectedRecipe(String recipeId) {
    _selectedRecipeId = recipeId;
    if (recipeId != null) {
      notifyListeners();
    }
  }

  List<Ingredient> fetchIngredientsByIds(Map<String, dynamic> ingredientsMap) {
    
    List<Ingredient> ingredients = new List<Ingredient>();

    ingredientsMap.forEach(
      (String ingredientId, dynamic boleano) {
        ingredients.add(_ingredients.firstWhere(
          (Ingredient ingredient) {
            return ingredient.id == ingredientId;
          },
        ));
      },
    );

    return ingredients;
  }

  Future<bool> fetchRecipes({bool onlyForUser = false}) async {
    _isLoading = true;
    notifyListeners();

    //Make sure _ingredients have been fetched
    await fetchIngredients();

    return http
        .get(
            'https://app-de-nutricion.firebaseio.com/recipes.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      final List<Recipe> fetchedRecipeList = [];
      final Map<String, dynamic> recipeListData = json.decode(response.body);
      if (recipeListData != null) {
        recipeListData.forEach((String recipeId, dynamic recipeData) {
          final Recipe recipe = Recipe(
              id: recipeId,
              title: recipeData['title'],
              description: recipeData['description'],
              image: recipeData['image'],
              price: recipeData['price'],
              userEmail: recipeData['userEmail'],
              userId: recipeData['userId'],
              isFavorite: recipeData['wishlistUsers'] != null
                  ? (recipeData['wishlistUsers'] as Map<String, dynamic>)
                      .containsKey(_authenticatedUser.id)
                  : false,
              ingredients: recipeData['ingredients'] != null
                  ? fetchIngredientsByIds(
                      recipeData['ingredients'] as Map<String, dynamic>)
                  : new List<Ingredient>());

          // //Adding manually first ingredient
          // if (recipe.ingredients.length == 0) {
          //   addIngredientToRecipe(recipe, _ingredients[0]);
          // }

          fetchedRecipeList.add(recipe);
        });
        _recipes = onlyForUser
            ? fetchedRecipeList.where((Recipe recipe) {
                return recipe.userId == _authenticatedUser.id;
              }).toList()
            : fetchedRecipeList;
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

  Future<bool> toggleRecipeFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedRecipe.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;

    _recipes[getSelectedRecipeIndex] = Recipe(
        id: selectedRecipe.id,
        description: selectedRecipe.description,
        image: selectedRecipe.image,
        price: selectedRecipe.price,
        title: selectedRecipe.title,
        userEmail: selectedRecipe.userEmail,
        userId: selectedRecipe.userId,
        isFavorite: newFavoriteStatus,
        ingredients: selectedRecipe.ingredients);

    // _isLoading = true;
    // notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://app-de-nutricion.firebaseio.com/recipes/${selectedRecipe.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://app-de-nutricion.firebaseio.com/recipes/${selectedRecipe.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      // _isLoading = false;
      // notifyListeners();
      _recipes[getSelectedRecipeIndex] = Recipe(
          id: selectedRecipe.id,
          description: selectedRecipe.description,
          image: selectedRecipe.image,
          price: selectedRecipe.price,
          title: selectedRecipe.title,
          userEmail: selectedRecipe.userEmail,
          userId: selectedRecipe.userId,
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
  String _selectedIngredientId;

  Future<bool> addIngredient(
      String title, String description, String image) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> ingredientData = {
      'title': title,
      'description': description,
      'image':
          'https://media.phillyvoice.com/media/images/food-eggs.2e16d0ba.fill-735x490.jpg',
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://app-de-nutricion.firebaseio.com/ingredients.json?auth=${_authenticatedUser.token}',
          body: json.encode(ingredientData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      Ingredient newIngredient = Ingredient(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _ingredients.add(newIngredient);
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

  String get getSelectedIngredientId {
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

  Future<bool> updateIngredient(
      String title, String description, String image) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'https://media.phillyvoice.com/media/images/food-eggs.2e16d0ba.fill-735x490.jpg',
      'userEmail': selectedIngredient.userEmail,
      'userId': selectedIngredient.userId
    };

    return http
        .put(
            'https://app-de-nutricion.firebaseio.com/ingredients/${selectedIngredient.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      Ingredient updatedIngredient = Ingredient(
          id: selectedIngredient.id,
          title: title,
          description: description,
          image: image,
          userEmail: selectedIngredient.userEmail,
          userId: selectedIngredient.userId);
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
    final String deletedIngredientId = selectedIngredient.id;
    _ingredients.removeAt(getSelectedIngredientIndex);
    _selectedIngredientId = null;
    notifyListeners();
    return http
        .delete(
            'https://app-de-nutricion.firebaseio.com/ingredients/$deletedIngredientId.json?auth=${_authenticatedUser.token}')
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

  void setSelectedIngredient(String ingredientId) {
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
        image: selectedIngredient.image,
        title: selectedIngredient.title,
        userEmail: selectedIngredient.userEmail,
        userId: selectedIngredient.userId,
        isFavorite: newFavoriteStatus);

    // _isLoading = true;
    // notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://app-de-nutricion.firebaseio.com/ingredients/${selectedIngredient.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://app-de-nutricion.firebaseio.com/ingredients/${selectedIngredient.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      // _isLoading = false;
      // notifyListeners();
      _ingredients[getSelectedIngredientIndex] = Ingredient(
          id: selectedIngredient.id,
          description: selectedIngredient.description,
          image: selectedIngredient.image,
          title: selectedIngredient.title,
          userEmail: selectedIngredient.userEmail,
          userId: selectedIngredient.userId,
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
        ? 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCq1CN_FVBqhum73c_sMGuItfzPuLEGLVE'
        : 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCq1CN_FVBqhum73c_sMGuItfzPuLEGLVE';

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final http.Response response = await http.post(postUrl,
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'});

    bool success = false;
    String message = 'Something went wrong';
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData.containsKey('idToken')) {
      message = 'Authentication succeeded!';
      success = true;
      _authenticatedUser = User(
          email: email,
          id: responseData['localId'],
          token: responseData['idToken']);
      _userSubject.add(true);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'The email was not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
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
        final String userId = prefs.getString('userId');
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

class UtilityModel extends ConnectedRecipesModel {
  bool get isLoading {
    return _isLoading;
  }
}
