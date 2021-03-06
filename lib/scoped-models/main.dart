import 'package:scoped_model/scoped_model.dart';

import './connected_recipes.dart';

class MainModel extends Model with ConnectedRecipesModel, UserModel, RecipesModel, UtilityModel, 
ConnectedIngredientsModel, IngredientsModel, DatesModel, ShopItemsModel {}
