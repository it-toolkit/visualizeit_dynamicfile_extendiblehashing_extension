import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/freed_list_transition.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("extension.extendiblehashing.freedbucketlistwidget");

class FreedBucketListWidget extends StatefulWidget {
  final FreedListTransition? currentTransition;

  const FreedBucketListWidget({super.key, this.currentTransition});

  @override
  State<StatefulWidget> createState() {
    return _FreedBucketListWidgetState();
  }
}

class _FreedBucketListWidgetState extends State<FreedBucketListWidget> {
  late List<int?> freedBuckets;

  @override
  void initState() {
    super.initState();
  }

  Widget buildRecord(int? value) {
    _logger.trace(() => "Creating Record for Freed List"); 
    Color recordColor = Colors.blue.shade50;
    if ( widget.currentTransition?.bucketFreedId == value ){
      recordColor = const Color.fromARGB(255, 111, 120, 241);
    }
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(color: recordColor, borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Center(child: Text(value.toString())),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) { 
    _logger.trace(() => "Creating Widgets for the Freed Bucket List"); 
    Widget myContainer = Container(
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

    return Column( 
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                              const Center(child: Text("Freed Bucket List", style: TextStyle(fontWeight: FontWeight.bold))),
                              ConstrainedBox(constraints: const BoxConstraints(maxHeight: 100), child: myContainer),
                   ]
                  ); 
  }

  List<Widget> getWidgets(){
    freedBuckets = List.from(widget.currentTransition!.getFreedList());
  return freedBuckets.indexed.map((i) {
              return buildRecord(i.$2);
            }).toList();
}
}