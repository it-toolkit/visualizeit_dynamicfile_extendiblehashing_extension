
import 'dart:math';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/exception/bucket_overflowed_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file_observer.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/observer.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/directory.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("Extension.DFEH.Model.DirectFile");

class DirectFile extends Observable{

  late List<Bucket> _file;
  late Directory _table;
  late int _bucketSize;
  late List<int> _freed;

  DirectFile(int bucketSize){
    _file = [];
    _table = Directory();
    _table.create();
    if (bucketSize <= 0) {
      throw Exception("The bucket size must be greater than 0");
    }else {
      _bucketSize = bucketSize;
    }
    _freed = [];
    _logger.trace(() => "Creating Direct File"); 
  }

  @override
  void registerObserver(DirectFileObserver observer) {
    observers.add(observer);
    _table.registerObserver(observer);
  }

  DirectFile._copy(this._bucketSize, this._file, this._table, this._freed);

  List<Bucket> getFileContent() => _file;
  Directory getDirectory() => _table;
  List<int> getFreedList() => _freed;
  int bucketRecordCapacity() => _bucketSize;
  
  bool bucketWithFixedLengthRecord(){
    //This is always true, buckets with variable 
    //record length were not implemented.
    return true;
  }

  void replaceHashTable(Directory hashTable){
    _table = hashTable;
  }

  //utils:
  double logBase(num x, num base) => log(x) / log(base);
  int log2(num x) => (logBase(x, 2)).round();

  status(){
    _logger.trace(() => "********************* FILE **********************"); 
    _logger.trace(() => "Bucket Size:$_bucketSize");
    _logger.trace(() => "<<<<< Hash Table:$_table>>>>>>>>>>>>>>>>>>"); 
    _logger.trace(() => "File content:\n"); 
    for (int i=0 ; i<_file.length; i++){
      _logger.trace(() => "Bucket num: $i - Bucket:${_file[i]}"); 
    }
    _logger.trace(() => "Free Bucket list:$_freed");
    _logger.trace(() => "********************* FILE END **********************");    
  }

  bool exist(BaseRegister reg){
    _logger.trace(() => "exist() - Checking if $reg is in file"); 
    bool exist = false;
    if (_file.isEmpty){
        _logger.trace(() => "exist() - File is empty");
        _logger.trace(() => "exist() - END"); 
        return exist;
    }
    int index = reg.value % _table.len;
    int? bucketNum = _table.getBucketNumber(index);
    
    _logger.trace(() => "exist() - Directory Bucket number is $bucketNum"); 
    Bucket mybucket = _file[bucketNum];
    
    for (var register in mybucket.getList())
    {
      if(register.value == reg.value){
          exist = true;
          break;
      }
    }
    _logger.trace(() => "exist() - Result: $exist"); 
    return exist;
  }

  bool find(BaseRegister reg){
    _logger.trace(() => "find() - Checking if $reg is in file"); 
    bool exist = false;
    if (_file.isEmpty){
        _logger.trace(() => "find() - File is empty");
        _logger.trace(() => "find() - END"); 
        return exist;
    }
    int index = reg.value % _table.len;
    notifyObservers(DirectFileTransition.findingBucketWithModel(clone(), reg.value, _table.len, index));
    int? bucketNum = _table.getBucketNumber(index);
    _logger.trace(() => "find() - Directory Bucket number is $bucketNum"); 
    Bucket mybucket = _file[bucketNum];
    notifyObservers(DirectFileTransition.bucketFoundWithModel(clone(),bucketNum,index));
    for (var register in mybucket.getList())
    {
      if(register.value == reg.value){
          exist = true;
          break;
      }
    }
    if( exist ){
      notifyObservers(DirectFileTransition.recordFoundWithModel(clone(),bucketNum, index, reg));
    }else{
      notifyObservers(DirectFileTransition.recordNotFoundWithModel(clone(),bucketNum, index, reg));
    }
    _logger.trace(() => "find() - Result: $exist"); 
    return exist;
  }

