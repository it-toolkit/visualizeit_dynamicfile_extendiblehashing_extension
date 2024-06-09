import 'package:visualizeit_dynamicfile_extendiblehashing/exception/register_position_out_of_bounds.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';


class DirectFileTransition {
  late final TransitionType _type;
  final DirectFile _transitionFile;
  late int bucketFoundId = -1;
  late int bucketPositionInHashTable = -1;
  late int bucketOverflowedId = -1;
  late int bucketCreatedId = -1;
  late int bucketReorganizedId = -1;
  late int bucketReorganizedInsertRecordId = -1;
  late int bucketRecordSavedId = -1;
  late int bucketEmptyId = -1;
  late int bucketFreedId = -1;
  late int hashTablePositionToUpdate = -1;
  BaseRegister? recordFound;
  BaseRegister? recordSaved;
  BaseRegister? recordDeleted;
  late int recordDeletedPositionInBucket = -1;
  late final TransitionType currentTransitionType;

  TransitionType get type => _type;
  DirectFile get transitionFile => _transitionFile;
  bool get isRecordFound => recordFound != null ? true : false;
 
  DirectFileTransition(
      this._type,
      this._transitionFile,
      this.bucketPositionInHashTable);

  DirectFileTransition.bucketFound(this._transitionFile, this.bucketPositionInHashTable){
    _type = TransitionType.bucketFound;
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.bucketOverflowed(this._transitionFile, this.bucketPositionInHashTable){
    _type = TransitionType.bucketOverflowed;
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
    bucketOverflowedId = bucketFoundId;
  }

  DirectFileTransition.bucketCreated(this._transitionFile, this.bucketPositionInHashTable, this.bucketCreatedId){
    _type = TransitionType.bucketCreated;
    if (_transitionFile != Null ){
      bucketFoundId = bucketCreatedId;
    }else {
      bucketFoundId = -1;
    }
     
  }

  DirectFileTransition.bucketFreed(this._transitionFile, this.bucketFreedId){
    _type = TransitionType.bucketFreed; 
    bucketFoundId = bucketFreedId;
  }

  DirectFileTransition.bucketEmpty(this._transitionFile, this.bucketEmptyId){
    _type = TransitionType.bucketEmpty; 
    bucketFoundId = bucketEmptyId;
  }
  
  DirectFileTransition.bucketReorganized(this._transitionFile, this.bucketReorganizedId){
    _type = TransitionType.bucketReorganized; 
  }

  DirectFileTransition.bucketUpdateHashingBits(this._transitionFile, this.bucketPositionInHashTable, this.currentTransitionType){
    _type = TransitionType.bucketUpdateHashingBits; 
     if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
    if (this.currentTransitionType.name == "bucketOverflowed"){
      bucketOverflowedId = bucketFoundId;
    }else if (this.currentTransitionType.name == "bucketCreated") {
      bucketCreatedId = bucketFoundId;
    }
  }

  DirectFileTransition.hashTableDuplicateSize(this._transitionFile, this.bucketOverflowedId){
    _type = TransitionType.hashTableDuplicateSize;
    bucketFoundId = bucketOverflowedId;
  }

  //TODO: REVIEW this
  DirectFileTransition.hashTableReduceSize(this._transitionFile, this.bucketOverflowedId){
    _type = TransitionType.hashTableReduceSize;
    bucketFoundId = bucketOverflowedId;
  }

  DirectFileTransition.hashTableUpdated(this._transitionFile, this.bucketFoundId, this.hashTablePositionToUpdate, this.currentTransitionType){
    _type = TransitionType.hashTableUpdated;
    if (currentTransitionType.name == "bucketCreated"){
      bucketCreatedId = bucketFoundId;
    }
    
  }


  DirectFileTransition.recordSaved(this._transitionFile, this.bucketPositionInHashTable, this.recordSaved){
    _type = TransitionType.recordSaved; 
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.recordFound(this._transitionFile, this.bucketPositionInHashTable, this.recordFound){
    _type = TransitionType.recordFound; 
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.recordDeleted(this._transitionFile, this.recordDeletedPositionInBucket, this.recordDeleted, this.bucketPositionInHashTable){
    _type = TransitionType.recordDeleted;
    if (recordDeletedPositionInBucket.clamp(0,_transitionFile.bucketRecordCapacity()-1) != recordDeletedPositionInBucket){
      throw RegisterOutOfBoundsException("The position in bucket that you provided is not valid");
    }
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  @override
  String toString() {
    
    return type.toString();
  }

}

enum TransitionType {
  bucketFound,
  bucketOverflowed,
  bucketCreated,
  bucketFreed,
  bucketEmpty,
  bucketReorganized,
  bucketUpdateHashingBits,
  recordSaved,
  recordDeleted,
  recordFound,
  hashTableDuplicateSize,
  hashTableReduceSize,
  hashTableUpdated;

  @override
  String toString() => name;
}
