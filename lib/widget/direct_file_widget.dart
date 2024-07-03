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

  const DirectFileExtendibleHashingWidget(this._initFile,this._currentTransition,this.commandInExecution,
      {super.key});

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
Widget getInternalBanner(){
    if (widget._currentTransition != null && widget._currentTransition?.getMessage() != null){
      return Row(
                 children:[
                          Container(
                              width: 400,
                              height: 75,
                              padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                              decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black),
                                                    color: Colors.white,
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    boxShadow: const [ BoxShadow(blurRadius: 5),]
                                          ),
                              child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [ 
                                                    Text("${widget._currentTransition?.getMessage()}",style: const TextStyle(fontWeight: FontWeight.bold)),
                                            ],),
                              ),
                          ]
                      );
                                  
    } else {
      return const Spacer();
    }
  }

/*
  Widget getInternalBanner(){
    if (widget._currentTransition != null && widget._currentTransition?.getMessage() != null){
      return Column(
                    children: [
                                Row(
                                  children: [
                                    Column( 
                                      children:[ 
                                        Row(
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 400,
                                                height: 75,
                                                //margin: const EdgeInsets.only(right: 4, bottom: 4),
                                                decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.black),
                                                    color: Colors.white,
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    boxShadow: const [
                                                      BoxShadow(blurRadius: 5),
                                                    ]),
                                                child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [ 
                                                            Text("${widget._currentTransition?.getMessage()}",style: const TextStyle(fontWeight: FontWeight.bold)),
                                                          ],
                                                        ),
                                              ),
                                            ]
                                          )
                                        ],
                                      ) 
                                    ]
                                  )
                                ]
                );
    } else {
      return const Spacer();
    }
  }
*/
  Widget getInternalNote(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 170,
          height: 70,
          margin: const EdgeInsets.only(right: 2, bottom: 2),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: const [
                BoxShadow(blurRadius: 5),
              ]),
          child: Column(
            children: [
              buildColorReferenceRow(const Color.fromARGB(255, 111, 245, 58), "New bucket"),
              buildColorReferenceRow(const Color.fromARGB(255, 111, 120, 241), "Freed bucket"),
              buildColorReferenceRow(const Color.fromARGB(255, 247, 75, 84), "Overflowed bucket"),
            ],
          ),
        ),
      ],
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

  getLeftBanner(int? bucketRecordCapacity, int? hashTableLen){
    return Column(children:[ 
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                            Container(
                                              width: 170,
                                              height: 70,
                                              margin: const EdgeInsets.only(right: 2, bottom: 2),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  color: Colors.white,
                                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                  boxShadow: const [
                                                    BoxShadow(blurRadius: 5),
                                                  ]),
                                              child: Column(
                                                children: [ 
                                                  Text(widget.commandInExecution != null
                                                  ? widget.commandInExecution.toString()
                                                  : "", style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  Text("Bucket capacity: $bucketRecordCapacity",style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  Text("T - Hashing Table Size: $hashTableLen",style: const TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                ), 
                            ],
                  );
  }

  Widget createWidgetsFromFile() {
    _logger.trace(() => "Creating all widgets for the file"); 
    int? bucketRecordCapacity;
    int? hashTableLen;
    Widget? hashingTableWidget;
    Widget? bucketListWidget;
    Widget? freedBucketListWidget;
    bool freedBucketListisNotEmpty = false;
    
    if (widget._currentTransition != null){
      _logger.trace(() => "Widgets for transition  ${widget._currentTransition!.toString()}"); 
      bucketRecordCapacity = widget._currentTransition?.getTransitionFile()?.bucketRecordCapacity();
      hashTableLen = widget._currentTransition?.getDirectoryTransition()!.getTransition()!.len;
      hashingTableWidget = HashingTableWidget(currentTransition: widget._currentTransition?.getDirectoryTransition());
      bucketListWidget = BucketListWidget(widget._currentTransition!.getBucketListTransition(), widget._currentTransition!.getTransitionFile()!.bucketRecordCapacity());
      freedBucketListWidget = FreedBucketListWidget(currentTransition: widget._currentTransition!.getFreedListTransition());
      freedBucketListisNotEmpty = widget._currentTransition!.getFreedListTransition()!.getFreedList().isNotEmpty;
    } else{
      _logger.trace(() => "Widgets for the initial state"); 
      bucketRecordCapacity = widget._initFile.bucketRecordCapacity();
      hashTableLen = widget._initFile.getDirectory().len;
      hashingTableWidget = HashingTableWidget(currentTransition: DirectoryTransition(widget._initFile.getDirectory()));
      bucketListWidget = BucketListWidget(BucketListTransition(TransitionType.fileIsEmpty,widget._initFile.bucketRecordCapacity(), widget._initFile.getFileContent()), widget._initFile.bucketRecordCapacity());
      freedBucketListWidget = FreedBucketListWidget(currentTransition: FreedListTransition(widget._initFile.getFreedList()));
      freedBucketListisNotEmpty = widget._initFile.getFreedList().isNotEmpty;
    }
    return Column( children: [ 
            Row( children: [ 
              getLeftBanner(bucketRecordCapacity, hashTableLen),
              const Spacer(),
              getInternalBanner(),
              const Spacer(flex:2),
              //getInternalNote(),
            ] ),//First Row
            Row( 
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  const Spacer(),
                  hashingTableWidget,
                  const Spacer(flex: 2),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        bucketListWidget,
                        Row(
                            children: [ 
                              freedBucketListisNotEmpty ? 
                              freedBucketListWidget : 
                              const Column (crossAxisAlignment: CrossAxisAlignment.center,),
                            ]
                            ),
                        ],
                      ), 
                  const Spacer(),
                ]),//2 row
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    _logger.trace(() => "Building widgets"); 
    //return createWidgetsFromFile();
    return LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: createWidgetsFromFile(),
            ),
          );
        },
      );
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
    canvas.drawRRect(
        RRect.fromLTRBR(
            0, 0, size.height, size.width, const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}