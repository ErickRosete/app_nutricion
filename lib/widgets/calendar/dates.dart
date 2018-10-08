import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../../models/date.dart';
import '../../scoped-models/main.dart';

class Dates extends StatelessWidget {
  Widget _buildDateList(BuildContext context, List<Date> dates, Function setSelectedDate) {
    return ListView.builder(
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final Date date = dates[index];
        return Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                child: _dayImage(date.dateTime),
                backgroundColor: Colors.transparent,
              ),
              title: Text(DateFormat.yMMMMd("es").format(date.dateTime)),
              subtitle: Text(DateFormat.EEEE('es').format(date.dateTime)),
              onTap: () {
                setSelectedDate(index);
                Navigator.pushNamed(context, '/calendarDay');
              },
            ),
            Divider(),
          ],
        );
      },
    );
  }

    Image _dayImage(DateTime date) {
    return Image.asset(
      "assets/icons/" + DateFormat('EEEE').format(date) + ".png",
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildDateList(context, model.getDates, model.setSelectedDate);
      },
    );
  }
}
