import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file_observer.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/direct_file_widget.dart';

void main() {
  DirectFile myfile = DirectFile(3); 
  var observer = DirectFileObserver();
  myfile.registerObserver(observer);
  //myfile.initObserver();
  myfile.insert(FixedLengthRegister(270));
  myfile.insert(FixedLengthRegister(946));
  myfile.insert(FixedLengthRegister(741));
  myfile.insert(FixedLengthRegister(446));
  myfile.insert(FixedLengthRegister(123));
  myfile.insert(FixedLengthRegister(376));
  myfile.insert(FixedLengthRegister(458));
  myfile.insert(FixedLengthRegister(954));
  myfile.insert(FixedLengthRegister(973));
  myfile.insert(FixedLengthRegister(426));
  
  /*
  myfile.insert(FixedLengthRegister(410));

  //Testing second algoritm for insertion.
  myfile.insert(FixedLengthRegister(789));
  myfile.insert(FixedLengthRegister(484));
  myfile.insert(FixedLengthRegister(305));
  myfile.insert(FixedLengthRegister(462));
  myfile.insert(FixedLengthRegister(809));
  myfile.insert(FixedLengthRegister(459));
  myfile.delete(FixedLengthRegister(305));
  myfile.delete(FixedLengthRegister(809));
  /*Testing 2ª delete algorithm*/
  myfile.delete(FixedLengthRegister(946));
  myfile.delete(FixedLengthRegister(410));
  myfile.delete(FixedLengthRegister(954));
  */

  print("# Transitions: ${observer.transitions.length}");

  //Transition 1 is Bucket Created.
  //Transition 5 bucket overflowed
  //Transition 6 Bucket created
  //Transition 21, Bucket reorganized
  //Transition 22, record 270 saved in bucket 1
  //Transition 26, Bucket 1 overflowed.
  //Transition 27, Bucket 2 created.
  //Transition 28, Bucket overflowed updating hashing bits
  //Transition 29, Bucket created, updating hashing bits
  //Transition 32, Duplicating Hashing table
  //Transition 33, updating Hashing table with the new bucket.(Orange color)
  //Transition 34, reorganization of bucket 1
  //Review this.
  //Transition 62, updating hashing table with new bucket.
  //Transition 67. updating hashing table
  //Transition 68. updading hashing table.
  //Transition 88, saving record 410.
  //Transition 90, Overflowed bucket
  //Transition 93, new bucket updating hashing bits.
  //Transition 94, adding new bucket to the hashing table in the position of the overflowed bucket.
  //Transition 95, first hashing table udpate.
  //Transition 103. Record Found in bucket
  //Transiton 104. bucket 4 in empty state.
  //Transition 105. Record found in bucket. (deleting 410)
  //Transition 106. Record deleted.
  //Transition 107. Updating replacment bucket bits. reducing the bits in 1.
  //Transition 108. Updating hashing table with the replacemente bucket
  //Transition 109, the bucket is marked as freed and is added to the freed bucket list.
  //Transition 110, reducing the hashing table (because the table is mirrowed)
  DirectFileTransition transition = observer.transitions[43];
  print(transition.type.name);
  runApp(MyApp(myfile, transition));
}

class MyApp extends StatelessWidget {
  final DirectFile file;
  final DirectFileTransition fileTransition;

  const MyApp(this.file,this.fileTransition,{super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Hashing Extensible example', style: TextStyle(fontWeight: FontWeight.bold))),
        body: DirectFileExtendibleHashingWidget(fileTransition)    
      ),
    );
  }
}
