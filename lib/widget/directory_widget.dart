import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_transition.dart';

class HashingTableWidget extends StatefulWidget {
  final DirectoryTransition? currentTransition;

  const HashingTableWidget({super.key, this.currentTransition});
  

  @override
  State<StatefulWidget> createState() {
    return _HashingTableWidgetState();
  }
}

class _HashingTableWidgetState extends State<HashingTableWidget> {
  late List<int?> values;

  @override
  void initState() {
    super.initState();
  }

  Widget buildRecord(int position, int? value) {
    
    Color colorBox = Colors.blue.shade50;
    TextStyle textStyleForValue = TextStyle(fontWeight: FontWeight.normal);
    if ( widget.currentTransition?.hashTablePosition == position && widget.currentTransition!.bucketOverflowedId >= 0){
        colorBox = Color.fromARGB(255, 247, 75, 84);
    }else if (widget.currentTransition?.hashTablePosition == position && widget.currentTransition!.bucketCreatedId >= 0 ){
        colorBox = Color.fromARGB(255, 111, 245, 58);
    }else if (widget.currentTransition?.hashTablePosition == position && widget.currentTransition?.currentType.name == "hashTablePointedBucket" ){
        colorBox = Color.fromARGB(255, 241, 162, 44);
        textStyleForValue = TextStyle(fontWeight: FontWeight.bold);
    }else if (widget.currentTransition?.hashTablePosition == position && (widget.currentTransition?.currentType.name == "bucketFound" || widget.currentTransition?.currentType.name == "recordFound")){
        colorBox = Color.fromARGB(255, 233, 152, 179);
    }

    if (widget.currentTransition?.hashTablePosition1 == position || widget.currentTransition?.hashTablePosition2 == position ){
        colorBox = Color.fromARGB(255, 224, 240, 7);
    } 
    
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
          decoration: BoxDecoration( color: colorBox, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(child: Text(value?.toString() ?? '', style: textStyleForValue)),
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(children:[ 
                            Container(
                                  child: const Center(child: Text("Hashing Table", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),                  
                                ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), 
                                                child: Container(
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
                                              ) )
                            ],
                  );
  }

  List<Widget> getWidgets(){
  values = List.from(widget.currentTransition?.getTransition()?.hash as Iterable);
  return values.indexed.map((i) {
              return buildRecord(i.$1, i.$2);
            }).toList();
}
}