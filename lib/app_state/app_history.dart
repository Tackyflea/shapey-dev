import 'dart:collection';

abstract interface class AppCommand {
  void execute();
  void undo();
  String getTitle();
}

// From https://medium.com/@aprayush20/understanding-design-patterns-with-dart-01-chain-of-responsibility-command-pattern-b93da4ea9231
class AppCommandInvoker {
  final List<AppCommand> _commands = [];
  final List<AppCommand> _undoneCommands = [];

  // Execute a command and add it to the command history
  void executeCommand(AppCommand command) {
    command.execute();
    _commands.add(command);
    // Clear redo stack when a new command is executed
    _undoneCommands.clear();
  }

  // Undo the last executed command
  void undo() {
    if (_commands.isNotEmpty) {
      // Remove the last command and undo it
      final lastCommand = _commands.removeLast();
      lastCommand.undo();
      _undoneCommands.add(lastCommand); // Store it for redo
    }
  }

  // Redo the last undone command
  void redo() {
    if (_undoneCommands.isNotEmpty) {
      // Remove the last undone command and re-execute it
      final commandToRedo = _undoneCommands.removeLast();
      commandToRedo.execute();
      _commands.add(commandToRedo); // Add it back to command history
    }
  }
}
