import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/bucket_list_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/directory_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/freed_bucket_list_widget.dart';

class DirectFileExtendibleHashingWidget extends StatefulWidget {
  final DirectFileTransition? _currentTransition;
  //final BSharpTreeCommand? commandInExecution;
  /*
  const DirectFileExtendibleHashingWidget(this.file, this.currentTransition, this.commandInExecution,
      {super.key});
  */

  const DirectFileExtendibleHashingWidget(this._currentTransition,
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


  Widget createWidgetsFromFile() {
    return Column(
            children: [
              Row(
                children: [
                  Column( 
                    children:[ Container(
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