import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/bucket_list_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/directory_widget.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing/widget/freed_bucket_list_widget.dart';

class DirectFileExtendibleHashingWidget extends StatefulWidget {
  final DirectFile file;
  //final BSharpTreeTransition? currentTransition;
  //final BSharpTreeCommand? commandInExecution;
  /*
  const DirectFileExtendibleHashingWidget(this.file, this.currentTransition, this.commandInExecution,
      {super.key});
  */
  
  const DirectFileExtendibleHashingWidget(this.file,
      {super.key});

  @override
  State<DirectFileExtendibleHashingWidget> createState() {
    return _DirectFileExtendibleHashingWidgetState();
  }
}

class _DirectFileExtendibleHashingWidgetState extends State<DirectFileExtendibleHashingWidget> {
  //Map<int, List<Widget>>? _components;
  Widget? _components;

  _DirectFileExtendibleHashingWidgetState();

  @override
  void initState() {
    super.initState();
    _components = createWidgetsFromFile();
  }


  Widget createWidgetsFromFile() {
    return Column(
          children: [
            Row(
              children: [
                Column( 
                  children:[ Container(
                                child: const Center(child: Text("Tabla de Hashing", style: TextStyle(fontWeight: FontWeight.bold))),
                              ),
                              ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: HashingTableWidget(initialValues: widget.file.getDirectory().hash))
                  ],
                  ),
                const Spacer(),
                Column( 
                  children:[ Container(
                                child: const Center(child: Text("Archivo Directo", style: TextStyle(fontWeight: FontWeight.bold))),
                              ),
                              BucketListWidget(bucketRecordCapacity:  widget.file.bucketRecordCapacity(), initialBuckets: widget.file.getFileContent())
                  ],
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ widget.file.getFreedList().isNotEmpty ? 
                //const Spacer(),
                Column( 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                                child: const Center(child: Text("Lista de Cubetas Libres", style: TextStyle(fontWeight: FontWeight.bold))),
                              ),
                    ConstrainedBox(constraints: BoxConstraints(maxHeight: 100),child: FreedBucketListWidget(freedBucketNumbers: widget.file.getFreedList())),
                ]) : const Column (crossAxisAlignment: CrossAxisAlignment.center,) ]
                ),
              ],
        );
  }
    @override
  Widget build(BuildContext context) {
    //_components = createWidgetsFromFile();
    return createWidgetsFromFile();
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