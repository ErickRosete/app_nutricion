import 'package:flutter/material.dart';

class CalendarListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.calendar_today,
        color: Colors.orange.shade600,
      ),
      title: Text("Calendar"),
      onTap: () {
        Navigator.pushNamed(context, '/calendar');
      },
    );
  }
}
