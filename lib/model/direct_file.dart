
import 'dart:math';

import 'package:visualizeit_dynamicfile_extendiblehashing/exception/bucket_overflowed_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/directory.dart';
import 'package:visualizeit_extensions/logging.dart';
 
final _logger = Logger("DFEH-DirectFile");

class DirectFile{

  late List<Bucket> _file;
  late Directory _table;
  late int _bucketSize;
  late List<int> _freed;

  DirectFile(int bucketSize){
    _file = [];
    _table = Directory();
    _table.create();
    _bucketSize = bucketSize;
    _freed = [];
  }

  /*only for testing pourposes*/
  Directory get table => _table;

  //utils:
  double logBase(num x, num base) => log(x) / log(base);
  int log2(num x) => (logBase(x, 2)).round();
  /*
  status(){
    //print("File content:" + this._file.toString());
    print("********************* FILE **********************");
    print("Bucket Size:" +this._bucketSize.toString());
     print("<<<<< Directory:" + _table.toString() + ">>>>>>>>>>>>>>>>>>");
    print("File content:\n");
    for (int i=0 ; i<_file.length; i++){
      print("Bucket num: " + i.toString() + " - Bucket:" +_file[i].toString());
    }
    print("Free Bucket list:"+ _freed.toString());
    print("********************* FILE END **********************");    
  }
  */
  status(){
    _logger.debug(() => "status()");
    print("********************* FILE **********************");
    print("Bucket Size:" +this._bucketSize.toString());
     print("<<<<< Directory:" + _table.toString() + ">>>>>>>>>>>>>>>>>>");
    print("File content:\n");
    for (int i=0 ; i<_file.length; i++){
      print("Bucket num: " + i.toString() + " - Bucket:" +_file[i].toString());
    }
    print("Free Bucket list:"+ _freed.toString());
    print("********************* FILE END **********************");    
  }

  bool exist(BaseRegister reg){
    print("<Direct File> - Exist - * Checking value: " + reg.toString());
    bool exist = false;
    if (_file.isEmpty){
        print("<Direct File> - Exist - File is empty");
        return exist;
    }
    int index = reg.value % _table.len;
    int? bucketNum = _table.getBucketNumber(index);
    print("<Direct File> - Exist - Directory Bucket number:"+ bucketNum.toString());
    Bucket mybucket = _file[bucketNum];
    mybucket.getList().forEach((register) {
      if(register.value == reg.value){
          exist = true;
      } 
    });
    print("<Direct File> - Exist - Result:"+ exist.toString());
    return exist;
  }

  bool insert(BaseRegister newValue){

    print("<Direct File> * Inserting value: " + newValue.toString());
    
    //bool exist = false;
    //Calculating mod
    int index = newValue.value % _table.len;
    
    print("<Direct File> Directory index:"+ index.toString());
    int bucketNum = _table.getBucketNumber(index);
    print("<Direct File> Directory Bucket number:"+ bucketNum.toString());


    //si file esta vacio crea el bucket agrega el registro con ese value.
    //sino agrega el value al bucket apuntado por bucketNum
    Bucket bucket;
    
      if (_file.isEmpty){
        print("<Direct File> File is empty");
        bucket = Bucket(_bucketSize,0);
        bucket.setValue(newValue);
        _file.add(bucket);      
      }
      else{
        /* The BucketNume was found in directory */
        if (bucketNum != -1){
          
          bucket = _file[bucketNum.toInt()];
          //TODO:Check if the register is already there.
          /*
          bucket.getRegList().forEach((register) {
            if(register.value == newValue.value){
              exist=true;
            } 
          });
          if (exist){
              return false;
          }
          */
          try{
            bucket.setValue(newValue);
          } on BucketOverflowedException {
            print("<Direct File> Bucket " + bucketNum.toString() + "overflowed");
            print("<Direct File> Bucket status is:" + bucket.status.toString());
            // If log(T) is equal to hashing bits of the bucket then T+=1
            if (log2(_table.len) == bucket.bits){
                print(">>>>>>>>>>>>>>>>>>>>>.<Direct File> Hashing bits are equal to log2(T)");
                reorder(newValue, _file[bucketNum]);  
            }
            else if (bucket.bits < log2(_table.len)){
              print(">>>>>>>>>>>>>>>>>>>>>>><Direct File> Hashing bits are less than log2(T)");
              reorder2(newValue,_file[bucketNum],index);
            }


          }

        }
      }
    print("<Direct File> * Inserting value end -");
    return true; 
  }


reorder(BaseRegister newValue, Bucket overflowedBucket){
    print("<Direct File> * Reordering Registers Start");

    int lastBucketId=-1;
    Bucket newBucket;
    /*We must considered here the buckets in the _freed list*/
    if (_freed.isNotEmpty){
      lastBucketId = getFreedBucket();
      newBucket = _file[lastBucketId];
    }
    else{
      lastBucketId=_file.length;
      newBucket = Bucket(_bucketSize,lastBucketId);
      //Modifying hashing bits and adding a new bucket to the file.
      //overflowedBucket.bits+=1;
      //Changing the status of the overflowed bucket to empty.
      //overflowedBucket.setStatus(BucketStatus.empty);
      //newBucket.bits = overflowedBucket.bits;
      _file.add(newBucket);
    }
    //Modifying hashing bits and adding a new bucket to the file.
    overflowedBucket.bits+=1;
    //Changing the status of the overflowed bucket to empty.
    overflowedBucket.setStatus(BucketStatus.empty);
    newBucket.bits = overflowedBucket.bits;
    
    //Duplicating the table
    _table.duplicate(lastBucketId);
    int T = _table.len;
    print("<<< Directory " + _table.toString() + ">>>>>");
    
    //acomodo los registros nuevamente de acuerdo al nuevo T
    //recorro los registos de la cubeta desbordada y le aplico el mod.
    List<BaseRegister> obList = overflowedBucket.getRegList();
    obList.forEach((reg) {
      print("<Direct File> *** Overflowed bucket:"+ "value:" + reg.toString());
      var newBucketNum = reg.value % T;
      print("<Direct File> **** New Bucket num:" + newBucketNum.toString());
      insert(reg);
      print("<Direct File> * Reordering Registers END -");
    });
    insert(newValue);
    print("<Direct File> * Reordering Registers END -");

  }

