import 'package:flutter/cupertino.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/exception/register_position_out_of_bounds.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/directory.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';


abstract class Transition{
  final TransitionType _type;

  Transition(this._type);

  TransitionType get type => _type;

  @override
  String toString() {
    return type.toString();
  }
}

/*
class DirectFileTransition {
  late final DirectFile? _transitionFile;
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
  late TransitionType currentTransitionType;

  late DirectoryTransition _transitionDirectory;

  DirectFile? get transitionFile => _transitionFile;
  bool get isRecordFound => recordFound != null ? true : false;
  set transitionType(TransitionType transitionType) => currentTransitionType = transitionType;
  Directory? getDirectory() => _transitionFile?.getDirectory();
 
  DirectFileTransition(
      super._type,
      [this._transitionFile]);

  DirectFileTransition.bucketFound(this._transitionFile, this.bucketPositionInHashTable):super(TransitionType.bucketFound){
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile!.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.bucketOverflowed(this._transitionFile, this.bucketPositionInHashTable):super(TransitionType.bucketOverflowed){
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile!.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
    bucketOverflowedId = bucketFoundId;
  }

  DirectFileTransition.bucketCreated(this._transitionFile, this.bucketPositionInHashTable, this.bucketCreatedId):super(TransitionType.bucketCreated){
    /*if (_transitionFile != Null ){
      bucketFoundId = bucketCreatedId;
    }else {
      bucketFoundId = -1;
    }*/  
  }

  DirectFileTransition.bucketFreed(this._transitionFile, this.bucketFreedId):super(TransitionType.bucketFreed){
    bucketFoundId = bucketFreedId;
  }

  DirectFileTransition.bucketEmpty(this._transitionFile, this.bucketEmptyId):super(TransitionType.bucketEmpty){
    bucketFoundId = bucketEmptyId;
  }

  DirectFileTransition.usingBucketFreed(this._transitionFile, this.bucketFreedId):super(TransitionType.bucketFreed){
    bucketFoundId = bucketFreedId;
  }
  
  DirectFileTransition.bucketReorganized(this._transitionFile, this.bucketReorganizedId):super(TransitionType.bucketReorganized);

  DirectFileTransition.bucketUpdateHashingBits(this._transitionFile, this.bucketPositionInHashTable, int bucketId , this.currentTransitionType)
  :super(TransitionType.bucketUpdateHashingBits){
    if (bucketPositionInHashTable !=-1 ){
      if ( _transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile!.getDirectory().len-1) == bucketPositionInHashTable){
        bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
      }else {
        bucketFoundId = -1;
      }
    }

    if (currentTransitionType.name == "bucketOverflowed"){
      bucketOverflowedId = bucketId;
    }else if (currentTransitionType.name == "bucketCreated") {
      bucketCreatedId = bucketId;
    }else if ( currentTransitionType.name == "replacemmentBucketFound"){  
      bucketFoundId = bucketId;
    }
  }

/*
  DirectFileTransition.hashTableDuplicateSize(this._transitionFile, this.bucketPositionInHashTable, this.bucketCreatedId):super(TransitionType.hashTableDuplicateSize){
  }

  //TODO: REVIEW this
  DirectFileTransition.hashTableReduceSize(this._transitionFile, this.bucketOverflowedId):super(TransitionType.hashTableReduceSize){
    bucketFoundId = bucketOverflowedId;
  }
*/
  DirectFileTransition.hashTableUpdated(this._transitionFile, Directory transitionDirectory, int bucketId,this.hashTablePositionToUpdate, this.currentTransitionType):super(TransitionType.hashTableUpdated){
    _transitionDirectory = DirectoryTransition.hashTableUpdated(transitionDirectory, bucketId, hashTablePositionToUpdate, currentTransitionType);
  }

  DirectFileTransition.recordSaved(this._transitionFile, this.bucketPositionInHashTable, this.recordSaved):super(TransitionType.recordSaved){
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile!.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.recordFound(this._transitionFile, this.bucketPositionInHashTable, this.recordFound):super(TransitionType.recordFound){
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile!.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.recordDeleted(this._transitionFile, this.recordDeletedPositionInBucket, this.recordDeleted, this.bucketPositionInHashTable):super(TransitionType.recordDeleted){
    if (recordDeletedPositionInBucket.clamp(0,_transitionFile!.bucketRecordCapacity()-1) != recordDeletedPositionInBucket){
      throw RegisterOutOfBoundsException("The position in bucket that you provided is not valid");
    }
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.fileIsEmpty(this._transitionFile):super(TransitionType.fileIsEmpty) {
  }

  @override
  String toString() {
    
    return type.toString();
  }

}
*/


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

  BucketListTransition(super._type, this._transitionBucketList);
  
  List<Bucket> getBucketList() => _transitionBucketList;
  int bucketRecordCapacity()=> _bucketSize;

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
    }else if ( currentTransitionType.name == "replacemmentBucketFound"){  
      bucketFoundId = bucketId;
    }
  }

  BucketListTransition.recordSaved(this._transitionBucketList, this.bucketFoundId, this.recordSaved):super(TransitionType.recordSaved);

  BucketListTransition.recordFound(this._transitionBucketList, this.bucketFoundId, this.recordFound):super(TransitionType.recordFound);

  BucketListTransition.recordDeleted(this._transitionBucketList, this.recordDeletedPositionInBucket, this.recordDeleted, this.bucketFoundId, this._bucketSize):super(TransitionType.recordDeleted){
    if (recordDeletedPositionInBucket.clamp(0,bucketRecordCapacity()-1) != recordDeletedPositionInBucket){
      throw RegisterOutOfBoundsException("The position in bucket that you provided is not valid");
    }
  }
 
}

