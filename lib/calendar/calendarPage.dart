import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;

class CalendarPage extends StatefulWidget {

  CalendarPage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<StatefulWidget> createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {

  DateTime _currentDate = DateTime(2019, 4, 23);
  DateTime _currentDate2 = DateTime(2019, 4, 23);
  String _currentMonth = '';
  var _time;

  //List<String> _toDoList = [];
  Map<DateTime, List<String>> _toDoList = {new DateTime(1900):[]};

//  List<DateTime> _markedDate = [DateTime(2018, 9, 20), DateTime(2018, 10, 11)];
  static Widget _eventIcon = new Container(
    decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(700)),
        border: Border.all(color: Colors.blue, width: 2.0)),
    child: new Icon(
      Icons.person,
      color: Colors.amber,
    ),
  );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {
      new DateTime(2019, 4, 22): [
        /*
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 1',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 2',
          icon: _eventIcon,
        ),
        new Event(
          date: new DateTime(2019, 2, 10),
          title: 'Event 3',
          icon: _eventIcon,
        ),
        */
      ],
    },
  );

  CalendarCarousel _calendarCarouselNoHeader;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => _currentDate2 = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 310.0,
      selectedDateTime: _currentDate2,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      markedDateMoreShowTotal:
      false,
      // null for not showing hidden events indicator
      showHeader: false,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      weekDayMargin: EdgeInsets.only(bottom: 1),
      dayPadding: 1,
      minSelectedDate: _currentDate,
      maxSelectedDate: _currentDate.add(Duration(days: 60)),
//      inactiveDateColor: Colors.black12,
      onCalendarChanged: (DateTime date) {
        this.setState(() => _currentMonth = DateFormat.yMMM().format(date));
      },
    );

    //List events for a selected date
    void _addToDoItem(String task) {
      if(task.length > 0) {
        if(_toDoList.containsKey(_currentDate2)) {
          setState(() => _toDoList[_currentDate2].add(task));
        }
        else {
          setState(() {
            _toDoList[_currentDate2] = [task];
          });
        }
        setState(() =>
            _markedDateMap.add(_currentDate2, new Event(
                title: task, date: _currentDate2, icon: _eventIcon)));
      }
    }

    void _removeTodoItem(int index) {
      Event te = _markedDateMap.getEvents(_currentDate2)[index];
      setState(() => _toDoList[_currentDate2].removeAt(index));
      setState(() => _markedDateMap.remove(_currentDate2, te));
    }

    void _promptRemoveTodoItem(int index) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
                title: new Text('Mark "${_toDoList[index]}" as done?'),
                actions: <Widget>[
                  new FlatButton(
                      child: new Text('CANCEL'),
                      // The alert is actually part of the navigation stack, so to close it, we
                      // need to pop it.
                      onPressed: () => Navigator.of(context).pop()
                  ),
                  new FlatButton(
                      child: new Text('MARK AS DONE'),
                      onPressed: () {
                        _removeTodoItem(index);
                        Navigator.of(context).pop();
                      }
                  )
                ]
            );
          }
      );
    }

    Widget _buildToDoItem(String todoText, int index) {
      return new ListTile(
          title: new Text(todoText.substring(0, 5)),
          onLongPress: () => _promptRemoveTodoItem(index),
          trailing: Text(todoText.substring(5)),
      );
    }

    _showTimePicker() async {
      var picker =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
      setState(() {
        _time = picker.toString();
      });
    }

    void _pushAddTodoScreen() {
      var _timeR;
      // Push this page onto the stack
      Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well as adding
        // a back button to close it
          new MaterialPageRoute(
              builder: (context) {
                return new Scaffold(
                    appBar: new AppBar(
                        title: new Text('Add a New Task')
                    ),
                    body: new Column(
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new RaisedButton(
                              child: Text('Choose Time'),
                              onPressed: () => _showTimePicker(),
                            ),
                            new Text(_time == null ? "  -  " : _time.toString().substring(10,15)),
                          ],
                        ),
                        new TextField(
                          autofocus: true,
                          onSubmitted: (val) {
                            _timeR = _time.toString().substring(10,15);
                            _addToDoItem(_timeR + val);
                            Navigator.pop(context); // Close the add todo screen
                          },
                          decoration: new InputDecoration(
                              hintText: 'Enter something to do...',
                              contentPadding: const EdgeInsets.all(16.0)
                          ),
                        )
                      ],
                    )
                );
              }
          )
      );
    }

    Widget buildList() {
      //List<Event> dateEvents = _markedDateMap.getEvents(_currentDate2);
      //dateEvents.forEach((event) => _addToDoItem(event.title));
      return new Expanded(
        child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          // itemBuilder will be automatically be called as many times as it takes for the
          // list to fill up its available space, which is most likely more than the
          // number of todo items we have. So, we need to check the index is OK.
          if(_toDoList.containsKey(_currentDate2)) {
            if (index < _toDoList[_currentDate2].length) {
              return _buildToDoItem(_toDoList[_currentDate2][index], index);
            }
          }
        },
      ),
      );
    }

    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
                  //custom icon
                  // This trailing comma makes auto-formatting nicer for build methods.
                  //custom icon without header
                  Container(
                    margin: EdgeInsets.only(
                      top: 30.0,
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              _currentMonth,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ),
                            )),
                        FlatButton(
                          child: Text('PREV'),
                          onPressed: () {
                            setState(() {
                              _currentDate2 =
                                  _currentDate2.subtract(Duration(days: 30));
                              _currentMonth =
                                  DateFormat.yMMM().format(_currentDate2);
                            });
                          },
                        ),
                        FlatButton(
                          child: Text('NEXT'),
                          onPressed: () {
                            setState(() {
                              _currentDate2 = _currentDate2.add(Duration(days: 30));
                              _currentMonth =
                                  DateFormat.yMMM().format(_currentDate2);
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.0),
                    child: SingleChildScrollView(
                      child: _calendarCarouselNoHeader,
                    )
                  ),

                  buildList(),
                      //maxWidth: 150,
                  //
                ],
              ),
            /*
            Container(
              margin: EdgeInsets.all(5.0),
              child: LimitedBox(
                child: buildList(),
                maxHeight: 100,
                //maxWidth: 150,
              ),
            )
            */
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: 'Add Item',
          child: new Icon(Icons.add)
      ),
    );
  }
}