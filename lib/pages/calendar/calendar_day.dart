import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:flutter/material.dart';

class CalendarDayPage extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar - day"),
      ),
      // body: IngredientManager(startingIngredient:'Food Tester')
      body: new SideHeaderListView(
        itemCount: names.length,
        padding: new EdgeInsets.all(16.0),
        itemExtend: 48.0,
        headerBuilder: (BuildContext context, int index) {
          return new SizedBox(
              width: 32.0,
              child: new Text(
                names[index].substring(0, 1),
                style: Theme.of(context).textTheme.headline,
              ));
        },
        itemBuilder: (BuildContext context, int index) {
          return new Text(
            names[index],
            style: Theme.of(context).textTheme.headline,
          );
        },
        hasSameHeader: (int a, int b) {
          return names[a].substring(0, 1) == names[b].substring(0, 1);
        },
      ),
    );
  }
}

const names = const <String>[
  'Annie',
  'Arianne',
  'Bertie',
  'Bettina',
  'Bradly',
  'Caridad',
  'Carline',
  'Cassie',
  'Chloe',
  'Christin',
  'Clotilde',
  'Dahlia',
  'Dana',
  'Dane',
  'Darline',
  'Deena',
  'Delphia',
  'Donny',
  'Echo',
  'Else',
  'Ernesto',
  'Fidel',
  'Gayla',
  'Grayce',
  'Henriette',
  'Hermila',
  'Hugo',
  'Irina',
  'Ivette',
  'Jeremiah',
  'Jerica',
  'Joan',
  'Johnna',
  'Jonah',
  'Joseph',
  'Junie',
  'Linwood',
  'Lore',
  'Louis',
  'Merry',
  'Minna',
  'Mitsue',
  'Napoleon',
  'Paris',
  'Ryan',
  'Salina',
  'Shantae',
  'Sonia',
  'Taisha',
  'Zula',
];

