import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/directory.dart';

class DirectoryTransition extends Transition {
  final Directory? _transitionDirectory;
  late TransitionType currentType = TransitionType.fileIsEmpty;
  
  late int bucketOverflowedId = -1;
  late int bucketCreatedId = -1;
  late int hashTablePosition = -1;
  late int hashTablePosition1 = -1;
  late int hashTablePosition2 = -1;
 
  Directory? getTransition() => _transitionDirectory;

  DirectoryTransition(this._transitionDirectory) : super(TransitionType.fileIsEmpty);

  DirectoryTransition.hashTableUpdated(this._transitionDirectory, int bucketId, this.hashTablePosition, this.currentType ):super(TransitionType.hashTableOperation){
  
    if (currentType.name == "bucketCreated"){
      bucketCreatedId = bucketId;
    }
  }

  DirectoryTransition.hashTableReviewed(this._transitionDirectory, int bucketId, this.hashTablePosition1, this.hashTablePosition2, this.currentType ):super(TransitionType.hashTableReviewed);

  DirectoryTransition.hashTablePointedBucket(this._transitionDirectory, this.hashTablePosition, this.currentType ):super(TransitionType.hashTableOperation){
    if (currentType.name == "bucketCreated"){
      bucketCreatedId = hashTablePosition;
    } else if (currentType.name == "bucketOverflowed")
    {
      bucketOverflowedId = hashTablePosition;
    }
  }

}
