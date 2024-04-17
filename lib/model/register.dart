abstract class BaseRegister<T>{
  T? _value;
  late int _length;
  late String _status;

  T? get value => _value;
  int get length => _length;
  String get status => _status;
  String toString(){
    return _value.toString();
  }
}

class FixedLengthRegister<T> extends BaseRegister {

  FixedLengthRegister(T value){
    _value = value;
    _length = 0;
  }

}

class VariableLengthRegister<T> extends BaseRegister {

  VariableLengthRegister(T value, int length){
    _value = value;
    _length = length;
  }

}