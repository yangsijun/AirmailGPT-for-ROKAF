import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

class HumanWriteController extends ControllerMVC {
  factory HumanWriteController([StateMVC? state]) => _this ??= HumanWriteController._(state);
  HumanWriteController._(StateMVC? state)
    : _model = MailModel(),
      super(state);
  static HumanWriteController? _this;

  final MailModel _model;

  MailModel get model => _model;
  SenderModel get sender => _model.sender;
  AirmanModel get airman => _model.airman;
  MailBodyModel get mailBody => _model.mailBody;
  String? get password => _model.password;

  set password(String? value) {
    _model.password = value;
  }

  void navigateToSendResultPage(BuildContext context) {
    Navigator.pushNamed(context, '/sendResult');
  }

  void sendMail(BuildContext context) {
    SendController sendController = SendController();
    sendController.mailModel = _model;
    navigateToSendResultPage(context);
    (() => sendController.sendMail())
      .call()
      .then(
        (value) {
          if (value == 'success') {
            setState(() {});
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('인편 전송에 실패했습니다.'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {},
                ),
              )
            );
          }
        }
      );
  }
}