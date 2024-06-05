import 'package:flutter/material.dart';

class HashingTableWidget extends StatefulWidget {
  final List<int?> initialValues;

  HashingTableWidget({this.initialValues = const []});

  @override
  State<StatefulWidget> createState() {
    return _HashingTableWidgetState();
  }
}

class _HashingTableWidgetState extends State<HashingTableWidget> {
  late List<int?> values;

  @override
  void initState() {
    values = List.from(widget.initialValues);
    super.initState();
  }

  Widget buildRecord(int position, int? value) {
    return Row(
      children: [
        Container(
          width: 30,
          padding: EdgeInsets.all(4),
          child: Center(child: Text(position.toString())),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(4),
          margin: EdgeInsets.all(1),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(child: Text(value?.toString() ?? '')),
        ))
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
              width: 30,
              padding: EdgeInsets.all(4),
              child: const Center(child: Text("#", style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              Expanded (
                child: Container(
                    padding: EdgeInsets.all(4),
                    child: const Center(child: Text("Bucket #", style: TextStyle(fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: getWidgets(),
              )),
        ],
      ),
    );
  }

  List<Widget> getWidgets(){
  return values.indexed.map((i) {
              return buildRecord(i.$1, i.$2);
            }).toList();
}
}