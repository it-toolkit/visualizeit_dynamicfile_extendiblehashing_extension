import 'dart:collection';
import 'package:flutter/semantics.dart';

class Directory{

  late List<int> _map;
  int _pointer = 0;

  int get len => _map.length;

  create(){
    _map = [];
    _map.add(0); 
  }

  int getBucketNumber(int index){
    if (index <= len ){
      _pointer = index;
      return _map[index];
    }
    return -1;//TODO: review this 
  }

  setBucketNumber(int index, stringBucketNumber){
    print("TODO: SetBucketNumber");
  }

  duplicate(int lastBucketId){
   print("<Directory> *Duplicate*");
   print("Actual Directory:" + _map.toString());
   var mapCopy = [..._map];//copy of the original list
   print("Pointer:" + _pointer.toString());
   //Duplicating the table.
   mapCopy.addAll(_map);
   //Updating the Bucket number.
   mapCopy[_pointer]=lastBucketId;
   print("Pointer:" + _pointer.toString());
   print("New directory:" + mapCopy.toString());
   _map = mapCopy;
   print("<Directory> *Duplicate END*");
  }

  update(int init, int newBucketNum, int jump){
    print("<Directory> *Update Directory*");
    print("<Directory> *Update Directory* Init:"+init.toString()+" is pointing to bucket:"+ newBucketNum.toString());
    _map[init] = newBucketNum;
    var i=1;
    var pointer = 0;
    while (true){
      pointer = (init + jump*i) % _map.length;
      i++;
      if(pointer == init){
        break;
      }
      print("________ point:" + pointer.toString());
      _map[pointer]= newBucketNum;
    }     
    print("<Directory> *Update Directory END*");
  }
    // Return replacemment bucket number if init+jump and init-jump are equal if not return -1
    int review(int init, int jump){
    print("<Directory> *Review Directory*");
    print("<Directory> *Review Directory* init:" + init.toString());
    print("<Directory> *Review Directory* jump:" + jump.toString());
    var p_after = (init + jump) % _map.length;
    var p_before = (init - jump) % _map.length;

    print("<Directory> *Review Directory* p_after:" + p_after.toString());
    print("<Directory> *Review Directory* p_before:" + p_before.toString());
    //print("<Directory> *Review Directory* Dir:" + _map.toString());

    if (_map[p_after] == _map[p_before]){
        //Then it is possible to free the bucket
        print("<Directory> *Review Directory - Bucket numbers are equal");
        return _map[p_after];
    }
    return -1;

    print("<Directory> *Review Directory END*");
  }

  void reduceIfMirrowed(){
    //check if the first half of the directory is the same as the last one.
    var halfList = _map.sublist(0,(_map.length/2).ceil());
    var backList = _map.sublist((_map.length/2).ceil(),_map.length);
    //print("HalfList:" + halfList.toString());
    //print("BackList:" + backList.toString());
    
    if (listEquals(halfList,backList)){
      _map = halfList;
    }
  }

  bool listEquals<T>(List<T>? a, List<T>? b) {
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
    return "T="+ _map.length.toString()+" - Table:" + _map.toString();
  }

}