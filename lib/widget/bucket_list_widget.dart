import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/bucket_list_transition.dart';
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
  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
    super.dispose();
  }

  Widget buildBucket({required int position, required BucketStatus status, required int b, List<BaseRegister> records = const []}) {
    _logger.trace(() => "Building Widgets for Bucket");
    Color bucketColorByTransition;
    Color recordColor;
    Color colorCircle = Colors.blue.shade50;
    Color colorCircleShadow = Colors.blue.shade50;
    TextStyle textStyleForHashingBits = const TextStyle(fontWeight: FontWeight.normal);
    if (widget.currentTransition?.bucketOverflowedId == position) {
      bucketColorByTransition = const Color.fromARGB(255, 247, 75, 84);
    } else if (widget.currentTransition?.bucketCreatedId == position) {
      bucketColorByTransition = const Color.fromARGB(255, 111, 245, 58);
    } else if (widget.currentTransition?.bucketReorganizedId == position) {
      bucketColorByTransition = const Color.fromARGB(255, 236, 243, 145);
    } else if (widget.currentTransition?.bucketFreedId == position) {
      bucketColorByTransition = const Color.fromARGB(255, 111, 120, 241);
    } else if (widget.currentTransition?.bucketEmptyId == position) {
      bucketColorByTransition = const Color.fromARGB(255, 231, 195, 118);
    } else if (widget.currentTransition?.bucketFoundId == position) {
      bucketColorByTransition = const Color.fromARGB(255, 233, 152, 179);
    } else {
      bucketColorByTransition = Colors.blue.shade50;
    }
    recordColor = bucketColorByTransition;
    colorCircle = bucketColorByTransition;
    colorCircleShadow = bucketColorByTransition;

    bool isHighlightedBucket = true;
    Color bucketColorPosition;
    if (widget.currentTransition?.bucketOverflowedId == position) {
      bucketColorPosition = const Color.fromARGB(255, 247, 75, 84);
    } else if (widget.currentTransition?.bucketCreatedId == position) {
      bucketColorPosition = const Color.fromARGB(255, 111, 245, 58);
    } else if (widget.currentTransition?.bucketFoundId == position && widget.currentTransition?.bucketFreedId == position) {
      bucketColorPosition = const Color.fromARGB(255, 111, 120, 241);
    } else if (widget.currentTransition?.bucketFoundId == position && widget.currentTransition?.bucketEmptyId == position) {
      bucketColorPosition = const Color.fromARGB(255, 231, 195, 118);
    } else if (widget.currentTransition?.bucketFoundId == position) {
      bucketColorPosition = const Color.fromARGB(255, 233, 152, 179);
    } else if (widget.currentTransition?.bucketReorganizedId == position) {
      bucketColorPosition = const Color.fromARGB(255, 236, 243, 145);
    } else {
      bucketColorPosition = Colors.blue.shade50;
      isHighlightedBucket = false;
    }

    if (isHighlightedBucket && verticalScrollController.hasClients) {
      double jumpTarget = max((position - 2) * 30, 0);
      verticalScrollController.jumpTo(min(verticalScrollController.position.maxScrollExtent, jumpTarget));
    }

    if (widget.currentTransition?.type.name == "bucketUpdateHashingBits" &&
        (widget.currentTransition?.bucketCreatedId == position ||
            widget.currentTransition?.bucketOverflowedId == position ||
            widget.currentTransition?.bucketFoundId == position)) {
      textStyleForHashingBits = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
      colorCircle = Colors.black;
      colorCircleShadow = bucketColorByTransition.withOpacity(0.2);
    }

    List<Color> recordColors = [];
    for (var i = 0; i < widget.bucketRecordCapacity; i++) {
      recordColors.add(recordColor);
    }

    for (var i = 0; i < records.length; i++) {
      if (widget.currentTransition?.type.name == "recordFound" &&
          widget.currentTransition!.recordFound?.value == records[i].value &&
          widget.currentTransition?.getBucketList()[position].status.name != "freed") {
        recordColors[i] = const Color.fromARGB(255, 238, 213, 103);
      }
      if (widget.currentTransition?.type.name == "recordSaved" &&
          widget.currentTransition?.recordSaved?.value == records[i].value &&
          widget.currentTransition?.getBucketList()[position].status.name != "freed") {
        recordColors[i] = const Color.fromARGB(255, 153, 1, 153);
      }
    }

    if (widget.currentTransition?.type.name == "recordDeleted" && widget.currentTransition?.bucketFoundId == position) {
      recordColors[widget.currentTransition!.recordDeletedPositionInBucket] = const Color.fromARGB(255, 153, 1, 26);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(color: bucketColorPosition, borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                  child: Center(child: Text(widget.currentTransition!.bucketReorganizedId == position ? "" : status.toString())),
                )
              ],
            )),
        Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(color: bucketColorByTransition, borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                Container(
                  width: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(border: Border(right: BorderSide(color: Colors.black))),
                  child: Container(
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
                      child: Center(child: Text(" $b ", style: textStyleForHashingBits))),
                ),
                Row(
                  children: [
                    for (var i = 0; i < widget.bucketRecordCapacity; i++)
                      Container(
                        width: 80,
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.all(2) + const EdgeInsets.only(left: 2),
                        decoration: BoxDecoration(
                            color: recordColors[i],
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text((i < records.length && widget.currentTransition!.bucketReorganizedId != position)
                                ? records[i].toString()
                                : '')),
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
    _logger.trace(() => "Building Widgets for transition ${widget.currentTransition!.toString()}");
    buckets = List.from(widget.currentTransition!.getBucketList());
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Container(
            alignment: Alignment.topCenter,
            child: const Center(child: Text("File", style: TextStyle(fontWeight: FontWeight.bold))),
          ),
          Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: const [
                BoxShadow(color: Colors.black87, spreadRadius: 5, blurRadius: 7, offset: Offset(0, 3)),
              ]),
              child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
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
                                    //alignment: Alignment.centerLeft,
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
                                    child: const Center(child: Text("Bits", style: TextStyle(fontWeight: FontWeight.bold))),
                                  ),
                                  Row(
                                    children: [
                                      for (var i = 0; i < widget.bucketRecordCapacity; i++)
                                        Container(
                                          width: 80,
                                          padding: const EdgeInsets.all(1),
                                          child: Center(child: Text("Record $i", style: const TextStyle(fontWeight: FontWeight.bold))),
                                        ),
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ),
                      LimitedBox(
                          maxHeight: constraints.maxHeight - 90,
                          child: SingleChildScrollView(
                              controller: verticalScrollController,
                              scrollDirection: Axis.vertical,
                              child: Column(children: [
                                for (var b in buckets) buildBucket(position: b.id, status: b.status, b: b.bits, records: b.getList())
                              ])))
                    ],
                  ))),
        ],
      );
    });
  }
}
