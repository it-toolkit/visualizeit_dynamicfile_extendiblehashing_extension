import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/bucket_list_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/directory_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/freed_bucket_list_widget.dart';

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
  //Widget? _components;

  _DirectFileExtendibleHashingWidgetState();

  @override
  void initState() {
    super.initState();
    //_components = createWidgetsFromFile();
  }

  Widget getInternalBanner(){
    if (widget._currentTransition != null && widget._currentTransition?.getMessage() != null){
      return Column(
                    children: [
                                Row(
                                  children: [
                                    Column( 
                                      children:[ 
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 200,
                                                height: 80,
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
                                                            Text("${widget._currentTransition?.getMessage()}",style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget createWidgetsFromFile() {
    int? bucketRecordCapacity;
    int? hashTableLen;
    Widget? hashingTableWidget;
    Widget? bucketListWidget;
    Widget? freedBucketListWidget;
    bool freedBucketListisNotEmpty = false;
    
    if (widget._currentTransition != null){
      bucketRecordCapacity = widget._currentTransition?.getTransitionFile()?.bucketRecordCapacity();
      hashTableLen = widget._currentTransition?.getDirectoryTransition()!.getTransition()!.len;
      hashingTableWidget = HashingTableWidget(currentTransition: widget._currentTransition?.getDirectoryTransition());
      bucketListWidget = BucketListWidget(widget._currentTransition!.getBucketListTransition(), widget._currentTransition!.getTransitionFile()!.bucketRecordCapacity());
      freedBucketListWidget = FreedBucketListWidget(currentTransition: widget._currentTransition!.getFreedListTransition());
      freedBucketListisNotEmpty = widget._currentTransition!.getFreedListTransition()!.getFreedList().isNotEmpty;
    } else{
      bucketRecordCapacity = widget._initFile.bucketRecordCapacity();
      hashTableLen = widget._initFile.getDirectory().len;
      hashingTableWidget = HashingTableWidget(currentTransition: DirectoryTransition(widget._initFile.getDirectory()));
      bucketListWidget = BucketListWidget(BucketListTransition(TransitionType.fileIsEmpty,widget._initFile.bucketRecordCapacity(), widget._initFile.getFileContent()), widget._initFile.bucketRecordCapacity());
      freedBucketListWidget = FreedBucketListWidget(currentTransition: FreedListTransition(widget._initFile.getFreedList()));
      freedBucketListisNotEmpty = widget._initFile.getFreedList().isNotEmpty;
    }
    return Column( children: [ 
            Row( children: [ 
              Column(children:[ 
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
                  ),
            const Spacer(),
            getInternalBanner(),
            const Spacer(),] ),
            Row( children: [
              Column(children:[ 
                                Container(
                                  child: const Center(child: Text("Hashing Table", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                //ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: HashingTableWidget(initialValues: widget.file.getDirectory().hash, currentTransition: widget._currentTransition))
                                ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: hashingTableWidget )
                              ],
                  ),
                  const Spacer(),
                  Column( 
                    children:[ Container(
                                  child: const Center(child: Text("File", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                //BucketListWidget(bucketRecordCapacity:  widget.file.bucketRecordCapacity(), initialBuckets: widget.file.getFileContent(), currentTransition: widget._currentTransition)
                                bucketListWidget
                    ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ freedBucketListisNotEmpty ? 
                  Column( 
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                                  child: const Center(child: Text("Freed Bucket List", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                      ConstrainedBox(constraints: const BoxConstraints(maxHeight: 100),child: freedBucketListWidget),
                  ]) : 
                  const Column (crossAxisAlignment: CrossAxisAlignment.center,) ]
                  ),
                ],
          );
  }
  /*
  Widget createWidgetsFromFile() {
    /*if (widget._currentTransition != null){

    }*/
    
    return Column( children: [ 
            Row( children: [ 
              Column(children:[ 
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
                                                  : "", style: TextStyle(fontWeight: FontWeight.bold)),
                                                  Text("Bucket capacity: ${widget._currentTransition?.getTransitionFile()?.bucketRecordCapacity()}",style: TextStyle(fontWeight: FontWeight.bold)),
                                                  Text("T - Hashing Table Size: ${widget._currentTransition?.getDirectoryTransition()!.getTransition()!.len}",style: TextStyle(fontWeight: FontWeight.bold)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ), 
                              ],
                  ),
            const Spacer(),
            getInternalBanner(),
            const Spacer(),] ),
            Row( children: [
              Column(children:[ 
                                Container(
                                  child: const Center(child: Text("Hashing Table", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                //ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: HashingTableWidget(initialValues: widget.file.getDirectory().hash, currentTransition: widget._currentTransition))
                                ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: HashingTableWidget(initialValues: widget._currentTransition!.getDirectoryTransition() != null && widget._currentTransition!.getDirectoryTransition()?.getTransition() != null ? widget._currentTransition!.getDirectoryTransition()!.getTransition()?.hash : [] , currentTransition: widget._currentTransition?.getDirectoryTransition()))
                              ],
                  ),
                  const Spacer(),
                  Column( 
                    children:[ Container(
                                  child: const Center(child: Text("File", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                                //BucketListWidget(bucketRecordCapacity:  widget.file.bucketRecordCapacity(), initialBuckets: widget.file.getFileContent(), currentTransition: widget._currentTransition)
                                BucketListWidget(widget._currentTransition!.getTransitionFile()!.bucketRecordCapacity(), widget._currentTransition!.getBucketListTransition())
                    ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [ widget._currentTransition!.getFreedListTransition()!.getFreedList().isNotEmpty ? 
                  //const Spacer(),
                  Column( 
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                                  child: const Center(child: Text("Freed Bucket List", style: TextStyle(fontWeight: FontWeight.bold))),
                                ),
                      ConstrainedBox(constraints: const BoxConstraints(maxHeight: 100),child: FreedBucketListWidget(freedBucketNumbers: widget._currentTransition!.getFreedListTransition()!.getFreedList(), currentTransition: widget._currentTransition!.getFreedListTransition())),
                  ]) : const Column (crossAxisAlignment: CrossAxisAlignment.center,) ]
                  ),
                ],
          );
  }
  */
    @override
  Widget build(BuildContext context) {
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

  /*
  Map<int, List<Widget>> createWidgetsFromTree() {
    return widget.tree.getAllNodesByLevel().map((level, listOfNodes) =>
        MapEntry(
            level,
            listOfNodes
                .map((node) => createNodeWithTransition(node))
                .toList()));
  }

  TreeNodeWidget createNodeWithTransition(BSharpNode<Comparable> node) {
    var nodeTransition = widget.currentTransition != null &&
            widget.currentTransition!.isATarget(node.id)
        ? widget.currentTransition
        : null;

    return TreeNodeWidget(node, nodeTransition);
  }
  */
  /*
  @override
  Widget build(BuildContext context) {
    _components = createWidgetsFromFile();

    final List<Widget> rows = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            height: 20,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              alignment: Alignment.centerLeft,
              child: Text(widget.commandInExecution != null
                  ? widget.commandInExecution.toString()
                  : ""),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 20,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              child: Text(widget.currentTransition != null
                  ? widget.currentTransition.toString()
                  : ""),
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 20,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              child: Text(widget.tree.freeNodesIds.isNotEmpty
                  ? "Free nodes: ${widget.tree.freeNodesIds}"
                  : ""),
            ),
          ),
        ],
      )
    ];

    for (var mapEntry in _components!.entries) {
      List<Widget> children = mapEntry.value.fold([
        const Spacer()
      ], (previousValue, widget) => previousValue + ([widget, const Spacer()]));
      rows.addAll([Row(children: children), const Spacer()]);
    }

    rows.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 165,
          height: 65,
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
              buildColorReferenceRow(Colors.cyan, "Node with available space"),
              buildColorReferenceRow(Colors.yellow, "Node at capacity limit"),
              buildColorReferenceRow(Colors.red, "Overflowed node"),
            ],
          ),
        ),
      ],
    ));

    return ArrowContainer(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: rows),
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
  */

}