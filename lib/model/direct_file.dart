
import 'package:visualizeit_dynamicfile_extendiblehashing/exception/bucket_overflowed_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/directory.dart';
import 'dart:math';

class DirectFile{

  late List<Bucket> _file;
  late Directory _table;
  late int _bucketSize;
  late List<int> _free;

  DirectFile(int bucketSize){
    _file = [];
    _table = Directory();
    _table.create();
    _bucketSize = bucketSize;
    _free = [];
  }

  //utils:
  double logBase(num x, num base) => log(x) / log(base);
  int log2(num x) => (logBase(x, 2)).round();

  status(){
    //print("File content:" + this._file.toString());
    print("********************* FILE **********************");
    print("Directory Size:" + this._table.len.toString());
    print("Bucket Size:" +this._bucketSize.toString());
     print("<<<<< Directory:" + _table.toString() + ">>>>>>>>>>>>>>>>>>");
    print("File content:\n");
    for (int i=0 ; i<_file.length; i++){
      print("Bucket num: " + i.toString() + " - Bucket:" +_file[i].toString());
    }
    print("********************* FILE END **********************");    
  }

  bool exist(BaseRegister reg){
    print("*> Checking value: " + reg.toString());
    bool exist = false;
    if (_file.isEmpty){
        print("File is empty");
        return exist;
    }
    int index = reg.value % _table.len;
    int? bucketNum = _table.getBucketNumber(index);
    print("Directory Bucket number:"+ bucketNum.toString());
    Bucket mybucket = _file[bucketNum];
    mybucket.getRegList().forEach((register) {
      if(register.value == reg.value){
          exist = true;
      } 
    });
    print("*> Checking value ");
    return exist;
  }

  bool insert(BaseRegister newValue){

    print("*> Inserting value: " + newValue.toString());
    bool exist = false;
    //Calculating mod
    int index = newValue.value % _table.len;
    
    print("Directory index:"+ index.toString());
    int? bucketNum = _table.getBucketNumber(index);
    print("Directory Bucket number:"+ bucketNum.toString());
    //si file esta vacio crea el bucket agrega el registro con ese value.
    //sino agrega el value al bucket apuntado por bucketNum
    Bucket bucket;
    
      if (_file.isEmpty){
        print("File is empty");
        bucket = Bucket(_bucketSize,0);
        bucket.setValue(newValue);
        _file.add(bucket);      
      }
      else{
        if (bucketNum != Null){
          bucket = _file[bucketNum!.toInt()];
          
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
            print("Bucket " + bucketNum.toString() + "overflowed");
            // If log(T) is equal to hashing bits of the bucket then T+=1
            if (log2(_table.len) == bucket.bits){
                print("hashing bits are equal to log2(T)");
                reorder(newValue, _file[bucketNum]);  
            }
            else if (bucket.bits < log2(_table.len)){
              print("Hashing bits are less than log2(T)");
              reorder2(newValue,_file[bucketNum]);
            }


          }

        }
      }
    print("*> Inserting value end -");
    return true; 
  }


reorder(BaseRegister newValue, Bucket overflowedBucket){
    print("*> Reordering Registers");

    int lastBucketId=_file.length;
    //Duplico la tabla
    _table.duplicate(lastBucketId);
    int T = _table.len;
    print("<<< Directory " + _table.toString() + ">>>>>");
    //Creo una nueva cubeta y la agrego al file
    Bucket newBucket = Bucket(_bucketSize,lastBucketId);
    _file.add(newBucket);
    //acomodo los registros nuevamente de acuerdo al nuevo T
    //recorro los registos de la cubeta desbordada y le aplico el mod.
    List<BaseRegister> obList = overflowedBucket.getRegList();
    obList.forEach((reg) {
      print("*** Overflowed bucket:"+ "value:" + reg.toString());
      var newBucketNum = reg.value % T;
      print("**** New mode result:" + newBucketNum.toString());
      insert(reg);
      print("*> Reordering Registers END -");
    });
    int index = newValue.value % T;
    print("Directory index:"+ index.toString());
    int bucketNum = _table.getBucketNumber(index);
    _file[bucketNum].setValue(newValue);
    //print("___Overflowed Bucket Number:" + bucketNum.toString());
    print("___Bucket index:" + bucketNum.toString());
    //se suma 1 a los bits de dispersion de la cubeta desbordada y se copia este valor al bucket creado
    overflowedBucket.bits+=1;
    _file[bucketNum].bits=overflowedBucket.bits;
    
    if (bucketNum == overflowedBucket.id){
      print("Losing new bucket bits");
      newBucket.bits=overflowedBucket.bits;
    }

    print("*> Reordering Registers END -");


  }

  reorder2(BaseRegister newValue, Bucket overflowedBucket){
    print("*> Reordering Registers version 2");
    

    print("*> Reordering Registers version 2 END -");
  }

  bool delete(BaseRegister delValue){
    //TODO
    return false;
  }


}
