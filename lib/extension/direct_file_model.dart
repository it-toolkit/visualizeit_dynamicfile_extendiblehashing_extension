import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_extension.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_transition.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/direct_file_observer.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/model/register.dart';
import 'package:visualizeit_extensions/common.dart';

class DirectFileExtendibleHashingModel extends Model {
  final DirectFile _baseFile;
  DirectFile? _lastTransitionFile;
  List<DirectFileTransition> _transitions = [];
  //late TreeLoggerObserver loggerObserver;

  int _currentFrame = 0;
  DirectFileExtendibleHashingCommand? commandInExecution;

  DirectFileExtendibleHashingModel(String name, int bucketSize, List<int> initialValues, [bool? variableRecordSize])
      : _baseFile = DirectFile(bucketSize),
        super(DirectFileExtendibleHashingExtension.extensionId, name) {
    
    if (variableRecordSize!){
      //TODO: NOT IMPLEMENTED IN MODEL
    }
    else{
      //loggerObserver = TreeLoggerObserver(_baseTree);
      //_baseTree.insertAll(initialValues);
      for (int value in initialValues){
        _baseFile.insert(FixedLengthRegister(value));
      }
    }
    _lastTransitionFile = _baseFile;
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
      : _transitions[_currentFrame].getTransitionFile() ?? _lastTransitionFile;// TODO: CHECK if getTransitionFile is returning what is expected here.

  DirectFileTransition? get currentTransition =>
      _transitions.isNotEmpty ? _transitions[_currentFrame] : null;

  int get _pendingFrames => _transitions.length - _currentFrame - 1;

  (int, Model) executeCommand(DirectFileExtendibleHashingCommand command) {
    if (_canExecuteCommand(command)) {
      if (isInTransition()) {
        _currentFrame++;
      } else {
        //_lastTransitionFile = _baseFile.clone();
        commandInExecution = command;
        _currentFrame = 0;
        var transitionObserver = DirectFileObserver();
        _baseFile.registerObserver(transitionObserver);

        var functionToExecute = command.commandToFunction();
        functionToExecute(_baseFile);
        
        _transitions = transitionObserver.transitions;
        _baseFile.removeObserver(transitionObserver);//Porque se saca?

        //TODO: tengo que analizar a que commando se llama aca? como se hace en el external sort?
      
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