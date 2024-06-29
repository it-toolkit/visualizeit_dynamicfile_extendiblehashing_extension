abstract class BaseRegister<T>{
  T? _value;
  late int _length;
  late String _status;

  T? get value => _value;
  int get length => _length;
  String get status => _status;
  
  @override
  String toString(){
    return _value.toString();
  }

  BaseRegister clone();
}

class FixedLengthRegister<T> extends BaseRegister {

  FixedLengthRegister(T value){
    _value = value;
    _length = 0;
  }
  
  @override
  BaseRegister clone() {
   return FixedLengthRegister(value);
  }

}

class VariableLengthRegister<T> extends BaseRegister {

  VariableLengthRegister(T value, int length){
    _value = value;
    _length = length;
  }
 @override
  BaseRegister clone() {
    return VariableLengthRegister(value, length);
  }

}