
import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file_observer.dart';

abstract class Observable {
  final List<DirectFileObserver> observers = [];

  void registerObserver(DirectFileObserver observer) {
    observers.add(observer);
  }
  
  void notifyObservers(DirectFileTransition transition){
    for (var observer in observers) {
      observer.notify(transition);
    }
  }

  void removeObserver(DirectFileObserver observer) {
    observers.removeWhere((element) => element == observer);
  }

  List<DirectFileObserver> getObservers() => observers;

  DirectFileObserver getObserver() => observers[0];

}