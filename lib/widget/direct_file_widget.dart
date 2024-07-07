import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/bucket_list_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/directory_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/freed_list_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/bucket_list_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/directory_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/freed_bucket_list_widget.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("extension.extendiblehashing.directfilewidget");

class DirectFileExtendibleHashingWidget extends StatefulWidget {
  final DirectFile _initFile;
  final DirectFileTransition? _currentTransition;
  final DirectFileExtendibleHashingCommand? commandInExecution;

  const DirectFileExtendibleHashingWidget(this._initFile, this._currentTransition, this.commandInExecution, {super.key});

  @override
  State<DirectFileExtendibleHashingWidget> createState() {
    return _DirectFileExtendibleHashingWidgetState();
  }
}

class _DirectFileExtendibleHashingWidgetState extends State<DirectFileExtendibleHashingWidget> {
  _DirectFileExtendibleHashingWidgetState();

  @override
  void initState() {
    super.initState();
  }

  String? getInternalBannerMessage() => widget._currentTransition?.getMessage();

  Widget getInternalBanner({required String message}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const [
            BoxShadow(blurRadius: 5),
          ]),
      child: Center(
        child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Row buildColorReferenceRow(Color color, final String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomPaint(
          size: const Size(10, 10),
          painter: RoundedRectanglePainter(color),
        ),
        SizedBox(
          width: 138,
          height: 20,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
            ),
          ),
        ),
      ],
    );
  }

  getLeftBanner(double width, int? bucketRecordCapacity, int? hashTableLen) {
    String? commandDescription = widget.commandInExecution?.toString() ?? "-";
    return Container(
      width: width,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: const [BoxShadow(blurRadius: 5)]),
      child: Column(
        children: [
          Text(commandDescription, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("Bucket capacity: $bucketRecordCapacity"),
          Text("T - Hashing Table Size: $hashTableLen"),
        ],
      ),
    );
  }

  Widget createWidgetsFromFile() {
    _logger.trace(() => "Creating all widgets for the file");
    HashingTableWidget hashingTableWidget;
    Widget bucketListWidget;
    Widget freedBucketListWidget;
    bool freedBucketListisNotEmpty = false;

    var currentTransition = widget._currentTransition;
    if (currentTransition != null) {
      _logger.trace(() => "Widgets for transition  ${currentTransition.toString()}");
      hashingTableWidget = HashingTableWidget(currentTransition: currentTransition.getDirectoryTransition());
      bucketListWidget =
          BucketListWidget(currentTransition.getBucketListTransition(), currentTransition.getTransitionFile()!.bucketRecordCapacity());
      freedBucketListWidget = FreedBucketListWidget(currentTransition: currentTransition.getFreedListTransition());
      freedBucketListisNotEmpty = currentTransition.getFreedListTransition().getFreedList().isNotEmpty;
    } else {
      _logger.trace(() => "Widgets for the initial state");
      TransitionType initialState = TransitionType.fileIsEmpty;
      var initFile = widget._initFile;
      if (initFile.getFileContent().isNotEmpty) {
        initialState = TransitionType.fileIsNotEmpty;
        _logger.trace(() => ">>>>>- File is not Empty");
      }
      hashingTableWidget = HashingTableWidget(currentTransition: DirectoryTransition(initFile.getDirectory(), initialState));
      bucketListWidget = BucketListWidget(
          BucketListTransition(initialState, initFile.bucketRecordCapacity(), initFile.getFileContent()), initFile.bucketRecordCapacity());
      freedBucketListWidget = FreedBucketListWidget(currentTransition: FreedListTransition(initFile.getFreedList()));
      freedBucketListisNotEmpty = initFile.getFreedList().isNotEmpty;
    }

    return LayoutBuilder(builder: (context, constraints) {
      const headerRowHeight = 100.0;

      return Column(
        children: [
          buildHeaderRow(headerRowHeight, constraints), //First Row
          Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
            LimitedBox(
                maxHeight: min(90 + 30.0 * (hashingTableWidget.currentTransition?.getTransition()?.hash.length ?? 1), constraints.maxHeight - headerRowHeight),
                maxWidth: 220,
                child: hashingTableWidget),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (freedBucketListisNotEmpty) Padding(padding: const EdgeInsets.only(bottom: 10), child: freedBucketListWidget),
                LimitedBox(
                  maxHeight: constraints.maxHeight - headerRowHeight - (freedBucketListisNotEmpty ? 110 : 0),
                  maxWidth: constraints.maxWidth - 220,
                  child: bucketListWidget,
                ),
              ],
            ),
          ]), //2 row
        ],
      );
    });
  }

  LimitedBox buildHeaderRow(double headerRowHeight, BoxConstraints constraints) {
    String? internalBannerMessage = getInternalBannerMessage();
    int? bucketRecordCapacity;
    int hashTableLen;

    var currentTransition = widget._currentTransition;
    if (currentTransition != null) {
      bucketRecordCapacity = currentTransition.getTransitionFile()?.bucketRecordCapacity();
      hashTableLen = currentTransition.getDirectoryTransition()!.getTransition()!.len;
    } else {
      bucketRecordCapacity = widget._initFile.bucketRecordCapacity();
      hashTableLen = widget._initFile.getDirectory().len;
    }

    return LimitedBox(
        maxHeight: headerRowHeight,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.all(10), child: getLeftBanner(200, bucketRecordCapacity, hashTableLen)),
          if (internalBannerMessage != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: LimitedBox(
                    maxWidth: constraints.maxWidth - 240,
                    child: Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: min(600, constraints.maxWidth - 240)),
                            child:getInternalBanner(message: internalBannerMessage),
                        ),
                    ),
                ),
              )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    _logger.trace(() => "Building widgets");
    return createWidgetsFromFile();
  }
}

class RoundedRectanglePainter extends CustomPainter {
  Color color;

  RoundedRectanglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.strokeWidth = 2;
    paint.color = color;
    canvas.drawRRect(RRect.fromLTRBR(0, 0, size.height, size.width, const Radius.circular(3)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
