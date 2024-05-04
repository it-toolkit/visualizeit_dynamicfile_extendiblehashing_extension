import 'package:logging/logging.dart';

void main() {
  // Initialize logging
  Logger.root.level = Level.ALL; // Set the default log level
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  // Get a logger instance
  var logger = Logger('main');

  // Log some messages
  logger.finest('This is a finest message');
  logger.finer('This is a finer message');
  logger.fine('This is a fine message');
  logger.info('This is an info message');
  logger.warning('This is a warning message');
  logger.severe('This is a severe message');
}