  bool insert(BaseRegister newValue){
    _logger.trace(() => "insert() - Begins");
    _logger.trace(() => "insert() - Inserting value: $newValue");
    if (exist(newValue)) {
      _logger.trace(() => "insert() - The register already exist in the file");
      notifyObservers(DirectFileTransition.recordExistWithModel(clone(),newValue));
      return false;
    }
    if (_file.isEmpty){
       notifyObservers(DirectFileTransition.fileIsEmpty(clone()));
    }
    //Calculation Mod
    int index = newValue.value % _table.len;
    notifyObservers(DirectFileTransition.findingBucketWithModel(clone(), newValue.value, _table.len, index));
    _logger.trace(() => "insert() - Modular value - Directory index is $index");
    int bucketNum = _table.getBucketNumber(index);
    _logger.trace(() => "insert() - Directory is pointing to bucket $bucketNum");

    // If the file is empty, then the register should be added to the bucket.
    // if not, the register should be added to the bucket pointed by the hash table
    // or directory.
    Bucket bucket;
    
      if (_file.isEmpty){
        _logger.trace(() => "insert() - File is empty");
        bucket = Bucket(_bucketSize,0);
        _file.add(bucket);
        notifyObservers(DirectFileTransition.bucketCreatedWithModel(clone(), 0,index));
        bucket.setValue(newValue);
        notifyObservers(DirectFileTransition.recordSavedWithModel(clone(),bucket.id,index,newValue));
      }
      else{
        /* The BucketNum was found in directory */
        if (bucketNum != -1){
          
          bucket = _file[bucketNum.toInt()];
          notifyObservers(DirectFileTransition.bucketFoundWithModel(clone(),bucketNum,index));
          try{
            bucket.setValue(newValue);
            notifyObservers(DirectFileTransition.recordSavedWithModel(clone(),bucket.id, index,newValue));
          } on BucketOverflowedException {
            _logger.trace(() => "insert() - Bucket $bucketNum overflowed");
            notifyObservers(DirectFileTransition.bucketOverflowedWithModel(clone(),bucket.id, index));  
            // If log(T) is equal to hashing bits of the bucket then T+=1 (Duplicate the hashing table)
            if (log2(_table.len) == bucket.bits){
                _logger.trace(() => "insert() - Hashing bits are equal to log2(T)");
                _logger.trace(() => "insert() - Calling reorder");
                reorder(newValue, _file[bucketNum],index);  
            }
            else if (bucket.bits < log2(_table.len)){
              _logger.trace(() => "insert() - Hashing bits are less than log2(T)");
              _logger.trace(() => "insert() - Calling reorder2");
              reorder2(newValue,_file[bucketNum],index);
            }
          }
        }
      }
    _logger.trace(() => "insert() - END");
    return true; 
  }


reorder(BaseRegister newValue, Bucket overflowedBucket, int bucketInitialIndex){
    _logger.trace(() => "reorder() - Reordering Registers Starting");

    int lastBucketId=-1;
    Bucket newBucket;
    bool bucketReuse = false;
    /*We must considered here the buckets in the _freed list*/
    if (_freed.isNotEmpty){
      DirectFile myClone = clone();
      lastBucketId = getFreedBucket();
      newBucket = _file[lastBucketId];
      notifyObservers(DirectFileTransition.usingBucketFreedWithModel(myClone,lastBucketId));
      bucketReuse = true;
    }
    else{
      lastBucketId=_file.length;
      newBucket = Bucket(_bucketSize,lastBucketId);
      _file.add(newBucket);
      notifyObservers(DirectFileTransition.bucketCreatedWithModel(clone(),lastBucketId, -1));
    }
    //Modifying hashing bits and adding a new bucket to the file.
    overflowedBucket.bits+=1;
    notifyObservers(DirectFileTransition.bucketUpdateHashingBitsWithModel(clone(),overflowedBucket.id,TransitionType.bucketOverflowed));
    newBucket.bits = overflowedBucket.bits;
    notifyObservers(DirectFileTransition.bucketUpdateHashingBitsWithModel(clone(),newBucket.id, bucketReuse ? TransitionType.usingBucketFreed:TransitionType.bucketCreated));

    //Duplicating the table
    _table.duplicate(lastBucketId, clone());
    
    int T = _table.len;
    _logger.trace(() => "reorder() - New hash table: $_table");
    
    //Changing the status of the overflowed bucket to empty.
    overflowedBucket.setStatus(BucketStatus.empty);
    notifyObservers(DirectFileTransition.bucketReorganizedWithModel(clone(),overflowedBucket.id));
    // Reordering registers acordingly to the new T value, 
    // iterate over the overflowed bucket and calculate the mod again.
    List<BaseRegister> obList = overflowedBucket.getRegList();
    for (var reg in obList) {
      _logger.trace(() => "reorder() - *** Overflowed bucket *** Reordering register value: $reg");
      var newBucketNum = reg.value % T;
      _logger.trace(() => "reorder() - New Bucket number is $newBucketNum");
      _logger.trace(() => "reorder() - Inserting value $reg in $newBucketNum");
      insert(reg);
      _logger.trace(() => "reorder() - Reordering Registers End");
    }
    _logger.trace(() => "reorder() - Inserting new value $newValue");
    insert(newValue);
    _logger.trace(() => "reorder() - Reordering Registers Starting");

  }

