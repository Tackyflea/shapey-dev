abstract interface class AppCommand {
  void execute();
  void undo();
  String getTitle();
}

bool printAppCommands = false;

// From https://medium.com/@aprayush20/understanding-design-patterns-with-dart-01-chain-of-responsibility-command-pattern-b93da4ea9231
class AppCommandInvoker {
  final int maxHistory;
  final List<AppCommand> _commands = [];
  final List<AppCommand> _undoneCommands = [];

  AppCommandInvoker({this.maxHistory = 30});
  // Execute a command and add it to the command history
  void executeCommand(AppCommand command) {
    command.execute();
    _commands.add(command);
    if (printAppCommands == true) {
      print("AppCommandInvoker: ADDED -> ${command.getTitle()}");
    }

    if (_commands.length > maxHistory) {
      _commands.removeAt(0);
    }

    _undoneCommands.clear(); // clear redo stack
  }

  void undo() {
    if (_commands.isNotEmpty) {
      final lastCommand = _commands.removeLast();
      if (printAppCommands == true) {
        print("AppCommandInvoker: REMOVED -> ${lastCommand.getTitle()}");
      }
      lastCommand.undo();
      _undoneCommands.add(lastCommand);
    }
  }

  void redo() {
    if (_undoneCommands.isNotEmpty) {
      final commandToRedo = _undoneCommands.removeLast();
      commandToRedo.execute();
      _commands.add(commandToRedo);

      if (_commands.length > maxHistory) {
        _commands.removeAt(0);
      }
    }
  }
}
