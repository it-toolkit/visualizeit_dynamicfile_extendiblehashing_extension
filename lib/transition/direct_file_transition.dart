import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/bucket_list_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/directory_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/freed_list_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/directory.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';


class DirectFileTransition extends Transition {
  late DirectFile _transitionFile;
  late BucketListTransition? _bucketListTransition;
  late DirectoryTransition? _directoryTransition;
  late FreedListTransition _freedListTransition;
  late String? _transitionMessage;

  DirectFileTransition(super._type);

  DirectFile? getTransitionFile() => _transitionFile;
  BucketListTransition? getBucketListTransition() => _bucketListTransition;
  DirectoryTransition? getDirectoryTransition() => _directoryTransition;
  FreedListTransition? getFreedListTransition() => _freedListTransition;
  String? getMessage() => _transitionMessage;

  DirectFileTransition.findingBucketWithModel(this._transitionFile, int value, int hashTableLen, int index ):super(TransitionType.findingBucket){
    _bucketListTransition = BucketListTransition.bucketFound(_transitionFile.getFileContent(), -1);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.findingBucket);
    _freedListTransition = FreedListTransition(_transitionFile!.getFreedList());
    _transitionMessage = "Finding bucket number, calculating $value mod (T = $hashTableLen) = $index";
  }

  DirectFileTransition.bucketFound(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketFoundId, int hashTableIndex ):super(TransitionType.bucketFound){
    _bucketListTransition = BucketListTransition.bucketFound(bucketList, bucketFoundId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.hashTablePointedBucket);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket was found";
  }

  DirectFileTransition.bucketFoundWithModel(this._transitionFile, int bucketFoundId, int hashTableIndex ):super(TransitionType.bucketFound){
    _bucketListTransition = BucketListTransition.bucketFound(_transitionFile.getFileContent(), bucketFoundId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket was found";
  }

  DirectFileTransition.replacementBucketFoundWithModel(this._transitionFile, int bucketFoundId, int hashTableIndex ):super(TransitionType.replacemmentBucketFound){
    _bucketListTransition = BucketListTransition.bucketFound(_transitionFile.getFileContent(), bucketFoundId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.replacemmentBucketFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The replacement bucket was found";
  }

  DirectFileTransition.bucketOverflowed(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex):super(TransitionType.bucketOverflowed){
    _bucketListTransition = BucketListTransition.bucketOverflowed(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketOverflowed);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "Bucket overflowed";
  }

  DirectFileTransition.bucketOverflowedWithModel(this._transitionFile, int bucketId, int hashTableIndex):super(TransitionType.bucketOverflowed){
    _bucketListTransition = BucketListTransition.bucketOverflowed(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketOverflowed);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "Bucket overflowed";
    
  }
  
  DirectFileTransition.bucketCreated(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex):super(TransitionType.bucketCreated){
    _bucketListTransition = BucketListTransition.bucketCreated(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketCreated);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "A new bucket is created";
  }

  DirectFileTransition.bucketCreatedWithModel(this._transitionFile, int bucketId, int hashTableIndex):super(TransitionType.bucketCreated){
    _bucketListTransition = BucketListTransition.bucketCreated(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketCreated);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "A new bucket is created";
  }

  DirectFileTransition.bucketFreed(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket is being freed, and is added to the freed bucket list";
  }

  DirectFileTransition.bucketFreedWithModel(this._transitionFile, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition.bucketFreed(_transitionFile!.getFreedList(), bucketId);
    _transitionMessage = "The bucket is being freed, and is added to the freed bucket list";
  }

  DirectFileTransition.bucketEmpty(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId):super(TransitionType.bucketEmpty){
    _bucketListTransition = BucketListTransition.bucketEmpty(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketEmpty);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket is empty";
  }

  DirectFileTransition.bucketEmptyWithModel(this._transitionFile, int bucketId):super(TransitionType.bucketEmpty){
    _bucketListTransition = BucketListTransition.bucketEmpty(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketEmpty);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket must be rewrite it as empty";
  }

  DirectFileTransition.usingBucketFreed(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(bucketList, bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition.bucketFreed(_transitionFile.getFreedList(),bucketId);
    _transitionMessage = "It can be used a bucket from the freed bucket list";
  }

  DirectFileTransition.usingBucketFreedWithModel(this._transitionFile, int bucketId):super(TransitionType.bucketFreed){
    _bucketListTransition = BucketListTransition.bucketFreed(_transitionFile.getFileContent(), bucketId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketFreed);
    _freedListTransition = FreedListTransition.bucketFreed(_transitionFile.getFreedList(),bucketId);
    _transitionMessage = "It can be used a bucket from the freed bucket list. The bucket $bucketId will be removed from list";
  }

  DirectFileTransition.bucketReorganized(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketReorganizedId):super(TransitionType.bucketReorganized){
    _bucketListTransition = BucketListTransition.bucketReorganized(bucketList, bucketReorganizedId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketReorganized);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket must be reorganized";
  }

  DirectFileTransition.bucketReorganizedWithModel(this._transitionFile, int bucketReorganizedId):super(TransitionType.bucketReorganized){
    _bucketListTransition = BucketListTransition.bucketReorganized(_transitionFile.getFileContent(), bucketReorganizedId);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketReorganized);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The bucket must be reorganized";
  }
  
  DirectFileTransition.bucketUpdateHashingBits(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, TransitionType currentTransition):super(TransitionType.bucketUpdateHashingBits){
    _bucketListTransition = BucketListTransition.bucketUpdateHashingBits(bucketList, bucketId, currentTransition);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.bucketUpdateHashingBits);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    String message = ""; 
    if (currentTransition.name == "bucketOverflowed"){
      message = "The overflowed bucket must update the hashing bits";
    }else if (currentTransition.name == "bucketCreated") {
      message = "The created bucket must have the same hashing bits as the overflowed bucket";
    }else if ( currentTransition.name == "replacemmentBucketFound"){  
      message = "The bucket must update the hashing bits";
    }
    _transitionMessage = message;
  }

  DirectFileTransition.bucketUpdateHashingBitsWithModel(this._transitionFile, int bucketId, TransitionType currentTransition):super(TransitionType.bucketUpdateHashingBits){
    _bucketListTransition = BucketListTransition.bucketUpdateHashingBits(_transitionFile.getFileContent(), bucketId, currentTransition);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.bucketUpdateHashingBits);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    String message = ""; 
    if (currentTransition.name == "bucketOverflowed"){
      message = "The overflowed bucket must update the hashing bits";
    }else if (currentTransition.name == "bucketCreated") {
      message = "The created bucket must have the same hashing bits as the overflowed bucket";
    }else if ( currentTransition.name == "replacemmentBucketFound"){  
      message = "The bucket must update the hashing bits";
    }
    _transitionMessage = message;
  }

  DirectFileTransition.hashTableDuplicateSize(this._transitionFile,List<Bucket> bucketList, Directory dir):super(TransitionType.hashTableDuplicateSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketCreated,_transitionFile.bucketRecordCapacity() ,_transitionFile.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.hashTableDuplicateSize);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "Hashing bits from bucket are equal to log2(T) then the hash table must be duplicated";
  }

  DirectFileTransition.hashTableDuplicateSizeWithModel(this._transitionFile):super(TransitionType.hashTableDuplicateSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketCreated,_transitionFile.bucketRecordCapacity() , _transitionFile.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.hashTableDuplicateSize);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "Hashing bits from bucket are equal to log2(T) then the hash table must be duplicated";
  }

  DirectFileTransition.hashTableReduceSize(this._transitionFile,List<Bucket> bucketList, Directory dir):super(TransitionType.hashTableReduceSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketOverflowed, _transitionFile.bucketRecordCapacity() , _transitionFile.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, -1 , TransitionType.hashTableReduceSize);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The hash table must be reduced";
  }

  DirectFileTransition.hashTableReduceSizeWithModel(this._transitionFile):super(TransitionType.hashTableReduceSize){
    _bucketListTransition = BucketListTransition(TransitionType.bucketOverflowed, _transitionFile.bucketRecordCapacity() ,_transitionFile.getFileContent());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), -1 , TransitionType.hashTableReduceSize);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The hash table must be reduced, the first half part is equal that the second half part";
  }

  DirectFileTransition.hashTableUpdated(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketId, int hashTablePositionToUpdate ,TransitionType currentTransitionType):super(TransitionType.hashTableUpdated){
    _bucketListTransition = BucketListTransition(TransitionType.bucketFound,_transitionFile.bucketRecordCapacity() , bucketList);
    _directoryTransition = DirectoryTransition.hashTableUpdated(dir, bucketId, hashTablePositionToUpdate, currentTransitionType);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The hash table must be updated";
  }

  DirectFileTransition.hashTableCircularUpdated(this._transitionFile, List<Bucket> bucketList, Directory dir, int bucketId, int hashTablePositionToUpdate,int init, int jump,TransitionType currentTransitionType):super(TransitionType.hashTableUpdated){
    _bucketListTransition = BucketListTransition(TransitionType.bucketFound,_transitionFile.bucketRecordCapacity() , bucketList);
    _directoryTransition = DirectoryTransition.hashTableUpdated(dir, bucketId, hashTablePositionToUpdate, currentTransitionType);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The hash table must be updated from position $init in circular steps of size $jump";
  }

  DirectFileTransition.hashTableReviewed(this._transitionFile, List<Bucket> bucketList, Directory dir,int bucketId, int hashTablePositionToCheck1,int hashTablePositionToCheck2,int init, int jump,TransitionType currentTransitionType):super(TransitionType.hashTableReviewed){
    _bucketListTransition = BucketListTransition(TransitionType.bucketFound,_transitionFile.bucketRecordCapacity() , bucketList);
    _directoryTransition = DirectoryTransition.hashTableReviewed(dir, bucketId, hashTablePositionToCheck1, hashTablePositionToCheck2, currentTransitionType);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());

    if (currentTransitionType.name == "hashTableReviewedSameBucket"){
      _transitionMessage = "The position $hashTablePositionToCheck1 and $hashTablePositionToCheck2 in hash table are pointing to the same bucket. This bucket will be the replacement and the bucket $bucketId can be freed";
    }else{
      _transitionMessage = "The position $hashTablePositionToCheck1 and $hashTablePositionToCheck2 in hash table are not pointing to the same bucket. The bucket $bucketId must be write it as Empty";
    }
    
  }
   
  DirectFileTransition.recordSaved(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex, BaseRegister recordSaved):super(TransitionType.recordSaved){
    _bucketListTransition = BucketListTransition.recordSaved(bucketList, bucketId, recordSaved);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record is saved in the bucket";
  }

  DirectFileTransition.recordSavedWithModel(this._transitionFile, int bucketId, int hashTableIndex, BaseRegister recordSaved):super(TransitionType.recordSaved){
    _bucketListTransition = BucketListTransition.recordSaved(_transitionFile.getFileContent(), bucketId, recordSaved);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.bucketFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record is saved in the bucket";
  }
 
  DirectFileTransition.recordFound(this._transitionFile,List<Bucket> bucketList, Directory dir, int bucketId, int hashTableIndex, BaseRegister recordToFound):super(TransitionType.recordFound){
    _bucketListTransition = BucketListTransition.recordFound(bucketList, bucketId, recordToFound);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir, hashTableIndex , TransitionType.recordFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record was found in the bucket";
  }
  
  DirectFileTransition.recordFoundWithModel(this._transitionFile, int bucketId, int hashTableIndex, BaseRegister recordToFound):super(TransitionType.recordFound){
    _bucketListTransition = BucketListTransition.recordFound(_transitionFile.getFileContent(), bucketId, recordToFound);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.recordFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record was found in the bucket";
  }

    DirectFileTransition.recordNotFoundWithModel(this._transitionFile, int bucketId, int hashTableIndex, BaseRegister recordToFound):super(TransitionType.recordNotFound){
    _bucketListTransition = BucketListTransition.recordFound(_transitionFile.getFileContent(), bucketId, recordToFound);
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(), hashTableIndex , TransitionType.recordNotFound);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record was not found";
  }

  DirectFileTransition.recordDeleted(this._transitionFile,List<Bucket> bucketList, Directory dir, int recordDeletedPositionInBucket, int bucketId, int hashTableIndex, BaseRegister recordToDelete):super(TransitionType.recordDeleted){
    _bucketListTransition = BucketListTransition.recordDeleted(bucketList, recordDeletedPositionInBucket, recordToDelete, bucketId, _transitionFile!.bucketRecordCapacity());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(dir,  hashTableIndex, TransitionType.recordDeleted);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record is deleted";
  }
  
  DirectFileTransition.recordDeletedWithModel(this._transitionFile, int recordDeletedPositionInBucket, int bucketId, int hashTableIndex, BaseRegister recordToDelete):super(TransitionType.recordDeleted){
    _bucketListTransition = BucketListTransition.recordDeleted(_transitionFile.getFileContent(), recordDeletedPositionInBucket, recordToDelete, bucketId, _transitionFile.bucketRecordCapacity());
    _directoryTransition = DirectoryTransition.hashTablePointedBucket(_transitionFile.getDirectory(),  hashTableIndex, TransitionType.recordDeleted);
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The record is deleted";
    if (_transitionFile.getFileContent()[bucketId].len == 1 ){
      StringBuffer buff= StringBuffer(_transitionMessage!);
      buff.write(". It checks whether the bucket can be freed.");
      _transitionMessage = buff.toString();
    }
  }

  DirectFileTransition.fileIsEmpty(this._transitionFile):super(TransitionType.fileIsEmpty) {
    _bucketListTransition = BucketListTransition(TransitionType.fileIsEmpty,_transitionFile.bucketRecordCapacity() ,_transitionFile.getFileContent());
    _directoryTransition = DirectoryTransition(_transitionFile.getDirectory());
    _freedListTransition = FreedListTransition(_transitionFile.getFreedList());
    _transitionMessage = "The file is empty";
  }
}
