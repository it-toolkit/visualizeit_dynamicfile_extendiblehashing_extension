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
  static const extensionId = "extendible_hashing";

  DirectFileExtendibleHashingExtension._create({required super.markdownDocs, required super.extensionCore}) : super.create(id: extensionId);

}


class DirectFileExtendibleHashingExtensionBuilder implements ExtensionBuilder {
  
  static const _docsLocationPath =
      "packages/visualizeit_dynamicfile_extendiblehashing_extension/assets/docs";
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
          _logger.trace(() => "Building Extendible Hashing Widget");
          if (model.currentTransition != null){
            _logger.trace(() => "transition type: ${model.currentTransition?.type.name}");
          }
          return DirectFileExtendibleHashingWidget(model.currentFile!,model.currentTransition,model.commandInExecution);   
    } else {
      return null;
    }
  }

}
