import 'package:flutter/material.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_builder_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_command.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/extension/direct_file_model.dart';
import 'package:visualizeit_dynamicfile_extendiblehashing_extension/widget/direct_file_widget.dart';
import 'package:visualizeit_extensions/common.dart';
import 'package:visualizeit_extensions/extension.dart';
import 'package:visualizeit_extensions/logging.dart';

final _logger = Logger("extension.extendiblehashing");

final class DirectFileExtendibleHashingExtension extends Extension{
  static const extensionId = "extendible-hashing-extension";

  DirectFileExtendibleHashingExtension._create({required super.markdownDocs, required super.extensionCore}) : super.create(id: extensionId);

}


class DirectFileExtendibleHashingExtensionBuilder implements ExtensionBuilder {
  
  static const _docsLocationPath =
      "packages/visualizeit_extendiblehashing_extension/assets/docs";
  static const _availableDocsLanguages = [LanguageCodes.en];

  @override
  Future<Extension> build() async {
    _logger.trace(() => "Building Extendible Hashing extension");

    final markdownDocs = {
      for (final languageCode in _availableDocsLanguages)
        languageCode: '$_docsLocationPath/$languageCode.md'
    };

    return  DirectFileExtendibleHashingExtension._create(markdownDocs: markdownDocs, extensionCore: DirectFileExtendibleHashingExtensionCore());
    
  }
}

class DirectFileExtendibleHashingExtensionCore extends SimpleExtensionCore{

DirectFileExtendibleHashingExtensionCore()
      : super({
          DirectFileExtendibleHashingBuilderCommand.commandDefinition:
              DirectFileExtendibleHashingBuilderCommand.build,
          DirectFileExtendibleHashingInsertCommand.commandDefinition:
              DirectFileExtendibleHashingInsertCommand.build,
          DirectFileExtendibleHashingRemoveCommand.commandDefinition:
              DirectFileExtendibleHashingRemoveCommand.build,
          DirectFileExtendibleHashingFindCommand.commandDefinition: DirectFileExtendibleHashingFindCommand.build,
        });

  @override
  Widget? render(Model model, BuildContext context) {
    if (model is DirectFileExtendibleHashingModel) {
     //if (model is DirectFileExtendibleHashingModel && model.currentTransition != null) {
      /*return DirectFileExtendibleHashingWidget(model.currentTree!, model.currentTransition,
          model.commandInExecution);*/
          _logger.trace(() => "Building Extendible Hashing Widget");
          if (model.currentTransition != null){
            //model.currentTransition!.getTransitionFile()?.status();
            _logger.trace(() => "transition number: ${model.currentTransition?.type.name}");
            // ignore: prefer_interpolation_to_compose_strings
            //_logger.trace(() => "BucketList " + model.currentTransition!.getBucketListTransition()!.getBucketList().toString());
            //_logger.trace(() => "BucketList 2" + model.currentTransition!.getTransitionFile()!.getFileContent().toString());
            //return DirectFileExtendibleHashingWidget(model.baseFile,null,model.commandInExecution);
          }
          //return DirectFileExtendibleHashingWidget(model.baseFile,null,null);
          return DirectFileExtendibleHashingWidget(model.currentFile!,model.currentTransition,model.commandInExecution);
      
    } else {
      return null;
    }
  }

}
