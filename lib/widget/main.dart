import 'package:flutter/material.dart';
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

  runApp(MyApp(myfile));
}

class MyApp extends StatelessWidget {
  final DirectFile file;
  
  const MyApp(this.file, {super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Hashing Extensible example', style: TextStyle(fontWeight: FontWeight.bold))),
        body: DirectFileExtendibleHashingWidget(file)
      ),
    );
  }
}


