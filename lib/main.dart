import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// Data model kept as simple as possible - a class with one private internal 
// counter, a getter and methods for counting up/down.
class AppModel extends Model {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoped Counter Example',
      home: ScopedModel<AppModel>(
        model: AppModel(),
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  // Create two independent model invocations
  final AppModel appModelOne = AppModel();
  final AppModel appModelTwo = AppModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Basic Counter'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ScopedModel<AppModel>(
                model: appModelOne,
                child: Counter(
                  counterName: 'App Model One',
                ),
              ),
              ScopedModel<AppModel>(
                model: appModelTwo,
                child: Counter(
                  counterName: 'App Model Two',
                ),
              ),
            ],
          ),
        ));
  }
}

class Counter extends StatelessWidget {
  final String counterName;
  Counter({Key key, this.counterName});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("$counterName"),
              SizedBox(height: 20.0,),
              Text(
                model.count.toString(),
                style: (model.count>=0?
                  new TextStyle(color:Colors.blue, fontSize: 48.0,):
                  new TextStyle(color:Colors.red, fontSize: 48.0,))
              ),
              ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_drop_up, size: 50.0,),
                    onPressed: model.increment,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_drop_down, size: 50.0,),
                    onPressed: model.decrement,
                  )
                ],
              )
            ],
          ),
    );
  }
}