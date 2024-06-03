import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final values = [0, 1, 2, 3, 4, 5, null, null, null];

    final buckets = [
      Bucket(position: 0, status: BucketStatus.Active, b: 2, records: [100, 200]),
      Bucket(position: 1, status: BucketStatus.Full, b: 3, records: [101,300, 405]),
      Bucket(position: 2, status: BucketStatus.Active, b: 2, records: [345,]),
      Bucket(position: 3, status: BucketStatus.Freed, b: 1, records: []),
      Bucket(position: 4, status: BucketStatus.Empty, b: 1, records: []),
      Bucket(position: 5, status: BucketStatus.Active, b: 1, records: [123]),
      Bucket(position: 6, status: BucketStatus.Full, b: 1, records: [11,5000, 1000]),
      Bucket(position: 7, status: BucketStatus.Freed, b: 1, records: []),
    ];
    /*
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hashing example')),
        body: Row(
          children: [
            ConstrainedBox(constraints: BoxConstraints(maxWidth: 150), child: HashingTable(initialValues: values)),
            Spacer(),
            DirectFile(bucketRecordCapacity: 3, initialBuckets: buckets)
            // ConstrainedBox(constraints: BoxConstraints(minWidth: 300), child: DirectFile()),
          ],
        ),
      ),
    );*/
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Hashing example')),
        body: InteractiveViewer(
          //clipBehavior: Clip.none,
          //maxScale: 3.0,
          //minScale: 0.01,
          child: Row( 
            children: <Widget> [ myWidgets(context,values)]
        ),
      ),
      ),
    );
  }
}

Widget myWidgets(BuildContext context, List<int?> values){
    const double size01 = 20.0;
    const double size02 = 25.0;
    return Expanded(
        child: Column(
      children: [
        Expanded(
            child: Container(
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Hashing Table",
                          style: TextStyle(
                              fontSize: size01, fontWeight: FontWeight.bold)),
                    ]))), // Text Top
        Expanded(
            child: Container(
                color: Colors.white,
                child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 150), child: HashingTable(initialValues: values)
                )
              )
            ),
        Expanded(
            child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  color: Colors.red,
                  child: const Center(
                      child: Text("Red Color",
                          style: TextStyle(fontSize: size02))))),
          Expanded(
              child: Container(
                  color: Colors.yellow,
                  child: const Center(
                      child: Text("Yellow Color",
                          style: TextStyle(fontSize: size02))))),
          Expanded(
              child: Container(
                  color: Colors.orange,
                  child: const Center(
                      child: Text("Orange Color",
                          style: TextStyle(fontSize: size02))))),
        ])), //Row 1/2

        Expanded(
            child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  color: Colors.green,
                  child: const Center(
                      child: Text("Green Color",
                          style: TextStyle(fontSize: size02))))),
          Expanded(
              child: Container(
                  color: Colors.blue,
                  child: const Center(
                      child: Text("Blue Color",
                          style: TextStyle(fontSize: size02))))),
        ])), //Row 2/2
        Expanded(
            child: Container(
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("¿What's your favourite color?",
                          style: TextStyle(
                              fontSize: size01, fontWeight: FontWeight.bold))
                    ]))), // Text Bottom
      ],
    ));
  }

class HashingTable extends StatefulWidget {
  final List<int?> initialValues;

  HashingTable({this.initialValues = const []});

  @override
  State<StatefulWidget> createState() {
    return _HashingTableState();
  }
}

class _HashingTableState extends State<HashingTable> {
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
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: values.indexed.map((i) {
              return buildRecord(i.$1, i.$2);
            }).toList(),
          )),
    );
  }
}

class DirectFile extends StatefulWidget {
  final List<Bucket> initialBuckets;
  final int bucketRecordCapacity;
  DirectFile({required this.bucketRecordCapacity, this.initialBuckets = const []});

  @override
  State<StatefulWidget> createState() {
    return _DirectFileState();
  }
}

enum BucketStatus {
  Active,
  Full,
  Freed,
  Empty;

  @override
  String toString() => name;
}

class Bucket {
  Bucket({required this.position, required this.status, required this.b, this.records = const []});

  int position;
  BucketStatus status;
  int b;
  List<int> records;
}

class _DirectFileState extends State<DirectFile> {
  late List<Bucket> buckets;

  @override
  void initState() {
    buckets = List.from(widget.initialBuckets);
    super.initState();
  }

  Widget buildBucket({required int position, required BucketStatus status, required int b, List<int> records = const []}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Center(child: Text(position.toString())),
                ),
                Container(
                  width: 70,
                  padding: EdgeInsets.all(4),
                  child: Center(child: Text(status.toString())),
                )
              ],
            )),
        Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Center(child: Text(position.toString())),
                ),
                Container(
                  // padding: EdgeInsets.all(4),
                  child: Row(
                    children: [
                      for (var i = 0; i < widget.bucketRecordCapacity; i++)
                        Container(
                          width: 80,
                          padding: EdgeInsets.all(1),
                          margin: EdgeInsets.all(2) + EdgeInsets.only(left: 2),
                          decoration:
                              BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Center(child: Text(i < records.length ? records[i].toString() : '')),
                        )
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
              BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: const Offset(0, 3)),
            ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [for (var b in buckets) buildBucket(position: b.position, status: b.status, b: b.b, records: b.records)])));
  }
}