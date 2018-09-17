import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class IngredientFormPage extends StatefulWidget {
  final int ingredientIndex;

  IngredientFormPage({this.ingredientIndex});

  @override
  State<StatefulWidget> createState() {
    return _IngredientFormPageState();
  }
}

class _IngredientFormPageState extends State<IngredientFormPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'image': 'assets/food.jpg',
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Ingredient ingredient) {
    return TextFormField(
      initialValue: ingredient == null ? '' : ingredient.title,
      decoration: InputDecoration(labelText: 'Ingredient Title'),
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

  Widget _buildDescriptionTextField(Ingredient ingredient) {
    return TextFormField(
      maxLines: 4,
      initialValue: ingredient == null ? '' : ingredient.description,
      decoration: InputDecoration(labelText: 'Ingredient Description'),
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

  Widget _buildSubmitButton(MainModel model) {
    return model.isLoading
        ? Center(child: CircularProgressIndicator())
        : RaisedButton(
            child: Text("Save"),
            textColor: Colors.white,
            onPressed: () => _submitForm(model.addIngredient, model.updateIngredient,
                model.setSelectedIngredient, model.getSelectedIngredientIndex));
  }

  void _errorManagement(bool success, Function setSelectedIngredient) {
    if (success) {
      Navigator.pushReplacementNamed(context, '/ingredients')
          .then((_) => setSelectedIngredient(null));
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
      Function addIngredient, Function updateIngredient, Function setSelectedIngredient,
      [int selectedIngredientIndex]) {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    if (selectedIngredientIndex == -1) {
      addIngredient(
        _formData['title'],
        _formData['description'],
        _formData['image'],
      ).then((bool success) {
        _errorManagement(success, setSelectedIngredient);
      });
    } else {
      updateIngredient(
        _formData['title'],
        _formData['description'],
        _formData['image'],
      ).then((bool success) {
        _errorManagement(success, setSelectedIngredient);
      });
    }
  }

  Widget _buildPageContent(BuildContext context, MainModel model) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Ingredient ingredient = model.selectedIngredient;

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
              _buildTitleTextField(ingredient),
              _buildDescriptionTextField(ingredient),
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
        if (model.getSelectedIngredientIndex == -1) return pageContent;
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Ingredient"),
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
//     child: Text("Create a Ingredient"),
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
