import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [0, 1, 2, 3, 4, 5, 6, 2, 5];

    final buckets = [
      Bucket(position: 0, status: BucketStatus.active, b: 2, records: [100, 200]),
      Bucket(position: 1, status: BucketStatus.full, b: 3, records: [101,300, 405]),
      Bucket(position: 2, status: BucketStatus.active, b: 2, records: [345,]),
      Bucket(position: 3, status: BucketStatus.freed, b: 1, records: []),
      Bucket(position: 4, status: BucketStatus.empty, b: 1, records: []),
      Bucket(position: 5, status: BucketStatus.active, b: 1, records: [123]),
      Bucket(position: 6, status: BucketStatus.full, b: 1, records: [11,5000, 1000]),
      Bucket(position: 7, status: BucketStatus.freed, b: 1, records: []),
    ];

    final freedBuckets = [7,3];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Hashing Extensible example', style: TextStyle(fontWeight: FontWeight.bold))),
        body: Column(
          children: [
            Row(
              children: [
                Column( 
                  children:[ const Center(child: Text("Tabla de Hashing", style: TextStyle(fontWeight: FontWeight.bold))),
                              ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: HashingTable(initialValues: values))
                  ],
                  ),
                const Spacer(),
                Column( 
                  children:[ const Center(child: Text("Archivo Directo", style: TextStyle(fontWeight: FontWeight.bold))),
                              DirectFile(bucketRecordCapacity: 3, initialBuckets: buckets)
                  ],
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //const Spacer(),
                Column( 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Center(child: Text("Lista de Cubetas Libres", style: TextStyle(fontWeight: FontWeight.bold))),
                    ConstrainedBox(constraints: const BoxConstraints(maxHeight: 100),child: FreedList(freedBucketNumbers: freedBuckets)),
                  ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HashingTable extends StatefulWidget {
  final List<int?> initialValues;

  const HashingTable({super.key, this.initialValues = const []});

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
          padding: const EdgeInsets.all(4),
          child: Center(child: Text(position.toString())),
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(child: Text(value?.toString() ?? '')),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [
        BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
      ]),
      child: Column(
        children: [
          Row(
            children: [
              Container(
              width: 30,
              padding: const EdgeInsets.all(4),
              child: const Center(child: Text("#", style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              Expanded (
                child: Container(
                    padding: const EdgeInsets.all(4),
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

class FreedList extends StatefulWidget {
  final List<int?> freedBucketNumbers;

  const FreedList({super.key, this.freedBucketNumbers = const []});

  @override
  State<StatefulWidget> createState() {
    return _FreedListState();
  }
}

class _FreedListState extends State<FreedList> {
  late List<int?> freedBuckets;

  @override
  void initState() {
    freedBuckets = List.from(widget.freedBucketNumbers);
    super.initState();
  }

  Widget buildRecord(int? value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(child: Text(value.toString())),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [
        BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
      ]),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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



class DirectFile extends StatefulWidget {
  final List<Bucket> initialBuckets;
  final int bucketRecordCapacity;
  const DirectFile({super.key, required this.bucketRecordCapacity, this.initialBuckets = const []});

  @override
  State<StatefulWidget> createState() {
    return _DirectFileState();
  }
}
enum BucketStatus {
  active,
  full,
  freed,
  empty;

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
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Center(child: Text(position.toString())),
                ),
                Container(
                  width: 70,
                  padding: const EdgeInsets.all(4),
                  child: Center(child: Text(status.toString())),
                )
              ],
            )),
        Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Center(child: Text(b.toString())),
                ),
                Row(
                  children: [
                    for (var i = 0; i < widget.bucketRecordCapacity; i++)
                      Container(
                        width: 80,
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.all(2) + const EdgeInsets.only(left: 2),
                        decoration:
                            BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: Center(child: Text(i < records.length ? records[i].toString() : '')),
                      )
                  ],
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
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [
              BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
            ]),
            child: Column(
              children: [
                Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.all(1),                            
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.all(4),
                                    alignment: Alignment.centerLeft,                                  
                                    child: const Center(child: Text("Bucket #", style: TextStyle(fontWeight: FontWeight.bold))),
                                  ),
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.all(4),
                                    child: const Center(child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                                  )
                                ],
                              )),
                          Container(
                              margin: const EdgeInsets.all(1),                            
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    padding: const EdgeInsets.all(4),                                    
                                    child: const Center(child: Text("b",style: TextStyle(fontWeight: FontWeight.bold))),
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0; i < widget.bucketRecordCapacity; i++)
                                        Container(
                                          width: 80,
                                          padding: const EdgeInsets.all(1),                                          
                                          child: Center(child: Text( "Record $i", style: const TextStyle(fontWeight: FontWeight.bold))),
                                        ),
                                    ],
                                  )
                                ],
                              ))
                        ],
                    ),
                    for (var b in buckets) 
                      buildBucket(position: b.position, status: b.status, b: b.b, records: b.records)
              ],
            ), 
          ));
  }
}


