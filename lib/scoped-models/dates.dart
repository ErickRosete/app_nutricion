import 'package:scoped_model/scoped_model.dart';

////////////////////////////////////////CONNECTED RECIPES MODEL////////////////////////////////////////////
class DatesModel extends Model {
  List<DateTime> _dates = [];
  int _selectedDate;

  void calculateDays()
  {
    var now = new DateTime.now();
    for(int i = 0; i < 7; i++)
    {
      var dayToAdd = now.add(new Duration(days: i));
      _dates.add(dayToAdd);
    }
  }

  List<DateTime> get getDates {
    return List.from(_dates);
  }

  void setSelectedDate(int index)
  {
    _selectedDate = index;
  }

  DateTime get getSelectedDate {
    return _dates[_selectedDate];
  }

}
