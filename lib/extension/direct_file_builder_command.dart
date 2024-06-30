import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_extension.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_model.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/bucket.dart';
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
            getValidArg(rawCommand),
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
    
  static int getValidArg( RawCommand rawCommand){    
    final arg = commandDefinition.getArg(name: "bucketSize", from: rawCommand);
    if (arg <= 0) throw Exception("The bucket size must be greater than 0");
    if (arg >= MAX_BUCKET_SIZE) throw Exception("The bucket size cannot be greater than $MAX_BUCKET_SIZE");

    return arg;
  }

  
}
