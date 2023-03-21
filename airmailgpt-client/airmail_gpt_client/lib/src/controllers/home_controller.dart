import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/service.dart';

class HomeController extends ControllerMVC {
  factory HomeController([StateMVC? state]) => _this ??= HomeController._(state);
  HomeController._(StateMVC? state)
    : _model = MessageModel(),
      _service = MessageService(),
      super(state);
  static HomeController? _this;

  final MessageModel _model;
  final MessageService _service;

  MessageModel get model => _model;

  void sendMessage() {
    _service.sendMessage(_model);
  }
}