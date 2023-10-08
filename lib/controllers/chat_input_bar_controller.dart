import 'package:chatroom_uikit/tools/chat_provider.dart';

enum InputType {
  normal,
  text,
  emoji,
}

class ChatInputBarController extends ChatUIKitChangeNotifier {
  InputType _inputType = InputType.normal;

  InputType get inputType => _inputType;

  set inputType(InputType value) {
    _inputType = value;
    notifyListeners();
  }

  @override
  bool get needSaveData => true;

  @override
  void updateData(data) {}
}
