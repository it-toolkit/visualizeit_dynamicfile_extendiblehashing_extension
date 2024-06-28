import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';


void main() {
  DirectFile myfile = DirectFile(3);
  print("My file status:");
  myfile.status();
  /* First insert algorithm test */
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

  //Continue adding
  myfile.insert(FixedLengthRegister(484));
  myfile.status();
  myfile.insert(FixedLengthRegister(305));
  myfile.status();
  myfile.insert(FixedLengthRegister(462));
  myfile.insert(FixedLengthRegister(809));
  myfile.insert(FixedLengthRegister(459));
  myfile.status();
  
  /*testing recursive algorithm*/
  /*
  myfile.insert(FixedLengthRegister(442));
  myfile.insert(FixedLengthRegister(506));
  myfile.insert(FixedLengthRegister(1466));
  myfile.status();
  */
  
  /*Testing 1ª delete algorithm*/
  
  print("//////////// Testing Delete ///////////");
  myfile.delete(FixedLengthRegister(305));
  myfile.delete(FixedLengthRegister(809));
  
  /*Testing 2ª delete algorithm*/
  myfile.delete(FixedLengthRegister(946));
  myfile.status();
  
  myfile.delete(FixedLengthRegister(410));
  myfile.delete(FixedLengthRegister(954));
  myfile.status();
  
  
  /* adding more values again*/
  /*
  myfile.insert(FixedLengthRegister(954));
  myfile.status();
  /* Testing insertion using freed list*/
  myfile.insert(FixedLengthRegister(32));
  myfile.status();
  
  myfile.insert(FixedLengthRegister(64));
  myfile.status();
  */
  /* Testing reusing the empty bucket */
  /*
  myfile.insert(FixedLengthRegister(64));
  myfile.status();
  */
}
