import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("extension.extendiblehashing.bucketlistwidget");

class BucketListWidget extends StatefulWidget {
  final BucketListTransition? currentTransition;
  final int bucketRecordCapacity;

  const BucketListWidget(this.currentTransition, this.bucketRecordCapacity, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _BucketListWidgetState();
  }
}

class _BucketListWidgetState extends State<BucketListWidget> {
  late List<Bucket> buckets;

  @override
  void initState() {
    super.initState();
  }

  Widget buildBucket({required int position, required BucketStatus status, required int b, List<BaseRegister> records = const []}) {
    
    // ignore: non_constant_identifier_names
    Color BucketColorByTransition;
    Color recordColor; 
    TextStyle textStyleForHashingBits = TextStyle(fontWeight: FontWeight.normal);
    if ( widget.currentTransition?.bucketOverflowedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 247, 75, 84);
    }else if (widget.currentTransition?.bucketCreatedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 111, 245, 58);
    }else if (widget.currentTransition?.bucketReorganizedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 236, 243, 145);
    }else if (widget.currentTransition?.bucketFreedId == position ){
        BucketColorByTransition = Color.fromARGB(255, 111, 120, 241);
    }else if (widget.currentTransition?.bucketEmptyId == position ){
        BucketColorByTransition = Color.fromARGB(255, 231, 195, 118);
    }else if (widget.currentTransition?.bucketFoundId == position ){
        BucketColorByTransition = Color.fromARGB(255, 233, 152, 179);
    }else{
        BucketColorByTransition = Colors.blue.shade50;
    }
    recordColor = BucketColorByTransition;

    // ignore: non_constant_identifier_names
    Color BucketColorPosition;
    if ( widget.currentTransition?.bucketOverflowedId == position ){
        BucketColorPosition = Color.fromARGB(255, 247, 75, 84);
    }else if (widget.currentTransition?.bucketCreatedId == position ){
        BucketColorPosition = Color.fromARGB(255, 111, 245, 58);
    }else if (widget.currentTransition?.bucketFoundId == position && widget.currentTransition?.bucketFreedId == position ){
        BucketColorPosition = Color.fromARGB(255, 111, 120, 241);
    }else if (widget.currentTransition?.bucketFoundId == position && widget.currentTransition?.bucketEmptyId == position ){
        BucketColorPosition = Color.fromARGB(255, 231, 195, 118);
    }else if (widget.currentTransition?.bucketFoundId == position ){
        BucketColorPosition = Color.fromARGB(255, 233, 152, 179);
    }else if (widget.currentTransition?.bucketReorganizedId == position ){
        BucketColorPosition = Color.fromARGB(255, 236, 243, 145);
    }else{
        BucketColorPosition = Colors.blue.shade50;
    }

    if (widget.currentTransition?.type.name == "bucketUpdateHashingBits" && ( widget.currentTransition?.bucketCreatedId == position || widget.currentTransition?.bucketOverflowedId == position || widget.currentTransition?.bucketFoundId == position )){
        textStyleForHashingBits = const TextStyle(color: Colors.white,backgroundColor: Colors.black, fontWeight: FontWeight.bold);
    }
    
    List<Color> recordColors = [];
    for (var i = 0; i < widget.bucketRecordCapacity; i++){
      recordColors.add(recordColor);
    }
    
    for (var i = 0; i < records.length; i++){
      if(widget.currentTransition?.type.name == "recordFound" && widget.currentTransition!.recordFound?.value == records[i].value && widget.currentTransition?.getBucketList()[position].status.name != "Freed" ) {
        recordColors[i] = Color.fromARGB(255, 238, 213, 103);
      }
      if(widget.currentTransition?.type.name == "recordSaved" && widget.currentTransition?.recordSaved?.value == records[i].value ) {
        recordColors[i] = Color.fromARGB(255, 153, 1, 153);
      }

    }

    if(widget.currentTransition?.type.name == "recordDeleted" && widget.currentTransition?.bucketFoundId == position) {   
        recordColors[widget.currentTransition!.recordDeletedPositionInBucket] = Color.fromARGB(255, 153, 1, 26);
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
                  child: Center(child: Text(" $b ", style: textStyleForHashingBits)),
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
                              BoxDecoration(color: recordColors[i],border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
                              //BoxDecoration(color: (widget.currentTransition!.isRecordFound && widget.currentTransition!.recordFound?.toString() == records[i].toString())? RecordFoundColor : RecordColor ,border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
                              //BoxDecoration(color: (widget.currentTransition!.isRecordFound && widget.currentTransition!.recordFound?.value == records[i].value )? RecordFoundColor : RecordColor ,border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
                              //BoxDecoration(color: RecordFoundColor,border: Border.all(color: Colors.grey), borderRadius: BorderRadius.all(Radius.circular(10))),
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
    buckets = List.from(widget.currentTransition!.getBucketList());
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
                                    child: Center(child: Text("Bucket #", style: const TextStyle(fontWeight: FontWeight.bold))),
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
                                            child: Center(child: Text( "Record $i", style: const TextStyle(fontWeight: FontWeight.bold))),
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
