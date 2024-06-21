import 'package:uuid/uuid.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_extension.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_model.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/logging.dart';
import 'package:visualizeit_extensions/scripting.dart';

abstract class DirectFileExtendibleHashingCommand extends ModelCommand {
  final num value;
  final String uuid;
  final Logger _logger;
  DirectFileExtendibleHashingCommand(this.value, this.uuid, this._logger, super.modelName);

  @override
  Result call(Model model, CommandContext context) {
    DirectFileExtendibleHashingModel fileModel = (model.clone()) as DirectFileExtendibleHashingModel;

    _logger.info(() => "Call in DirectFileExtendibleHashingCommand");
    fileModel.baseFile.status();
    int pendingFrames;
    Model? resultModel;

    (pendingFrames, resultModel) = fileModel.executeCommand(this);//REVIEW THIS METHOD

    var result = Result(finished: pendingFrames == 0, model: resultModel);

    _logger.info(() => "command result: $result");

    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other is DirectFileExtendibleHashingCommand) {
      if (runtimeType == other.runtimeType) {
        if (uuid == other.uuid) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  int get hashCode => Object.hashAll([value, uuid, modelName]);

  Function commandToFunction();

  static CommandDefinition createDirectFileExtendibleHashingCommandDefinition(
      String commandName) {
    return CommandDefinition(DirectFileExtendibleHashingExtension.extensionId, commandName,
        [CommandArgDef("value", ArgType.int)]);
  }
}

class DirectFileExtendibleHashingInsertCommand extends DirectFileExtendibleHashingCommand {
  static final commandDefinition =
      DirectFileExtendibleHashingCommand.createDirectFileExtendibleHashingCommandDefinition("extendiblehashing-insert");

  DirectFileExtendibleHashingInsertCommand(int value, String modelName)
      : super(value, const Uuid().v4(), Logger("extension.extendiblehashing.insert"),
            modelName);

  DirectFileExtendibleHashingInsertCommand.build(RawCommand rawCommand)
      : super(
            commandDefinition.getArg(name: "value", from: rawCommand),
            const Uuid().v4(),
            Logger("extension.extendiblehashing.insert"),
            ""); //TODO entender para que es necesario el modelName acá

  @override
  String toString() {
    return "Inserting value: $value";
  }

  @override
  Function commandToFunction() {
    return (DirectFile myfile) => myfile.insert(FixedLengthRegister(value));//TODO: FIX THIS. IM CONSIDERING ALWAYS A FIXED LENGTH RECORD
  }
}

class DirectFileExtendibleHashingRemoveCommand extends DirectFileExtendibleHashingCommand {
  static final commandDefinition =
      DirectFileExtendibleHashingCommand.createDirectFileExtendibleHashingCommandDefinition("extendiblehashing-remove");

  DirectFileExtendibleHashingRemoveCommand(int value, String modelName)
      : super(value, const Uuid().v4(), Logger("extension.extendiblehashing.remove"),
            modelName);

  DirectFileExtendibleHashingRemoveCommand.build(RawCommand rawCommand)
      : super(
            commandDefinition.getArg(name: "value", from: rawCommand),
            const Uuid().v4(),
            Logger("extension.extendiblehashing.remove"),
            ""); //TODO entender para que es necesario el modelName acá
  @override
  String toString() {
    return "Removing value: $value";
  }

  @override
  Function commandToFunction() {
    return (DirectFile myfile) => myfile.delete(FixedLengthRegister(value));//TODO: FIX THIS. IM CONSIDERING ALWAYS A FIXED LENGTH RECORD
  }
}

class DirectFileExtendibleHashingFindCommand extends DirectFileExtendibleHashingCommand {
  static final commandDefinition =
      DirectFileExtendibleHashingCommand.createDirectFileExtendibleHashingCommandDefinition("extendiblehashing-find");

  DirectFileExtendibleHashingFindCommand(int value, String modelName)
      : super(value, const Uuid().v4(), Logger("extension.extendiblehashing.find"),
            modelName);

  DirectFileExtendibleHashingFindCommand.build(RawCommand rawCommand)
      : super(
            commandDefinition.getArg(name: "value", from: rawCommand),
            const Uuid().v4(),
            Logger("extension.extendiblehashing.find"),
            ""); 
  @override
  String toString() {
    return "Finding value: $value";
  }

  @override
  Function commandToFunction() {
    return (DirectFile myfile) => myfile.exist(FixedLengthRegister(value));//TODO: FIX THIS. IM CONSIDERING ALWAYS A FIXED LENGTH RECORD
  }
}
