import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/service.dart';

class HumanWriteController extends ControllerMVC {
  factory HumanWriteController([StateMVC? state]) => _this ??= HumanWriteController._(state);
  HumanWriteController._(StateMVC? state)
    : _model = MailModel(),
      _service = MailService(),
      super(state);
  static HumanWriteController? _this;

  final MailModel _model;
  final MailService _service;

  MailModel get model => _model;
  SenderModel get sender => _model.sender;
  AirmanModel get airman => _model.airman;
  MailBodyModel get mailBody => _model.mailBody;
  String? get password => _model.password;

  set password(String? value) {
    _model.password = value;
  }

  void sendMail() {
    _service.sendMail(_model);
  }
}