  reorder2(BaseRegister newValue, Bucket overflowedBucket, int bucketInitialIndex){
    print("<Direct File> * Reordering Registers version 2");

    //int lastBucketId=_file.length;
    int lastBucketId=-1;
    Bucket newBucket;
    /*We must considered here the buckets in the _freed list*/
    if (_freed.isNotEmpty){
      lastBucketId = getFreedBucket();
      newBucket = _file[lastBucketId];
    }
    else{
      lastBucketId=_file.length;
      newBucket = Bucket(_bucketSize,lastBucketId);
      //Modifying hashing bits and adding a new bucket to the file.
      //overflowedBucket.bits+=1;
      //Changing the status of the overflowed bucket to empty.
      //overflowedBucket.setStatus(BucketStatus.empty);
      //newBucket.bits = overflowedBucket.bits;
      _file.add(newBucket);
    }
    //Modifying hashing bits and adding a new bucket to the file.
    overflowedBucket.bits+=1;
    //Changing the status of the overflowed bucket to empty.
    overflowedBucket.setStatus(BucketStatus.empty);
    newBucket.bits = overflowedBucket.bits;

    int T = _table.len;
    //Calculating values for updating the directory.
    int x = 2;
    int b = newBucket.bits;
    int jump = pow(x, b).ceil();
    print("Initial position:" + bucketInitialIndex.toString());
    print("New bucket num:" + newBucket.id.toString() );
    print("Jump:" + jump.toString());
    _table.update(bucketInitialIndex,newBucket.id,jump);

    //acomodo los registros nuevamente
    //recorro los registos de la cubeta desbordada y le aplico el mod.
    //puede que caigan en la misma cubeta y hay que hacerlo recursivo.
    List<BaseRegister> obList = overflowedBucket.getRegList();
    obList.forEach((reg) {
      print("<Direct File> *** Overflowed bucket:" + "value:" + reg.toString());
      var newBucketNum = reg.value % T;
      print("<Direct File> **** New Bucket num:" + newBucketNum.toString());
      insert(reg);
      print("<Direct File> * Reordering Registers END -");
    });
    //Finally adding the new value:
    insert(newValue);

    /*int index = newValue.value % T;
    print("<Direct File> Directory index:"+ index.toString());
    int bucketNum = _table.getBucketNumber(index);
    _file[bucketNum].setValue(newValue);
    */
    //print("<<< Directory " + _table.toString() + ">>>>>");
    print("<Direct File> * Reordering Registers version 2 END -");
  }

  bool delete(BaseRegister delValue){
    print("<Direct File> * Deleting value: " + delValue.toString());
    
    /*
    if (!exist(delValue)){
      return false;
    }
    */

    int index = delValue.value % _table.len;
    
    print("<Direct File> Directory index:"+ index.toString());
    int bucketNum = _table.getBucketNumber(index);
    print("<Direct File> Directory Bucket number:"+ bucketNum.toString());

    Bucket myBucket = _file[bucketNum];
    print ("Bucket found:" + myBucket.toString());
    if (myBucket.delValue(delValue)){
       //Check if the bucket is empty
       if (myBucket.isEmpty()){
          int x = 2;
          int b = myBucket.bits;
          int jump1 = pow(x, b-1).ceil();
          int jump2 = pow(x, b).ceil(); 
          int replacemmentBucketNum = _table.review(index, jump1);
          if (replacemmentBucketNum != -1){
            _file[replacemmentBucketNum].bits-=1;
            _table.update(index,replacemmentBucketNum,jump2);
            //Adding the value again to appy to the model
            //The freed bucket should contain the value and i cannot know this at the moment of deleting.
            //TODO: Review this.
            myBucket.setValue(delValue);
            //Changing bucket status to "free"
            myBucket.setStatus(BucketStatus.freed);
            _freed.add(bucketNum);
            print("Free bucket bits:"+ myBucket.bits.toString());

            if (myBucket.bits == log2(_table.len)){
              //Checking if the directory is mirrowed. Half part is equal to the other part.
              _table.reduceIfMirrowed();
            }
          }
       } 
    }
    else {
      return false;
    }

    return true;
  }


  int getFreedBucket(){
    if (_freed.isEmpty) {
      return -1;
    } else{
      return _freed.removeLast();
    }
  }


}