class DirectoryTransition extends Transition {
  final Directory? _transitionDirectory;
  late TransitionType currentType;
  
  late int bucketOverflowedId = -1;
  late int bucketCreatedId = -1;
  late int hashTablePosition = -1;
 
  Directory? getTransition() => _transitionDirectory;

  DirectoryTransition(this._transitionDirectory) : super(TransitionType.fileIsEmpty);

  DirectoryTransition.hashTableUpdated(this._transitionDirectory, int bucketId, this.hashTablePosition, this.currentType ):super(TransitionType.hashTableOperation){
  
    if (currentType.name == "bucketCreated"){
      bucketCreatedId = bucketId;
    }
  }

  DirectoryTransition.hashTablePointedBucket(this._transitionDirectory, this.hashTablePosition, this.currentType ):super(TransitionType.hashTableOperation){
    if (currentType.name == "bucketCreated"){
      bucketCreatedId = hashTablePosition;
    } else if (currentType.name == "bucketOverflowed")
    {
      bucketOverflowedId = hashTablePosition;
    }
  }

}

class FreedListTransition extends Transition {
  final List<int> _transitionFreedList;

  late int bucketFreedId = -1;

  FreedListTransition(this._transitionFreedList) : super(TransitionType.freedListOperation);

  FreedListTransition.bucketFreed(this._transitionFreedList,this.bucketFreedId):super(TransitionType.bucketFreed) ;

  int getSize() => _transitionFreedList.length;
  List<int> getFreedList() => _transitionFreedList;
  
}

class DirectFileTransition extends Transition {
  late DirectFile _transitionFile;
  late BucketListTransition? _bucketListTransition;
  late DirectoryTransition? _directoryTransition;
  late FreedListTransition _freedListTransition;

  DirectFileTransition(super._type);

  DirectFile? getTransitionFile() => _transitionFile;
  BucketListTransition? getBucketListTransition() => _bucketListTransition;
  DirectoryTransition? getDirectoryTransition() => _directoryTransition;
  FreedListTransition? getFreedListTransition() => _freedListTransition;

