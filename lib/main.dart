import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import './pages/products.dart';
import './pages/product.dart';
import './pages/auth.dart';
import './pages/products_admin.dart';
import './scoped-models/products.dart';

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
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),
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
          '/admin': (BuildContext context) => ProductAdminPage(),
          '/products': (BuildContext context) => ProductsPage(),
          '/': (BuildContext context) => AuthPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(index),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
  }
}
