import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';

//class DirectFileObserver<T extends Comparable<T>> {
class DirectFileObserver {
  final List<DirectFileTransition> _transitions = [];

  List<DirectFileTransition> get transitions => _transitions;

  DirectFileObserver();

  void notify(DirectFileTransition transition) {
    _transitions.add(transition);
  }
}