  DirectFileTransition.bucketFound(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketFoundId, int hashTableIndex ):super(TransitionType.bucketFound){
    _bucketListTransition = BucketListTransition.bucketFound(bucketList, bucketFoundId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.hashTablePointedBucket);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.bucketFoundWithModel(this._transitionFile, int bucketFoundId, int hashTableIndex ):super(TransitionType.bucketFound){
    _bucketListTransition = BucketListTransition.bucketFound(_transitionFile.getFileContent(), bucketFoundId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.hashTablePointedBucket);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.bucketOverflowed(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex):super(TransitionType.bucketOverflowed){
    _bucketListTransition = BucketListTransition.bucketOverflowed(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketOverflowed);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.bucketOverflowedWithModel(this._transitionFile, int bucketId, int hashTableIndex):super(TransitionType.bucketOverflowed){
    _bucketListTransition = BucketListTransition.bucketOverflowed(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketOverflowed);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
    
  }
  
  DirectFileTransition.bucketCreated(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex):super(TransitionType.bucketCreated){
    _bucketListTransition = BucketListTransition.bucketCreated(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketCreated);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
  }

  DirectFileTransition.bucketCreatedWithModel(this._transitionFile, int bucketId, int hashTableIndex):super(TransitionType.bucketCreated){
    _bucketListTransition = BucketListTransition.bucketCreated(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketCreated);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
  }

  DirectFileTransition.bucketFreed(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.bucketFreedWithModel(this._transitionFile, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition.bucketFreed(_transitionFile!.getFreedList(), bucketId);
  }

  DirectFileTransition.bucketEmpty(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId):super(TransitionType.bucketEmpty){
    _bucketListTransition = BucketListTransition.bucketEmpty(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketEmpty);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.bucketEmptyWithModel(this._transitionFile, int bucketId):super(TransitionType.bucketEmpty){
    _bucketListTransition = BucketListTransition.bucketEmpty(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketEmpty);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.usingBucketFreed(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition.bucketFreed(_transitionFile!.getFreedList(),bucketId);
  }

  DirectFileTransition.usingBucketFreedWithModel(this._transitionFile, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition.bucketFreed(_transitionFile.getFreedList(),bucketId);
  }

  DirectFileTransition.bucketReorganized(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketReorganizedId):super(TransitionType.bucketReorganized){
    _bucketListTransition = BucketListTransition.bucketReorganized(bucketList, bucketReorganizedId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketReorganized);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.bucketReorganizedWithModel(this._transitionFile, int bucketReorganizedId):super(TransitionType.bucketReorganized){
    _bucketListTransition = BucketListTransition.bucketReorganized(_transitionFile.getFileContent(), bucketReorganizedId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketReorganized);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
  }
  
  DirectFileTransition.bucketUpdateHashingBits(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, TransitionType currentTransition):super(TransitionType.bucketUpdateHashingBits){
    _bucketListTransition = BucketListTransition.bucketUpdateHashingBits(bucketList, bucketId, currentTransition);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketUpdateHashingBits);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());

  }

  DirectFileTransition.bucketUpdateHashingBitsWithModel(this._transitionFile, int bucketId, TransitionType currentTransition):super(TransitionType.bucketUpdateHashingBits){
    _bucketListTransition = BucketListTransition.bucketUpdateHashingBits(_transitionFile.getFileContent(), bucketId, currentTransition);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketUpdateHashingBits);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());

  }

  DirectFileTransition.hashTableDuplicateSize(this._transitionFile,List<Bucket> bucketList, Directory dir):super(TransitionType.hashTableDuplicateSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketCreated, _transitionFile!.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.hashTableDuplicateSize);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.hashTableDuplicateSizeWithModel(this._transitionFile):super(TransitionType.hashTableDuplicateSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketCreated, _transitionFile!.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.hashTableDuplicateSize);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.hashTableReduceSize(this._transitionFile,List<Bucket> bucketList, Directory dir):super(TransitionType.hashTableReduceSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketOverflowed, _transitionFile!.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.hashTableReduceSize);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.hashTableReduceSizeWithModel(this._transitionFile):super(TransitionType.hashTableReduceSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketOverflowed, _transitionFile!.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.hashTableReduceSize);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  
  }

  DirectFileTransition.hashTableUpdated(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketId, int hashTablePositionToUpdate ,TransitionType currentTransitionType):super(TransitionType.hashTableUpdated){
    
    _bucketListTransition = BucketListTransition(TransitionType.bucketFound, bucketList);
    _directoryTransition = DirectoryTransition.hashTableUpdated(dir, bucketId, hashTablePositionToUpdate, currentTransitionType);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());

  }
   
  DirectFileTransition.recordSaved(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex, BaseRegister recordSaved):super(TransitionType.recordSaved){
    _bucketListTransition = BucketListTransition.recordSaved(bucketList, bucketId, recordSaved);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.recordSavedWithModel(this._transitionFile, int bucketId, int hashTableIndex, BaseRegister recordSaved):super(TransitionType.recordSaved){
    _bucketListTransition = BucketListTransition.recordSaved(_transitionFile.getFileContent(), bucketId, recordSaved);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
  }
 
  DirectFileTransition.recordFound(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex, BaseRegister recordToFound):super(TransitionType.recordFound){
    _bucketListTransition = BucketListTransition.recordFound(bucketList, bucketId, recordToFound);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.recordDeleted(this._transitionFile,List<Bucket> bucketList, Directory dir, int recordDeletedPositionInBucket, int bucketId, int hashTableIndex, BaseRegister recordToDelete):super(TransitionType.recordDeleted){
    _bucketListTransition = BucketListTransition.recordDeleted(bucketList, recordDeletedPositionInBucket, recordToDelete, bucketId, _transitionFile!.bucketRecordCapacity());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir,  hashTableIndex, TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
  }

  DirectFileTransition.fileIsEmpty(this._transitionFile):super(TransitionType.fileIsEmpty) {
    _bucketListTransition = BucketListTransition(TransitionType.fileIsEmpty, []);
    _directoryTransition = DirectoryTransition(null);
    _freedListTransition = FreedListTransition([]);
  }
  /*
  DirectFileTransition.recordDeleted(this._transitionFile, this.recordDeletedPositionInBucket, this.recordDeleted, this.bucketPositionInHashTable):super(TransitionType.recordDeleted){
    if (recordDeletedPositionInBucket.clamp(0,_transitionFile!.bucketRecordCapacity()-1) != recordDeletedPositionInBucket){
      throw RegisterOutOfBoundsException("The position in bucket that you provided is not valid");
    }
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len-1) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.fileIsEmpty(this._transitionFile):super(TransitionType.fileIsEmpty) {
  }
*/

}


enum TransitionType {
  bucketFound,
  bucketOverflowed,
  bucketCreated,
  bucketFreed,
  bucketEmpty,
  bucketReorganized,
  bucketUpdateHashingBits,
  usingBucketFreed,
  replacemmentBucketFound,
  recordSaved,
  recordDeleted,
  recordFound,
  hashTableDuplicateSize,
  hashTableReduceSize,
  hashTableUpdated,
  hashTableOperation,
  hashTablePointedBucket,
  fileIsEmpty,
  freedListOperation;

  @override
  String toString() => name;
}
