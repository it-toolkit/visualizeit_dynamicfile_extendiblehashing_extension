import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_extension.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_model.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/scripting.dart';

class DirectFileExtendibleHashingBuilderCommand extends ModelBuilderCommand {
  static final commandDefinition =
      CommandDefinition(DirectFileExtendibleHashingExtension.extensionId, "extendiblehashing-create", [
    CommandArgDef("bucketSize", ArgType.int),
    CommandArgDef("initialValues", ArgType.stringArray),
    CommandArgDef("variableRecordSize", ArgType.boolean, required: false, defaultValue: "false")
  ]);
  final int bucketSize;
  final List<int> initialValues;
  final bool? variableRecordSize;

  DirectFileExtendibleHashingBuilderCommand(this.bucketSize, this.initialValues,
      [this.variableRecordSize]);

  DirectFileExtendibleHashingBuilderCommand.build(RawCommand rawCommand)
      : bucketSize =
            commandDefinition.getArg(name: "bucketSize", from: rawCommand),
        initialValues = (commandDefinition.getArg(
                name: "initialValues", from: rawCommand) as List<String>)
            .map(int.parse)
            .toList(),
        variableRecordSize =
            commandDefinition.getArg(name: "variableRecordSize", from: rawCommand);

  @override
  DirectFileExtendibleHashingModel call(CommandContext context) {
    return DirectFileExtendibleHashingModel(
        "", bucketSize, initialValues, variableRecordSize ?? false);
  }
}
