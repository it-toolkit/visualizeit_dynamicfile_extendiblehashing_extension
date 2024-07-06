import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/directory_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("extension.extendiblehashing.directorywidget");

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
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    print("disposing");
    scrollController.dispose();
    super.dispose();
  }

  Widget buildRecord(int position, int? value) {
    _logger.trace(() => "Building Widget for Record");
    Color colorBox = Colors.blue.shade50;
    Color colorCircle = Colors.white;
    Color colorCircleShadow = Colors.white;
    TextStyle textStyleForValue = const TextStyle(fontWeight: FontWeight.normal);
    if (widget.currentTransition?.hashTablePosition == position && widget.currentTransition!.bucketOverflowedId >= 0) {
      colorBox = const Color.fromARGB(255, 247, 75, 84);
    } else if (widget.currentTransition?.hashTablePosition == position && widget.currentTransition!.bucketCreatedId >= 0) {
      colorBox = const Color.fromARGB(255, 111, 245, 58);
    } else if (widget.currentTransition?.hashTablePosition == position &&
        widget.currentTransition?.currentType == TransitionType.hashTablePointedBucket) {
      colorBox = const Color.fromARGB(255, 241, 162, 44);
      textStyleForValue = const TextStyle(fontWeight: FontWeight.bold);
    } else if (widget.currentTransition?.hashTablePosition == position &&
        (widget.currentTransition?.currentType == TransitionType.bucketFound ||
            widget.currentTransition?.currentType == TransitionType.recordFound ||
            widget.currentTransition?.currentType == TransitionType.recordNotFound)) {
      colorBox = const Color.fromARGB(255, 233, 152, 179);
    }

    if (widget.currentTransition?.hashTablePosition1 == position || widget.currentTransition?.hashTablePosition2 == position) {
      colorBox = const Color.fromARGB(255, 224, 240, 7);
    }

    var isHighlightedBucket = colorBox != Colors.blue.shade50;
    var isHighlightedBucketPosition = widget.currentTransition?.currentType == TransitionType.findingBucket && widget.currentTransition?.hashTablePosition == position;
    if (isHighlightedBucketPosition) {
      colorCircle = const Color.fromARGB(255, 233, 152, 179);
      colorCircleShadow = Colors.black.withOpacity(0.2);
    }

    if ((isHighlightedBucket || isHighlightedBucketPosition) && scrollController.hasClients) {
      double jumpTarget = max((position - 2) * 30, 0);
      scrollController.jumpTo(min(scrollController.position.maxScrollExtent, jumpTarget));
    }

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorCircle,
            boxShadow: [
              BoxShadow(
                color: colorCircleShadow,
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: Text(position.toString())),
        ),
        Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(color: colorBox, borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(child: Text(value?.toString() ?? '', style: textStyleForValue)),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _logger.trace(() => "Creating widgets for the hashing table $constraints");
      return Column(children: [
        const Center(child: Text("Hashing Table", style: TextStyle(fontWeight: FontWeight.bold))),

        ConstrainedBox(constraints: const BoxConstraints(maxWidth: 180),
            child: Container(
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Center(child: Text("Bucket #", style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                  (widget.currentTransition!.getTransition()!.hash.length == 1 &&
                      widget.currentTransition?.currentType == TransitionType.fileIsEmpty) ?
                  const Column() :
                  SizedBox(width: 200, height: constraints.maxHeight - 90, child: SingleChildScrollView(
                      controller: scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: getWidgets(),
                      ))),
                ],
              ),
            ))
      ]);
    });
  }

  List<Widget> getWidgets() {
    values = List.from(widget.currentTransition
        ?.getTransition()
        ?.hash as Iterable);
    return values.indexed.map((i) {
      return buildRecord(i.$1, i.$2);
    }).toList();
  }
}