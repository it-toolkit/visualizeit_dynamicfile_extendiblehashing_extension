import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';


void main() {
  //FixedLengthRegister flreg1 = FixedLengthRegister("385");
  //print(flreg1.value);
  //Bucket myBucket1 = Bucket(3, flreg1, "1");
  //print(myBucket1.toString());
  //myBucket1.setValue(FixedLengthRegister("276"));
  //myBucket1.setValue(FixedLengthRegister("345"));
  //print(myBucket1.toString());
  //myBucket1.setValue(FixedLengthRegister("444"));
  //print(myBucket1.toString());
  //print("Test:${myBucket1.getValue(FixedLengthRegister("276"))}");
  //myBucket1.getValue(FixedLengthRegister("323"));

  DirectFile myfile = DirectFile(3);
  print("My file status:");
  myfile.status();
  myfile.insert(FixedLengthRegister(270));
  myfile.insert(FixedLengthRegister(946));
  myfile.insert(FixedLengthRegister(741));
  myfile.status();
  myfile.insert(FixedLengthRegister(446));
  myfile.status();
  myfile.insert(FixedLengthRegister(123));
  myfile.status();
  myfile.insert(FixedLengthRegister(376));
  myfile.status();
  myfile.insert(FixedLengthRegister(458));
  myfile.status();
  //if (myfile.exist(FixedLengthRegister(458))){
  //  print("The object exists!");
  //}
  //myfile.insert(FixedLengthRegister(458));
  //myfile.status();
  myfile.insert(FixedLengthRegister(954));
  myfile.status();
  myfile.insert(FixedLengthRegister(973));
  myfile.status();
  myfile.insert(FixedLengthRegister(426));
  myfile.status();
  myfile.insert(FixedLengthRegister(410));
  myfile.status();
  //Testing second algoritm for insertion.
  myfile.insert(FixedLengthRegister(789));
  myfile.status();


}
