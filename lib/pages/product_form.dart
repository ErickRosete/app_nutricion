import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped-models/products.dart';

class ProductFormPage extends StatefulWidget {
  final int productIndex;

  ProductFormPage({this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductFormPageState();
  }
}

class _ProductFormPageState extends State<ProductFormPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.title,
      decoration: InputDecoration(labelText: 'Product Title'),
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      maxLines: 4,
      initialValue: product == null ? '' : product.description,
      decoration: InputDecoration(labelText: 'Product Description'),
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long.';
        }
        return null;
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      initialValue: product == null ? '' : product.price.toString(),
      decoration: InputDecoration(labelText: 'Product Price'),
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number.';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton(ProductsModel model) {
    return RaisedButton(
        child: Text("Save"),
        textColor: Colors.white,
        onPressed: () => _submitForm(
            model.addProduct, model.updateProduct, model.selectedProductIndex));
  }

  void _submitForm(Function addProduct, Function updateProduct,
      [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    Product formDataProduct = Product(
        price: _formData['price'],
        description: _formData['description'],
        image: _formData['image'],
        title: _formData['title'],);        
    if (selectedProductIndex == null) {
      addProduct(formDataProduct);
    } else {
      updateProduct(formDataProduct);
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildPageContent(BuildContext context, ProductsModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Product product = model.selectedProduct;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(model),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        Widget pageContent = _buildPageContent(context, model);
        if (model.selectedProductIndex == null) return pageContent;
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Product"),
          ),
          body: pageContent,
        );
      },
    );
  }
}

//////////////////////////GestureDetector////////////////////////////////
// GestureDetector(
//   onTap: _submitForm,
//   child: Container(
//     child: Text("Save"),
//     padding: EdgeInsets.all(5.0),
//     color: Theme.of(context).buttonColor,
//   ),
// )
///////////////////////////////Modal/////////////////////////////////////
//  Center(
//   child: RaisedButton(
//     child: Text("Create a product"),
//     onPressed: () {
//       showModalBottomSheet(
//           context: context,
//           builder: (BuildContext context) {
//             return Center(
//               child: Text('This is a modal!'),
//             );
//           });
//     },
//   ),
// );
