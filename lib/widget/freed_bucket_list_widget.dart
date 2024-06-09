import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';

class FreedBucketListWidget extends StatefulWidget {
  final List<int?> freedBucketNumbers;
  final DirectFileTransition? currentTransition;

  const FreedBucketListWidget({super.key, this.freedBucketNumbers = const [], this.currentTransition});

  @override
  State<StatefulWidget> createState() {
    return _FreedBucketListWidgetState();
  }
}

class _FreedBucketListWidgetState extends State<FreedBucketListWidget> {
  late List<int?> freedBuckets;

  @override
  void initState() {
    freedBuckets = List.from(widget.freedBucketNumbers);
    super.initState();
  }

  Widget buildRecord(int? value) {
    Color recordColor = Colors.blue.shade50;
    if ( widget.currentTransition?.bucketFreedId == value ){
      recordColor = Color.fromARGB(255, 111, 120, 241);
    }
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(color: recordColor, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(child: Text(value.toString())),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
        BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 3)),
      ]),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: getWidgets(),
          )),
    );
  }

  List<Widget> getWidgets(){
  return freedBuckets.indexed.map((i) {
              return buildRecord(i.$2);
            }).toList();
}
}