
class Directory{

  late List<int> _hashMap;
  int _pointer = 0;

  int get len => _hashMap.length;

  create(){
    _hashMap = [];
    _hashMap.add(0); 
  }

  int getBucketNumber(int index){
    if (index <= len ){
      _pointer = index;
      return _hashMap[index];
    }
    return -1;//TODO: review this 
  }
  /* Used in the insertion when is necessary to duplicate the hash table */
  duplicate(int lastBucketId){
   print("<Directory> *Duplicate*");
   print("Actual Directory:" + _hashMap.toString());
   var mapCopy = [..._hashMap];//copy of the original list
   print("Pointer:" + _pointer.toString());
   //Duplicating the table.
   mapCopy.addAll(_hashMap);
   //Updating the Bucket number.
   mapCopy[_pointer]=lastBucketId;
   print("Pointer:" + _pointer.toString());
   print("New directory:" + mapCopy.toString());
   _hashMap = mapCopy;
   print("<Directory> *Duplicate END*");
  }
  /* Update the hash table, used to update the bucket number in a circular way */
  update(int init, int newBucketNum, int jump){
    print("<Directory> *Update Directory*");
    print("<Directory> *Update Directory* Init:"+init.toString()+" is pointing to bucket:"+ newBucketNum.toString());
    _hashMap[init] = newBucketNum;
    var i=1;
    var pointer = 0;
    while (true){
      pointer = (init + jump*i) % _hashMap.length;
      i++;
      if(pointer == init){
        break;
      }
      print("________ point:" + pointer.toString());
      _hashMap[pointer]= newBucketNum;
    }     
    print("<Directory> *Update Directory END*");
  }
  
  /* Used in deletion algorithm, return replacemment bucket number if init+jump and init-jump are equal if not return -1 */
  int review(int init, int jump){
    print("<Directory> *Review Directory*");
    print("<Directory> *Review Directory* init:" + init.toString());
    print("<Directory> *Review Directory* jump:" + jump.toString());
    var p_after = (init + jump) % _hashMap.length;
    var p_before = (init - jump) % _hashMap.length;

    print("<Directory> *Review Directory* p_after:" + p_after.toString());
    print("<Directory> *Review Directory* p_before:" + p_before.toString());
    //print("<Directory> *Review Directory* Dir:" + _hashMap.toString());

    if (_hashMap[p_after] == _hashMap[p_before]){
        //Then it is possible to free the bucket
        print("<Directory> *Review Directory - Bucket numbers are equal");
        return _hashMap[p_after];
    }
    return -1;

    print("<Directory> *Review Directory END*");
  }
  /* Used in deletion algorithm, reduce the table if the first half is equal to the second one*/
  void reduceIfMirrowed(){
    //check if the first half of the directory is the same as the last one.
    var halfList = _hashMap.sublist(0,(_hashMap.length/2).ceil());
    var backList = _hashMap.sublist((_hashMap.length/2).ceil(),_hashMap.length);
    //print("HalfList:" + halfList.toString());
    //print("BackList:" + backList.toString());
    
    if (_listEquals(halfList,backList)){
      _hashMap = halfList;
    }
  }

  /* Private method to check if two list are equal */
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
    return "T="+ _hashMap.length.toString()+" - Table:" + _hashMap.toString();
  }

}