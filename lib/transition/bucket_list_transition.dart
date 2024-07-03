import 'package:visualizeit_dynamicfile_extendiblehashing_extension/exception/register_position_out_of_bounds.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';


class BucketListTransition extends Transition {
  final List<Bucket> _transitionBucketList;
  late int _bucketSize;

  late int bucketFoundId = -1;
  late int bucketPositionInHashTable = -1;
  late int bucketOverflowedId = -1;
  late int bucketCreatedId = -1;
  late int bucketReorganizedId = -1;
  late int bucketReorganizedInsertRecordId = -1;
  late int bucketRecordSavedId = -1;
  late int bucketEmptyId = -1;
  late int bucketFreedId = -1;
  BaseRegister? recordFound;
  BaseRegister? recordSaved;
  BaseRegister? recordDeleted;
  late int recordDeletedPositionInBucket = -1;
  late TransitionType currentTransitionType;

  BucketListTransition(super._type, this._bucketSize, this._transitionBucketList);
  
  List<Bucket> getBucketList() => _transitionBucketList;

  BucketListTransition.bucketFound(this._transitionBucketList, this.bucketFoundId):super(TransitionType.bucketFound);

  BucketListTransition.bucketOverflowed(this._transitionBucketList, this.bucketFoundId):super(TransitionType.bucketOverflowed){
    bucketOverflowedId = bucketFoundId;
  }

  BucketListTransition.bucketCreated(this._transitionBucketList, this.bucketCreatedId):super(TransitionType.bucketCreated);

  BucketListTransition.bucketFreed(this._transitionBucketList, this.bucketFreedId):super(TransitionType.bucketFreed){
    bucketFoundId = bucketFreedId;
  }

  BucketListTransition.bucketEmpty(this._transitionBucketList, this.bucketEmptyId):super(TransitionType.bucketEmpty){
    bucketFoundId = bucketEmptyId;
  }

  BucketListTransition.usingBucketFreed(this._transitionBucketList, this.bucketFreedId):super(TransitionType.bucketFreed){
    bucketFoundId = bucketFreedId;
  }
  
  BucketListTransition.bucketReorganized(this._transitionBucketList, this.bucketReorganizedId):super(TransitionType.bucketReorganized);

  BucketListTransition.bucketUpdateHashingBits(this._transitionBucketList, int bucketId , this.currentTransitionType)
  :super(TransitionType.bucketUpdateHashingBits){
    if (currentTransitionType.name == "bucketOverflowed"){
      bucketOverflowedId = bucketId;
    }else if (currentTransitionType.name == "bucketCreated") {
      bucketCreatedId = bucketId;
    }else if ( currentTransitionType.name == "replacemmentBucketFound" || currentTransitionType.name == "usingBucketFreed"){  
        bucketFoundId = bucketId;
    }
  }

  BucketListTransition.recordSaved(this._transitionBucketList, this.bucketFoundId, this.recordSaved):super(TransitionType.recordSaved);

  BucketListTransition.recordFound(this._transitionBucketList, this.bucketFoundId, this.recordFound):super(TransitionType.recordFound);

  BucketListTransition.recordDeleted(this._transitionBucketList, this.recordDeletedPositionInBucket, this.recordDeleted, this.bucketFoundId, this._bucketSize):super(TransitionType.recordDeleted){
    if (recordDeletedPositionInBucket.clamp(0,_bucketSize-1) != recordDeletedPositionInBucket){
      throw RegisterOutOfBoundsException("The position in bucket that you provided is not valid");
    }
  }
 
}

