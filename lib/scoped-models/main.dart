import 'package:scoped_model/scoped_model.dart';

import './connected_recipes.dart';
import './shop_items.dart';
import './dates.dart';

class MainModel extends Model with ConnectedRecipesModel, UserModel, RecipesModel, UtilityModel, ConnectedIngredientsModel, IngredientsModel, ShopItemsModel, DatesModel {}