  reorder2(BaseRegister newValue, Bucket overflowedBucket, int bucketInitialIndex){
    _logger.trace(() => "reorder2() - Reordering Registers Starting");

    int lastBucketId=-1;
    Bucket newBucket;
    bool bucketReuse = false;
    /*We must considered here the buckets in the _freed list*/
    if (_freed.isNotEmpty){
      DirectFile myClone = clone();
      lastBucketId = getFreedBucket();
      newBucket = _file[lastBucketId];
      notifyObservers(DirectFileTransition.usingBucketFreedWithModel(myClone,lastBucketId));
      bucketReuse = true;
    }
    else{
      lastBucketId=_file.length;
      newBucket = Bucket(_bucketSize,lastBucketId);
      _file.add(newBucket);
      notifyObservers(DirectFileTransition.bucketCreatedWithModel(clone(),lastBucketId, -1));
    }
    //Modifying hashing bits and adding a new bucket to the file.
    overflowedBucket.bits+=1;
    notifyObservers(DirectFileTransition.bucketUpdateHashingBitsWithModel(clone(),overflowedBucket.id,TransitionType.bucketOverflowed));

    newBucket.bits = overflowedBucket.bits;
    notifyObservers(DirectFileTransition.bucketUpdateHashingBitsWithModel(clone(),newBucket.id,bucketReuse? TransitionType.usingBucketFreed : TransitionType.bucketCreated));

    int T = _table.len;
    //Calculating values for updating the directory.
    int x = 2;
    int b = newBucket.bits;
    int jump = pow(x, b).ceil();
    _logger.trace(() => "reorder2() - Initial position: $bucketInitialIndex");
    _logger.trace(() => "reorder2() - New bucket id: ${newBucket.id}");
    _logger.trace(() => "reorder2() - Jump: $jump");
    DirectFile myClone = clone();
    _table.update(bucketInitialIndex,newBucket.id,jump, myClone);

    //Changing the status of the overflowed bucket to empty.
    overflowedBucket.setStatus(BucketStatus.empty);
    //Reordering registers again, iterating over the overflowed bucket and calculating mod.
    //The result could be the same bucket and we must work recursively
    notifyObservers(DirectFileTransition.bucketReorganizedWithModel(clone(),overflowedBucket.id));
    List<BaseRegister> obList = overflowedBucket.getRegList();
    for (var reg in obList) {
      _logger.trace(() => "reorder2() - *** Overflowed bucket *** Reordering register value: $reg");
      var newBucketNum = reg.value % T;
      _logger.trace(() => "reorder2() - New Bucket number is $newBucketNum");
      _logger.trace(() => "reorder2() - Inserting value $reg in $newBucketNum");
      insert(reg);
      _logger.trace(() => "reorder() - Reordering Registers End");
    }
    //Finally adding the new value
    _logger.trace(() => "reorder2() - Inserting last value $newValue");
    insert(newValue);
    _logger.trace(() => "reorder2() - Reordering Registers End");
  }

