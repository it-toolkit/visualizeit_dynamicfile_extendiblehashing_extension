import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_extension.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/transition/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file_observer.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("extension.extendiblehashing.model");

class DirectFileExtendibleHashingModel extends Model {
  final DirectFile _baseFile;
  DirectFile? _lastTransitionFile;
  List<DirectFileTransition> _transitions = [];

  int _currentFrame = 0;
  DirectFileExtendibleHashingCommand? commandInExecution;

  DirectFileExtendibleHashingModel(String name, int bucketSize, List<int> initialValues, [bool? variableRecordSize])
      : _baseFile = DirectFile(bucketSize),
        super(DirectFileExtendibleHashingExtension.extensionId, name) {
    
    if (variableRecordSize!){
      throw Exception("A variable record size is not implemented in model");
    }
    else{
      for (int value in initialValues){
        _baseFile.insert(FixedLengthRegister(value));
      }
    }
    _lastTransitionFile = _baseFile;
    _logger.trace(() => "Creating DirectFileExtendibleHashingModel"); 
  }
  
  DirectFileExtendibleHashingModel.copyWith(
      this._baseFile,
      this._lastTransitionFile,
      this._transitions,
      this._currentFrame,
      this.commandInExecution,
      super.extensionId,
      super.name);

  
  DirectFile? get currentFile => _transitions.isEmpty
      ? _lastTransitionFile
      : _transitions[_currentFrame].getTransitionFile() ?? _lastTransitionFile;
  
  DirectFileTransition? get currentTransition =>
      _transitions.isNotEmpty ? _transitions[_currentFrame] : null;

  int get _pendingFrames => _transitions.length - _currentFrame - 1;

  (int, Model) executeCommand(DirectFileExtendibleHashingCommand command) {
    if (_canExecuteCommand(command)) {
      if (isInTransition()) {
        _currentFrame++;
        _logger.trace(() => "Command: $command");
        _logger.trace(() => "Current Frame : $_currentFrame"); 
        _logger.trace(() => "Current Transition: ${currentTransition?.type.name}"); 

      } else {
        _lastTransitionFile = _baseFile.clone();
        commandInExecution = command;
        _currentFrame = 0;
        var transitionObserver = DirectFileObserver();
        _baseFile.registerObserver(transitionObserver);

        var functionToExecute = command.commandToFunction();
        _logger.trace(() => "Function to Execute $functionToExecute.toString()"); 
        functionToExecute(_baseFile);

        _transitions = transitionObserver.transitions;
        _logger.trace(() => "# Transitions generated: $_transitions" );
        _baseFile.removeObserver(transitionObserver);
      
      }
      return (_pendingFrames, this);
    } else {
      throw UnsupportedError(
          "cant execute a command while another command is on transition");
    }
  }

  bool _canExecuteCommand(DirectFileExtendibleHashingCommand command) {
    return (commandInExecution != command && !isInTransition()) ||
        (commandInExecution == command && isInTransition());
  }

  bool isInTransition() {
    return _transitions.isNotEmpty && _currentFrame < _transitions.length - 1;
  }

  @override
  Model clone() {
    return DirectFileExtendibleHashingModel.copyWith(
        _baseFile.clone(),
        _lastTransitionFile?.clone(),
        List.of(_transitions),
        _currentFrame,
        commandInExecution,
        extensionId,
        name);
  }
}