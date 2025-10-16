import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/utility/drawy/drawy.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart';

//https://medium.com/@aprayush20/understanding-design-patterns-with-dart-01-chain-of-responsibility-command-pattern-b93da4ea9231
// Execute and undo pen draw
class DrawyPenCommand implements AppCommand {
  final Drawy _receiver;
  final Vector2 newPosition;
  final DrawyInteract _newInteraction;

  DrawyPenCommand(this._receiver, this._newInteraction, this.newPosition);

  @override
  void execute() {
    _receiver.penMode(_newInteraction, newPosition);
  }

  @override
  void undo() {
    _receiver.undoPen();
  }

  @override
  String getTitle() => 'add pen point at ${this.newPosition}';
}

class DrawySelectCommand implements AppCommand {
  final Drawy _receiver;
  final Vector2 newPosition;
  final DrawyInteract _newInteraction;

  DrawySelectCommand(this._receiver, this._newInteraction, this.newPosition);

  @override
  void execute() {
    _receiver.selectMode(_newInteraction, newPosition);
  }

  @override
  void undo() {
    _receiver.undoSelect();
  }

  @override
  String getTitle() => 'select pen point at $newPosition';
}
