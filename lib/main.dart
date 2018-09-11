import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './scoped-models/main.dart';
import './models/product.dart';

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

  @override
  void initState() {
    super.initState();
    _model.autoAuthenticate();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
//      debugShowMaterialGrid: true,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          buttonColor: Colors.deepPurple,
//        fontFamily: 'Oswald',
//        brightness: Brightness.light,
//        accentColor: Colors.deepPurple,
//        buttonColor: Colors.purple[200]
        ),
//        home: AuthPage(),
        routes: {
          '/admin': (BuildContext context) => ProductAdminPage(_model),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/': (BuildContext context) =>
              _model.user == null ? AuthPage() : ProductsPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product =
                _model.getProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model));
        },
      ),
    );
  }
}
