import 'dart:collection';
import 'package:flutter/semantics.dart';

class Directory{

  //late Map<int, int> _map;
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
   print("*Duplicate*");
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
   print("*Duplicate END*");
  }

  update(int pointer, int newBucketNum, int jump){
    print("*Update Directory*");
    
    print("*Update Directory END*");
  }

  @override
  String toString() {
    return "T="+ _map.length.toString()+" - Table:" + _map.toString();
  }

}