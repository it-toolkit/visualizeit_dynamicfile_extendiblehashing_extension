import 'package:visualizeit_extensions/logging.dart'; 
final _logger = Logger("DFEH-Directory");

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
   _logger.debug(() => "duplicate() - Begins");
   _logger.debug(() => "duplicate() - Actual hash table: ${_hashMap.toString()}");
   var mapCopy = [..._hashMap];//copy of the original list
   //print("Pointer:" + _pointer.toString());
   //Duplicating the table.
   mapCopy.addAll(_hashMap);
   //Updating the Bucket number.
   mapCopy[_pointer]=lastBucketId;
   //print("Pointer:" + _pointer.toString());
   _logger.debug(() => "duplicate() - New hash table: ${mapCopy.toString()}");  
   _hashMap = mapCopy;
   _logger.debug(() => "duplicate() - END");
  }

  /* Update the hash table, used to update the bucket number in a circular way */
  update(int init, int newBucketNum, int jump){
    _logger.debug(() => "update() - Begins");
    _logger.debug(() => "update() - Position <$init> (init variable) is pointing to bucket ${newBucketNum.toString()}");
    _hashMap[init] = newBucketNum;
    var i=1;
    var pointer = 0;
    while (true){
      pointer = (init + jump*i) % _hashMap.length;
      i++;
      if(pointer == init){
        break;
      }
      //print("________ point:" + pointer.toString());
      //_logger.debug(() => "update() - Updating the hash table");
      _hashMap[pointer]= newBucketNum;
    }     
    _logger.debug(() => "update() - END");
  }
  
  /* Used in deletion algorithm, return replacemment bucket number if init+jump and init-jump are equal if not return -1 */
  int review(int init, int jump){
    _logger.debug(() => "review() - Begins");
    _logger.debug(() => "review() - Initial position: $init");
    _logger.debug(() => "review() - Jump value: $jump");
    int result = -1;
    var pAfter = (init + jump) % _hashMap.length;
    var pBefore = (init - jump) % _hashMap.length;

    //print("<Directory> *Review Directory* p_after:" + p_after.toString());
    //print("<Directory> *Review Directory* p_before:" + p_before.toString());
    //print("<Directory> *Review Directory* Dir:" + _hashMap.toString());

    if (_hashMap[pAfter] == _hashMap[pBefore]){
        //Then it is possible to free the bucket
        _logger.debug(() => "review() - Bucket numbers are equal");
        result = _hashMap[pAfter];
    }
    _logger.debug(() => "review() - END");
    return result;
  }
  /* Used in deletion algorithm, reduce the table if the first half is equal to the second one*/
  void reduceIfMirrowed(){
    _logger.debug(() => "reduceIfMirrowed() - Begins");
    //check if the first half of the directory is the same as the last one.
    var halfList = _hashMap.sublist(0,(_hashMap.length/2).ceil());
    var backList = _hashMap.sublist((_hashMap.length/2).ceil(),_hashMap.length);
    //print("HalfList:" + halfList.toString());
    //print("BackList:" + backList.toString());
    
    if (_listEquals(halfList,backList)){
      _hashMap = halfList;
      _logger.debug(() => "reduceIfMirrowed() - The hash table must be reduce it");
      _logger.debug(() => "reduceIfMirrowed() - New hash table: ${halfList.toString()}");  
    }
    _logger.debug(() => "reduceIfMirrowed() - END");
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
    return "T=${_hashMap.length} - Table:$_hashMap";
  }

}