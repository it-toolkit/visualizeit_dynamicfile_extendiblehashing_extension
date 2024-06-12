import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file_observer.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/direct_file_widget.dart';

void main() {
  DirectFile myfile = DirectFile(3); 
  //var observer = DirectFileObserver<num>();
  var observer = DirectFileObserver();
  myfile.registerObserver(observer);
  myfile.insert(FixedLengthRegister(270));
  /*
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
  */
  print("# Transitions: ${observer.transitions.length}");
  runApp(MyApp(myfile, observer.transitions[4]));
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
        body: DirectFileExtendibleHashingWidget(file, fileTransition)
      ),
    );
  }
}
