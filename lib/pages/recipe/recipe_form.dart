import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class RecipeFormPage extends StatefulWidget {
  final int recipeIndex;

  RecipeFormPage({this.recipeIndex});

  @override
  State<StatefulWidget> createState() {
    return _RecipeFormPageState();
  }
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Recipe recipe) {
    return TextFormField(
      initialValue: recipe == null ? '' : recipe.title,
      decoration: InputDecoration(labelText: 'Recipe Title'),
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

  Widget _buildDescriptionTextField(Recipe recipe) {
    return TextFormField(
      maxLines: 4,
      initialValue: recipe == null ? '' : recipe.description,
      decoration: InputDecoration(labelText: 'Recipe Description'),
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

  Widget _buildPriceTextField(Recipe recipe) {
    return TextFormField(
      initialValue: recipe == null ? '' : recipe.price.toString(),
      decoration: InputDecoration(labelText: 'Recipe Price'),
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

  Widget _buildSubmitButton(MainModel model) {
    return model.isLoading
        ? Center(child: CircularProgressIndicator())
        : RaisedButton(
            child: Text("Save"),
            textColor: Colors.white,
            onPressed: () => _submitForm(model.addRecipe, model.updateRecipe,
                model.setSelectedRecipe, model.getSelectedRecipeIndex));
  }

  void _errorManagement(bool success, Function setSelectedRecipe) {
    if (success) {
      Navigator.pushReplacementNamed(context, '/')
          .then((_) => setSelectedRecipe(null));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Something went wrong'),
              content: Text('Please try again'),
              actions: <Widget>[
                RaisedButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    }
  }

  void _submitForm(
      Function addRecipe, Function updateRecipe, Function setSelectedRecipe,
      [int selectedRecipeIndex]) {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    if (selectedRecipeIndex == -1) {
      addRecipe(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((bool success) {
        _errorManagement(success, setSelectedRecipe);
      });
    } else {
      updateRecipe(
        _formData['title'],
        _formData['description'],
        _formData['image'],
        _formData['price'],
      ).then((bool success) {
        _errorManagement(success, setSelectedRecipe);
      });
    }
  }

  Widget _buildPageContent(BuildContext context, MainModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Recipe recipe = model.selectedRecipe;

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
              _buildTitleTextField(recipe),
              _buildDescriptionTextField(recipe),
              _buildPriceTextField(recipe),
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget pageContent = _buildPageContent(context, model);
        if (model.getSelectedRecipeIndex == -1) return pageContent;
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Recipe"),
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
//     child: Text("Create a Recipe"),
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
