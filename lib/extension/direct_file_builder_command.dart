import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_extension.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_model.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';
import 'package:visualizeit_extensions/scripting_extensions.dart';

class DirectFileExtendibleHashingBuilderCommand extends ModelBuilderCommand {
  static final commandDefinition =
    CommandDefinition(DirectFileExtendibleHashingExtension.extensionId, "extendiblehashing-create", [
    CommandArgDef("bucketSize", ArgType.int),
    CommandArgDef("initialValues", ArgType.intArray),
  ]);
  final int bucketSize;
  final List<int> initialValues;

  DirectFileExtendibleHashingBuilderCommand(this.bucketSize, this.initialValues);

  DirectFileExtendibleHashingBuilderCommand.build(RawCommand rawCommand)
      : bucketSize = commandDefinition.getIntArgInRange(name: "bucketSize", from: rawCommand, min: 1, max: MAX_BUCKET_SIZE),
        initialValues = (commandDefinition.getArg(name: "initialValues", from: rawCommand) as List<int>);

  @override
  DirectFileExtendibleHashingModel call(CommandContext context) {
    return DirectFileExtendibleHashingModel("", bucketSize, initialValues, false);
  }
}
