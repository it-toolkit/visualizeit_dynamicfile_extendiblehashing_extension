import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/direct_file_widget.dart';

void main() {
  DirectFile myfile = DirectFile(3); 

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

  //Transition 1
  //DirectFileTransition transition = DirectFileTransition.bucketFound(myfile, 1);
  //Transition 2
  //DirectFileTransition transition = DirectFileTransition.bucketOverflowed(myfile, 1);
  //Transition 3 (Duplicate the hashing table)
  //DirectFileTransition transition = DirectFileTransition.hashTableDuplicateSize(myfile, 4);
  //Transition 4 (creating new bucket)
  //DirectFileTransition transition = DirectFileTransition.bucketCreated(myfile, 2, 4);
  //Transition 5 (reordering records - empty overflowed bucket)
  //DirectFileTransition transition = DirectFileTransition.bucketReorganized(myfile, 3);
  //Transition 6 to N (reordering records - reinserting the record)
  // Saving Record
  //DirectFileTransition transition = DirectFileTransition.recordSaved(myfile, 6, FixedLengthRegister(270));
  // Different Transition
  //DirectFileTransition transition = DirectFileTransition.recordFound(myfile, 6, FixedLengthRegister(270));
  // Transition bucket Freed
  // DirectFileTransition transition = DirectFileTransition.bucketFreed(myfile, 3);
  
  // Transition bucket Empty
  DirectFileTransition transition = DirectFileTransition.bucketEmpty(myfile, 4);
  runApp(MyApp(myfile, transition));
}

class MyApp extends StatelessWidget {
  final DirectFile file;
  final DirectFileTransition fileTransition;
  
  const MyApp(this.file, this.fileTransition, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Hashing Extensible example', style: TextStyle(fontWeight: FontWeight.bold))),
        body: DirectFileExtendibleHashingWidget(file, fileTransition)
      ),
    );
  }
}


