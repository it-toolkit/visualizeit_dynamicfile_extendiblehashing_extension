import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/observer.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("Extension.DFEH.Model.Directory");

class Directory extends Observable{

  late List<int> _hashMap;
  int _pointer = 0;

  int get len => _hashMap.length;
  List<int> get hash => _hashMap;

  create(){
    _hashMap = [];
    _hashMap.add(0);
    _logger.trace(() => "Creating Hash table for file"); 
  }

  Directory();
  Directory._copy(this._hashMap, this._pointer);

  int getPointer() => _pointer;

  int getBucketNumber(int index){
    if (index <= len ){
      _pointer = index;
      return _hashMap[index];
    }
    return -1;
  }

  /* Used in the insertion when is necessary to duplicate the hash table */
  duplicate(int lastBucketId,DirectFile file){
   _logger.trace(() => "duplicate() - Begins");
   _logger.trace(() => "duplicate() - Actual hash table: ${_hashMap.toString()}");
   var mapCopy = [..._hashMap];//copy of the original list

   //Duplicating the table.
   mapCopy.addAll(_hashMap);
   _logger.trace(() => "duplicate() - New hash table: ${mapCopy.toString()}");
   _hashMap = mapCopy;
   notifyObservers(DirectFileTransition.hashTableDuplicateSize(file,file.getFileContent(),clone()));
   //Updating the Bucket number.
   _hashMap[_pointer]=lastBucketId;
   notifyObservers(DirectFileTransition.hashTableUpdated(file,file.getFileContent(),clone(),lastBucketId,_pointer,TransitionType.hashTablePointedBucket));
   _logger.trace(() => "duplicate() - END");
  }

  /* Update the hash table, used to update the bucket number in a circular way */
  update(int init, int newBucketNum, int jump, DirectFile file){
    _logger.trace(() => "update() - Begins");
    _logger.trace(() => "update() - Position <$init> (init variable) is pointing to bucket ${newBucketNum.toString()}");
    _hashMap[init] = newBucketNum;
    var myClone = file.clone();
    notifyObservers(DirectFileTransition.hashTableUpdated(myClone, myClone.getFileContent(), clone(), newBucketNum, init, TransitionType.hashTablePointedBucket));
    var i=1;
    var pointer = 0;
   
    while (true){
      pointer = (init + jump*i) % _hashMap.length;
      i++;
      if(pointer == init){
        break;
      }
      _hashMap[pointer]= newBucketNum;
      myClone = file.clone();
      notifyObservers(DirectFileTransition.hashTableCircularUpdated(myClone, myClone.getFileContent(), clone(), newBucketNum, pointer, init, jump,TransitionType.hashTablePointedBucket));
    }     
    _logger.trace(() => "update() - END");
  }
  
  /* Used in deletion algorithm, return replacemment bucket number if init+jump and init-jump are equal if not return -1 */
  int review(int init, int jump, int bucketId, DirectFile file){
    _logger.trace(() => "review() - Begins");
    _logger.trace(() => "review() - Initial position: $init");
    _logger.trace(() => "review() - Jump value: $jump");
    int result = -1;
    var pAfter = (init + jump) % _hashMap.length;
    var pBefore = (init - jump) % _hashMap.length;

    var myClone = file.clone();
    if (_hashMap[pAfter] == _hashMap[pBefore]){
        //Then it is possible to free the bucket
        _logger.trace(() => "review() - Bucket numbers are equal");
        notifyObservers(DirectFileTransition.hashTableReviewed(myClone,myClone.getFileContent(), clone(),bucketId,pAfter,pBefore,init,jump, TransitionType.hashTableReviewedSameBucket));
        return _hashMap[pAfter];
    }
    _logger.trace(() => "review() - Bucket numbers are not equal");
    notifyObservers(DirectFileTransition.hashTableReviewed(myClone,myClone.getFileContent(), clone(),bucketId,pAfter,pBefore,init,jump, TransitionType.hashTableReviewedNotSameBucket));
    return result;

  }

  /* Used in deletion algorithm, reduce the table if the first half is equal to the second one*/
  void reduceIfMirrowed(){
    _logger.trace(() => "reduceIfMirrowed() - Begins");
    //check if the first half of the directory is the same as the last one.
    var halfList = _hashMap.sublist(0,(_hashMap.length/2).ceil());
    var backList = _hashMap.sublist((_hashMap.length/2).ceil(),_hashMap.length);
    
    if (_listEquals(halfList,backList)){
      _hashMap = halfList;
      _logger.trace(() => "reduceIfMirrowed() - The hash table must be reduce it");
      _logger.trace(() => "reduceIfMirrowed() - New hash table: ${halfList.toString()}");
    }
    _logger.trace(() => "reduceIfMirrowed() - END");
  }

  /* Private method to check if two lists are equal */
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (int index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) {
        return false;
      }
    }
    return true;
  } 

  @override
  String toString() {
    return "T=${_hashMap.length} - Table:$_hashMap";
  }

  bool equalsTo(Directory newDir){
    return _listEquals(_hashMap, newDir._hashMap);
  }

  Directory clone(){
    return Directory._copy(_hashMap.toList(), _pointer);
  }

}