import 'package:visualizeit_dynamicfile_extendiblehashing/exception/bucket_overflowed_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/exception/register_not_found_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';


/*
empty: The bucket is empty.
full: The bucket is full. Will be overflowed on an insert opertation
active: The bucket has space, single insert operation will success.
free: The bucket was released and is in the _free list. The bucket should contain one registry.
*/
enum BucketStatus { empty, full, active, free }


class Bucket{
  List<BaseRegister> _registerList = List.empty(growable: true);
  late final int _id; 
  late final int _size;
  late int bits;
  late BucketStatus _status;

  /*
  Bucket(int bucketSize, BaseRegister reg, String id){
    _registerList.add(reg);
    _id = id;
    _size = bucketSize;
    bits = 0;
  }
  */

  Bucket(int bucketSize, int id){
    _id = id;
    _size = bucketSize;
    bits = 0;
    _status = BucketStatus.empty;
    print("Bucket "+ _id.toString() + " created");
  }
  
  int get id => _id;
  int get size => _size;
  BucketStatus get status => _status;

  bool isEmpty(){
    return (_registerList.isEmpty); 
  }

  String? getValue(BaseRegister reg)
  {
    var found = false;
    for( var value in _registerList){
      if (value.toString() == reg.toString()) {
        found= true;
        break;
      }
      else {
        continue;
      }  
    }
    if (!found) {
      throw RegisterNotFoundException("The register was not found in bucket");
    }
    else {
      return reg.toString();
    }
  }

  setValue(BaseRegister reg)
  {
    print("<Bucket> *setValue:" + reg.toString());
    print("<Bucket> Reg list size:" +_registerList.length.toString());
    print("<Bucket> Size:" + _size.toString());
    if (_registerList.length == _size) {
      
      throw BucketOverflowedException("The bucket is full");
    } else if (_registerList.length < _size){  
      print("<Bucket> Bucket status:" + _status.toString());    
      if (_status == BucketStatus.empty ){
          _status= BucketStatus.active;
      }
      _registerList.add(reg);
       if (_status == BucketStatus.active && _registerList.length == _size){
        _status= BucketStatus.full;
       }
    }
    print("<Bucket> Final bucket status :" + _status.toString());   
    print("<Bucket> *setValue: END");

  }

  bool delValue(BaseRegister reg)
  {
    print("<Bucket> *delValue:" + reg.value.toString());
    var regListCopy = [..._registerList];
    print("<Bucket> *_____/////____" + regListCopy.toString());
    print("<Bucket> *_____/////____" + _registerList.toString());
    var found=false;
    for( var value in regListCopy){
      print("Bucket Value:" + value.toString());
      if (value.toString() == reg.toString()) {
        print("<Bucket> Delete value:" + value.toString());
        /*
        if (_registerList.length > 1){
          _registerList.remove(value);
        }*/
        _registerList.remove(value);
        found=true;
        break;
      }
      else {
        continue;
      }  
    }
    print("<Bucket> * delValue: Result:" + found.toString());
    return found;
  }

  BaseRegister? getReg(String my_value)
  {
    var found = false;
    var reg;
    for( reg in _registerList){
      if (reg.toString() == my_value) {
        found= true;
        break;
      }
      else {
        continue;
      }  
    }
    if (!found) {
      throw RegisterNotFoundException("The register was not found in bucket");
    }
    else {
      _registerList.remove(reg);
      return reg;
    }
  }

  BaseRegister? getRegbyIndex(int index)
  {
    if (index >= _registerList.length) {
      throw RegisterNotFoundException("The register was not found in bucket");
    }
    else {
      var reg =_registerList[index];
      _registerList.remove(reg);
      return reg;
    }  
  }
  
  List<BaseRegister> getRegList(){
    List<BaseRegister> copyList = List.from(_registerList);
    _registerList = [];
    return copyList;
  }
  
  @override
  String toString(){
    var result = StringBuffer();
    result.write("[ Status: "+ _status.name +", b:" + bits.toString()+ "-");
    _registerList.forEach((value) {
      result.write("${value.value},");
    });
    result.write("]");
    return result.toString();
  }

  void setStatus(BucketStatus new_status) {
    _status = new_status;
  }

}