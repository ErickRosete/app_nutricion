import 'package:scoped_model/scoped_model.dart';

import '../models/shop_item.dart';

////////////////////////////////////////CONNECTED RECIPES MODEL////////////////////////////////////////////
class ShopItemsModel extends Model {
  List<ShopItem> _shopItems = [];
  int _selectedShopItem;

  void addShopItem(ShopItem shopItem) {
    _shopItems.add(shopItem);
  }

  List<ShopItem> get getShopItems {
    return List.from(_shopItems);
  }

  ShopItem get getShopItem {
    return _shopItems[_selectedShopItem];
  }

  void setSelectedShopItem(int index){
    _selectedShopItem = index;
  }

  void toggleBoughtStatus()  {
    final bool isCurrentlyBought = getShopItem.bought;
    final bool newBoughtStatus = !isCurrentlyBought;

    _shopItems[_selectedShopItem] = ShopItem(
      bought: newBoughtStatus,
      ingredient: getShopItem.ingredient,
    );

    notifyListeners();
  }
}
