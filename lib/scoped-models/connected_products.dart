import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  String _selectedProductId;
  User _authenticatedUser;
  bool _isLoading = false;

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> productData = {
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
          'https://flutter-udemy-course.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
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

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get getProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites)
      return _products.where((Product product) => product.isFavorite).toList();
    return List.from(_products);
  }

  String get getSelectedProductId {
    return _selectedProductId;
  }

  int get getSelectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selectedProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Product get selectedProduct {
    if (_selectedProductId == null) return null;
    return _products.firstWhere((Product product) {
      return product.id == _selectedProductId;
    });
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'http://as01.epimg.net/deporteyvida/imagenes/2018/05/07/portada/1525714597_852564_1525714718_noticia_normal.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };

    return http
        .put(
            'https://flutter-udemy-course.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[getSelectedProductIndex] = updatedProduct;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final String deletedProductId = selectedProduct.id;
    _products.removeAt(getSelectedProductIndex);
    _selectedProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-udemy-course.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
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

  void setSelectedProduct(String productId) {
    _selectedProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  Future<bool> fetchProducts() {
    _isLoading = true;
    notifyListeners();

    return http
        .get(
            'https://flutter-udemy-course.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData != null) {
        productListData.forEach((String productId, dynamic productData) {
          final Product product = Product(
              id: productId,
              title: productData['title'],
              description: productData['description'],
              image: productData['image'],
              price: productData['price'],
              userEmail: productData['userEmail'],
              userId: productData['userId']);
          fetchedProductList.add(product);
        });
        _products = fetchedProductList;
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

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    _products[getSelectedProductIndex] = Product(
        id: selectedProduct.id,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        title: selectedProduct.title,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(
      String email, String password, AuthMode _authMode) async {
    String postUrl = _authMode == AuthMode.Login
        ? 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDPgk8znrep4Lw19pJ3cCH_27kemPut-2g'
        : 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDPgk8znrep4Lw19pJ3cCH_27kemPut-2g';

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
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
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      _authenticatedUser = User(
        email: userEmail,
        id: userId,
        token: token,
      );
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
