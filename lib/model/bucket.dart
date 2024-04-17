import 'package:visualizeit_dynamicfile_extendiblehashing/exception/bucket_overflowed_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/exception/register_not_found_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';

class Bucket{
  List<BaseRegister> _registerList = List.empty(growable: true);
  late final int _id; 
  late final int _size;
  late int bits;

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
    print("Bucket "+ _id.toString() + " created");
  }
  
  int get id => _id;
  int get size => _size;

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
    print("setValue:" + reg.toString());
    //print(_registerList.length);
    //print("Size:" + _size.toString());
    if (_registerList.length == _size) {
      throw BucketOverflowedException("The bucket is full");
    } else if (_registerList.length < _size){
      _registerList.add(reg);
    }
    print("setValue: END");

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
    result.write("[ b:" + bits.toString()+ "-");
    _registerList.forEach((value) {
      result.write("${value.value},");
    });
    result.write("]");
    return result.toString();
  }

}