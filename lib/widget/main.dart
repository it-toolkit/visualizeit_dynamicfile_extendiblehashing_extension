import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/direct_file_widget.dart';

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

  //README: THIS did not work if you do not create an observer.
  //Transition 1
  //DirectFileTransition transition = DirectFileTransition.bucketFound(myfile, myfile.getFileContent(), myfile.getDirectory(), 2, 1);
  //Transition 2
  //DirectFileTransition transition = DirectFileTransition.bucketOverflowed(myfile, myfile.getFileContent(), myfile.getDirectory(), 2, 1);
  //Transition 2.1
  //DirectFileTransition transition = DirectFileTransition.bucketUpdateHashingBits(myfile,myfile.getFileContent(), myfile.getDirectory(), 6, TransitionType.bucketOverflowed);
  //Transition 3 (Duplicate the hashing table)
  //DirectFileTransition transition = DirectFileTransition.hashTableDuplicateSize(myfile, myfile.getFileContent(), myfile.getDirectory());
  //Transition 4 (creating new bucket)
  //DirectFileTransition transition = DirectFileTransition.bucketCreated(myfile, myfile.getFileContent(), myfile.getDirectory(), 2, 1);
  //Transition 4.1
  //DirectFileTransition transition = DirectFileTransition.bucketUpdateHashingBits(myfile, -1, 4, TransitionType.bucketCreated);
  //Transition 5 (reordering records - empty overflowed bucket)
  //DirectFileTransition transition = DirectFileTransition.bucketReorganized(myfile, myfile.getFileContent(), myfile.getDirectory(), 6);
  //Transition 6 to N (reordering records - reinserting the record)
  // Saving Record
  //DirectFileTransition transition = DirectFileTransition.recordSaved(myfile, myfile.getFileContent(), myfile.getDirectory(), 5, 2, FixedLengthRegister(426));
  // Different Transition
  //DirectFileTransition transition = DirectFileTransition.recordFound(myfile, myfile.getFileContent(), myfile.getDirectory(), 1, 2, FixedLengthRegister(270));
  // Transition bucket Freed
  //DirectFileTransition transition = DirectFileTransition.bucketFreed(myfile, myfile.getFileContent(), myfile.getDirectory(),3);
  
  // Transition bucket Empty (used in deletion)
  //DirectFileTransition transition = DirectFileTransition.bucketEmpty(myfile, myfile.getFileContent(), myfile.getDirectory(), 2);

  // Transition Hash table updated (for creation)
  //DirectFileTransition transition = DirectFileTransition.hashTableUpdated(myfile,myfile.getFileContent(), myfile.getDirectory(), 4, 3, TransitionType.bucketCreated);
  // Transition Hash table updated (for record deletion)
  //DirectFileTransition transition = DirectFileTransition.hashTableUpdated(myfile, myfile.getFileContent(), myfile.getDirectory(), 4, 3, TransitionType.recordDeleted);

  // Transition Record deleted.
  //DirectFileTransition transition = DirectFileTransition.recordDeleted(myfile,myfile.getFileContent(), myfile.getDirectory(), 1, 0, 3, FixedLengthRegister(549));

   // Transition Update Hashing bits in buckets. this occurs when the bucket is overflowed, and when the bucket is freed or rewrited empty.
  //DirectFileTransition transition = DirectFileTransition.bucketUpdateHashingBits(myfile, 4, TransitionType.bucketFreed);

  DirectFileTransition transition = DirectFileTransition.usingBucketFreed(myfile, myfile.getFileContent(), myfile.getDirectory(), 3);



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
        appBar: AppBar(title: const Text('Extendible Hashing Sample', style: TextStyle(fontWeight: FontWeight.bold))),
        body: DirectFileExtendibleHashingWidget(fileTransition, DirectFileExtendibleHashingInsertCommand(0, "SomeModelName"))
      ),
    );
  }
}


