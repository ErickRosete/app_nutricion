import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './recipe_form.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class RecipeListPage extends StatefulWidget {
  final MainModel model;

  RecipeListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RecipeListPageState();
  }
}

class _RecipeListPageState extends State<RecipeListPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchRecipes();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.setSelectedRecipe(model.getRecipes[index].id);
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (BuildContext context) => RecipeFormPage(),
          ),
        )
            .then((_) {
          model.setSelectedRecipe(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final Recipe recipe = model.getRecipes[index];
            double calories = 0.0;
//          recipe.ingredients.forEach((ing) => calories += ing.calories);

            return Dismissible(
              key: Key(recipe.name),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart ||
                    direction == DismissDirection.startToEnd) {
                  model.setSelectedRecipe(recipe.id);
                  model.deleteRecipe();
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(recipe.image),
                    ),
                    title: Text(recipe.name),
                    subtitle: Text('$calories cal'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.getRecipes.length,
        );
      },
    );
  }
}
