
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/exception/bucket_overflowed_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/exception/register_not_found_exception.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("Extension.DFEH.Model.Bucket");

/*
empty: The bucket is empty.
full: The bucket is full. Will be overflowed on an insert opertation
active: The bucket has space, single insert operation will success.
freed: The bucket was released and is in the _freed list. The bucket should contain one registry.
*/
enum BucketStatus {
  Active,
  Full,
  Freed,
  Empty;

  @override
  String toString() => name;
}


class Bucket{
  List<BaseRegister> _registerList = List.empty(growable: true);
  late final int _id; 
  late final int _size;
  late int bits;
  late BucketStatus _status;

  Bucket(int bucketSize, int id){
    _id = id;
    _size = bucketSize;
    bits = 0;
    _status = BucketStatus.Empty;
    _logger.trace(() => "Creating bucket with id ${id.toString()}");
  }

  Bucket._copy(this._id,this._size,this.bits,this._registerList, this._status);
  
  int get id => _id;
  int get size => _size;
  int get len => _registerList.length;
  BucketStatus get status => _status;

  bool isEmpty(){
    _logger.debug(() => "isEmpty() - Bucket $_id is ${_status.name}");
    return (_status==BucketStatus.Empty)? true : false; 
  }

  String? getValue(BaseRegister reg)
  {
    var found = false;
    for( var value in _registerList){
      if (value.toString() == reg.toString()) {
        found= true;
        _logger.debug(() => "getValue() - Register with value ${reg.value.toString()} was found");
        break;
      }
      else {
        continue;
      }  
    }
    if (!found) {
      _logger.debug(() => "getValue() - The register was not found in bucket");
      throw RegisterNotFoundException("The register was not found in bucket");
    }
    else {
      return reg.toString();
    }
  }

  setValue(BaseRegister reg)
  {
    _logger.trace(() => "setValue() - Setting value ${reg.value.toString()}");
    //print("<Bucket> Reg list size:" +_registerList.length.toString());
    //print("<Bucket> Size:" + _size.toString());
    if ( len == _size) {
      _logger.debug(() => "setValue() - Bucket $_id is full");
      throw BucketOverflowedException("The bucket is full");
    } else if ( len < _size){ 
      _logger.trace(() => "setValue() - Bucket $_id is ${_status.name}");
      if ((_status == BucketStatus.Empty) || (_status == BucketStatus.Full) ){  
          _status= BucketStatus.Active;
      }
      if (_status == BucketStatus.Freed){
        _status= BucketStatus.Active;
        _registerList.removeLast();
      }
      _registerList.add(reg);
       if (_status == BucketStatus.Active && _registerList.length == _size){
        _status= BucketStatus.Full;
       }
    }
    _logger.debug(() => "setValue() - Bucket $_id, final status is ${_status.name}");
    _logger.trace(() => "setValue() - END");
  }

  bool delValue(BaseRegister reg)
  {
    _logger.trace(() => "delValue() - Trying to delete value ${reg.value.toString()}");
    var regListCopy = [..._registerList];
    var found=false;
    for( var value in regListCopy){
      if (value.toString() == reg.toString()) {
        _logger.debug(() => "delValue() - The value as found, deleting value ${value.toString()}");
        found=true;
 
        if (_status == BucketStatus.Full){
          _status= BucketStatus.Active;
        }
        if ((_status == BucketStatus.Active) &&( len == 1)){
          _status= BucketStatus.Empty;
        }
        _registerList.remove(value);
        break;
      }
      else {
        continue;
      }  
    }
    _logger.trace(() => "delValue() - Bucket $_id, final status is ${_status.name}");
    _logger.trace(() => "delValue() - END");
    return found;
  }
  /*
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
  */
  /* Only used for testing pourpose */
  BaseRegister? getRegbyIndex(int index)
  {
    if (index >= _registerList.length) {
      throw RegisterNotFoundException("The register was not found in bucket");
    }
    else {
      var reg =_registerList[index];
      //_registerList.remove(reg);
      return reg;
    }  
  }
  
  /* This method should be used when there is a reorganization of registers*/
  List<BaseRegister> getRegList(){
    List<BaseRegister> copyList = List.from(_registerList);
    _registerList = [];
    return copyList;
  }
  /* Used to iterate over the registers in the bucket */
  List<BaseRegister> getList(){
    return _registerList;
  }

  int indexOf(BaseRegister reg){
    List<BaseRegister> copyList = List.from(_registerList);
    int index = 0;
    bool found = false;
    for (var myreg in copyList) {
      if (myreg.value == reg.value){
        found = true;
        break; 
      }
      if (index == copyList.length -1){
        break;
      }
      index++;
    }

    return found ? index : -1;
  }

  @override
  String toString(){
    var result = StringBuffer();
    result.write("[ Status: ${_status.name}, b:$bits-");
    _registerList.forEach((value) {
      result.write("${value.value},");
    });
    result.write("]");
    return result.toString();
  }

  void setStatus(BucketStatus newStatus) {
    _logger.debug(() => "setStatus() - Bucket $_id new status is $newStatus");
    _status = newStatus;
  }

  Bucket clone(){
    List<BaseRegister> newRegisterList = List.empty(growable: true);
    _registerList.forEach((element) { 
      newRegisterList.add(element.clone());
    });
    
    return Bucket._copy(_id,_size,bits,newRegisterList,_status);
  }

}