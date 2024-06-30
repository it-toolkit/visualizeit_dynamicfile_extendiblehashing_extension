import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';

class FreedListTransition extends Transition {
  final List<int> _transitionFreedList;

  late int bucketFreedId = -1;

  FreedListTransition(this._transitionFreedList) : super(TransitionType.freedListOperation);

  FreedListTransition.bucketFreed(this._transitionFreedList,this.bucketFreedId):super(TransitionType.bucketFreed) ;

  int getSize() => _transitionFreedList.length;
  List<int> getFreedList() => _transitionFreedList;
  
}