import 'package:flutter/material.dart';

class CalendarListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text("Calendar"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/calendar');
      },
    );
  }
}
