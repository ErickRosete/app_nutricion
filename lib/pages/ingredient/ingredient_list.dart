import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './ingredient_form.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class IngredientListPage extends StatefulWidget {
  final MainModel model;

  IngredientListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _IngredientListPageState();
  }
}

class _IngredientListPageState extends State<IngredientListPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchIngredients();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.setSelectedIngredient(model.getIngredients[index].id);
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (BuildContext context) => IngredientFormPage(),
          ),
        )
            .then((_) {
          model.setSelectedIngredient(null);
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
            final Ingredient ingredient = model.getIngredients[index];
            return Dismissible(
              key: Key(ingredient.name),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart ||
                    direction == DismissDirection.startToEnd) {
                  model.setSelectedIngredient(ingredient.id);
                  model.deleteIngredient();
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(ingredient.image),
                    ),
                    title: Text(ingredient.name),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.getIngredients.length,
        );
      },
    );
  }
}
