import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';


class DirectFileTransition {
  late final TransitionType _type;
  final DirectFile _transitionFile;
  late int bucketFoundId = -1;
  late int bucketPositionInHashTable = -1;
  late int bucketOverflowedId = -1;
  late int bucketCreatedId = -1;
  late int bucketReorganizedId = -1;
  late int bucketReorganizedInsertRecordId = -1;

  TransitionType get type => _type;
  DirectFile get transitionFile => _transitionFile;
 
  DirectFileTransition(
      this._type,
      this._transitionFile,
      this.bucketPositionInHashTable);

  DirectFileTransition.bucketFound(this._transitionFile, this.bucketPositionInHashTable){
    _type = TransitionType.bucketFound;
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.bucketOverflowed(this._transitionFile, this.bucketPositionInHashTable){
    _type = TransitionType.bucketOverflowed;
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len) == bucketPositionInHashTable){
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

  DirectFileTransition.bucketReorganized(this._transitionFile, this.bucketReorganizedId){
    _type = TransitionType.bucketReorganized; 
  }

  DirectFileTransition.bucketReorganizedInsertRecord(this._transitionFile, this.bucketPositionInHashTable, this.bucketReorganizedInsertRecordId){
    _type = TransitionType.bucketReorganizedInsertRecord; 
    if (_transitionFile != Null && bucketPositionInHashTable.clamp(0,_transitionFile.getDirectory().len) == bucketPositionInHashTable){
      bucketFoundId = _transitionFile.getDirectory().hash[bucketPositionInHashTable];
    }else {
      bucketFoundId = -1;
    }
  }

  DirectFileTransition.hashTableDuplicateSize(this._transitionFile, this.bucketOverflowedId){
    _type = TransitionType.hashTableDuplicateSize;
    bucketFoundId = bucketOverflowedId;
  }
     
  /*
  ExternalSortTransition.indexArrayBuilt( this._fragments,
      this._buffer, this._unsortedFilePointer, this._indexArray)
      : _type = TransitionType.indexArrayBuilt;
  ExternalSortTransition.indexArrayFrozen(
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex)
      : _type = TransitionType.indexArrayFrozen;
  ExternalSortTransition.replacedEntry(
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex,
      this._bufferPositionToReplace)
      : _type = TransitionType.replacedEntry;
  ExternalSortTransition.frozenEntry(
      this._fragments,
      this._buffer,
      this._unsortedFilePointer,
      this._indexArray,
      this._fragmentIndex,
      this._bufferPositionToReplace)
      : _type = TransitionType.frozenEntry;
  ExternalSortTransition.fileToSortEnded(
    this._fragments,
  ): _type = TransitionType.fileToSortEnded;
  */
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
  bucketReorganizedInsertRecord,
  recordSaved,
  recordDeleted,
  recordFound,
  hashTableDuplicateSize,
  hashTableReduceSize,
  hashTableUpdated;

  @override
  String toString() => name;
}
