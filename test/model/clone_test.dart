
import 'package:visualizeit_dynamicfile_extendiblehashing/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';


void main() {
DirectFile myfile1 = DirectFile(2);

myfile1.insert(FixedLengthRegister(270)) ;

DirectFile myfileClone = myfile1.clone();

myfileClone.insert(FixedLengthRegister(380));
print("My file status:");
myfile1.status();
myfileClone.status();


myfile1.getDirectory().hash.add(122);
myfile1.getFreedList().add(3);
var myBucket = Bucket(2,1);
myBucket.setValue(FixedLengthRegister(3450));
myfile1.getFileContent().add(myBucket);
myfile1.getFileContent()[0].bits = 23;
myfile1.status();
myfileClone.status();

}