  bool delete(BaseRegister delValue){
    _logger.trace(() => "delete() - Deleting value: $delValue");
    
    if (_file.isEmpty){
       notifyObservers(DirectFileTransition.fileIsEmpty(clone()));
       return false;
    }
    
    if (!exist(delValue)){
      _logger.trace(() => "delete() - The value $delValue does not exist in the file");
      notifyObservers(DirectFileTransition.recordNotFoundWithModel(clone(),-1, -1, delValue));
      return false;
    }
  
    int index = delValue.value % _table.len;
    notifyObservers(DirectFileTransition.findingBucketWithModel(clone(), delValue.value, _table.len, index));
    _logger.trace(() => "delete() - Directory index value: $index");
    
    int bucketNum = _table.getBucketNumber(index);
    _logger.trace(() => "delete() - Directory is pointing to bucket $bucketNum");

    Bucket myBucket = _file[bucketNum];
    _logger.trace(() => "delete() - Bucket with id ${myBucket.id} was found");
    notifyObservers(DirectFileTransition.bucketFoundWithModel(clone(),bucketNum,index));

    notifyObservers(DirectFileTransition.recordDeletedWithModel(clone(),myBucket.indexOf(delValue.clone()),bucketNum,index,delValue.clone()));
    var myClone = clone();
    if (myBucket.delValue(delValue)){
       //Check if the bucket is empty
       if (myBucket.isEmpty()){
          int x = 2;
          int b = myBucket.bits;
          int jump1 = pow(x, b-1).ceil();
          int jump2 = pow(x, b).ceil(); 
          int replacemmentBucketNum = _table.review(index, jump1, myBucket.id, myClone);
          
          //This part is when a Bucket will be freed
          if (replacemmentBucketNum != -1){
            //We need to keep the value in the bucket, so we put it again.
            myBucket.setValue(delValue);
            notifyObservers(DirectFileTransition.replacementBucketFoundWithModel(clone(), replacemmentBucketNum, index));
            _file[replacemmentBucketNum].bits-=1;
            notifyObservers(DirectFileTransition.bucketUpdateHashingBitsWithModel(clone(),replacemmentBucketNum,TransitionType.replacemmentBucketFound));
            _table.update(index,replacemmentBucketNum,jump2, clone());
            //Adding the value again to appy to the model
            //The freed bucket should contain the value and i cannot know this at the moment of deleting.
            //Changing bucket status to "free"
            _logger.trace(() => "delete() - The bucket status is now 'free'");
            myBucket.setStatus(BucketStatus.freed);
            _logger.trace(() => "delete() - The bucket was added to the freed list");
            _freed.add(bucketNum);
            notifyObservers(DirectFileTransition.bucketFreedWithModel(clone(),bucketNum));

            if (myBucket.bits == log2(_table.len)){
              //Checking if the directory is mirrowed. Half part is equal to the other part.
              _table.reduceIfMirrowed();
              notifyObservers(DirectFileTransition.hashTableReduceSizeWithModel(clone()));
            }
          }else{
            //This part when the bucket will be saved in Empty state.
            notifyObservers(DirectFileTransition.bucketEmptyWithModel(clone(),bucketNum));
          }
       } 
    }
    else {
      _logger.trace(() => "delete() - Deleting value ends unsuscesful");
      return false;
    }
    _logger.trace(() => "delete() - END");
    return true;
  }

  int getFreedBucket(){
    if (_freed.isEmpty) {
      return -1;
    } else{
      return _freed.removeLast();
    }
  }

  DirectFile clone() {
    List<Bucket> fileCopy = List.empty(growable: true);
    for (var element in _file) {
      fileCopy.add(element.clone());
    }
    return DirectFile._copy(_bucketSize,fileCopy,_table.clone(),_freed.toList());
  }

}
