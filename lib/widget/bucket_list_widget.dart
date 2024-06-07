import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/register.dart';

class BucketListWidget extends StatefulWidget {
  final List<Bucket> initialBuckets;
  final int bucketRecordCapacity;
  final DirectFileTransition? currentTransition;
  const BucketListWidget({super.key, required this.bucketRecordCapacity, this.initialBuckets = const [], this.currentTransition});

  @override
  State<StatefulWidget> createState() {
    return _BucketListWidgetState();
  }
}

class _BucketListWidgetState extends State<BucketListWidget> {
  late List<Bucket> buckets;

  @override
  void initState() {
    buckets = List.from(widget.initialBuckets);
    super.initState();
  }

  Widget buildBucket({required int position, required BucketStatus status, required int b, List<BaseRegister> records = const []}) {
    // ignore: non_constant_identifier_names
    Color BucketColorByTransition;
    if ( widget.currentTransition?.bucketOverflowedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 247, 75, 84);
    }else if (widget.currentTransition?.bucketCreatedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 111, 245, 58);
    }else if (widget.currentTransition?.bucketReorganizedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 236, 243, 145);
    }else{
        BucketColorByTransition = Colors.blue.shade50;
    }

    // ignore: non_constant_identifier_names
    Color BucketColorPosition;
    if ( widget.currentTransition?.bucketFoundId == position && widget.currentTransition?.bucketOverflowedId == position ){
        BucketColorPosition = Color.fromARGB(255, 247, 75, 84);
    }else if (widget.currentTransition?.bucketFoundId == position && widget.currentTransition?.bucketCreatedId == position ){
        BucketColorPosition = Color.fromARGB(255, 111, 245, 58);
    }else if (widget.currentTransition?.bucketFoundId == position ){
        BucketColorPosition = Color.fromARGB(255, 233, 152, 179);
    }else if (widget.currentTransition?.bucketReorganizedId == position ){
        BucketColorPosition = Color.fromARGB(255, 236, 243, 145);
    }else{
        BucketColorPosition = Colors.blue.shade50;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration( color: BucketColorPosition, borderRadius: const BorderRadius.all(Radius.circular(10))),
            //decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 70,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Center(child: Text(position.toString())),
                ),
                Container(
                  width: 70,
                  padding: EdgeInsets.all(4),
                  child: Center(child: Text(widget.currentTransition!.bucketReorganizedId == position ? "" : status.toString())),
                )
              ],
            )),
        Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(color:BucketColorByTransition, borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Center(child: Text(b.toString(), style: widget.currentTransition?.bucketOverflowedId == position ? TextStyle(fontWeight: FontWeight.bold) : TextStyle(fontWeight: FontWeight.normal))),
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
                          child: Center(child: Text((i < records.length && widget.currentTransition!.bucketReorganizedId != position) ? records[i].toString() : '')),
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
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [
              BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
            ]),
            child: Column(
              children: [
                Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.all(1),
                              //decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                children: [
                                  Container(
                                    width: 70,
                                    padding: EdgeInsets.all(4),
                                    alignment: Alignment.centerLeft,
                                    //decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                                    child: Center(child: Text("Cubeta #", style: const TextStyle(fontWeight: FontWeight.bold))),
                                  ),
                                  Container(
                                    width: 70,
                                    padding: EdgeInsets.all(4),
                                    child: Center(child: Text("Status", style: const TextStyle(fontWeight: FontWeight.bold))),
                                  )
                                ],
                              )),
                          Container(
                              margin: EdgeInsets.all(1),
                              //decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    padding: EdgeInsets.all(4),
                                    //decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                                    child: const Center(child: Text("Bits",style: TextStyle(fontWeight: FontWeight.bold))),
                                  ),
                                  Container(
                                    // padding: EdgeInsets.all(4),
                                    child: Row(
                                      children: [
                                        for (var i = 0; i < widget.bucketRecordCapacity; i++)
                                          Container(
                                            width: 80,
                                            padding: EdgeInsets.all(1),
                                            //margin: EdgeInsets.all(2) + EdgeInsets.only(left: 2),
                                            //decoration:
                                             //   BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
                                            child: Center(child: Text( "Registro $i", style: const TextStyle(fontWeight: FontWeight.bold))),
                                          ),
                                      ],
                                    ),
                                  )
                                ],
                              ))
                        ],
                    ),
                    for (var b in buckets) 
                      buildBucket(position: b.id, status: b.status, b: b.bits, records: b.getList())
              ],
            ), 
          ));
  }
}
