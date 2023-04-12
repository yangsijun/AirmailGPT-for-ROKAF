import 'dart:async';

import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

import 'package:airmail_gpt_client/res/setting.dart';

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
    Timer t1 = Timer(
      const Duration(seconds: 5),
      () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('AirmailGPT가 공군기본군사훈련단 홈페이지에 접속했습니다!'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: '확인',
            onPressed: () {},
          )
        ),
      );
    });
    Timer t2 = Timer(
      const Duration(seconds: 11),
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('AirmailGPT가 ${airman.name} 훈련병의 정보를 입력했습니다!'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '확인',
              onPressed: () {},
            )
          ),
        );
      }
    );
    Timer t3 = Timer(
      const Duration(seconds: 17),
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${airman.name} 훈련병이 이 편지를 읽고 어떤 생각을 할까요?'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '확인',
              onPressed: () {},
            )
          ),
        );
      }
    );
    Timer t4 = Timer(
      const Duration(seconds: 30),
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('우와 30초 넘게 걸리려나봐요. 더 빨리 할 수 있도록 노력하겠습니다!'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: '확인',
              onPressed: () {},
            )
          ),
        );
      }
    );
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
          t1.cancel();
          t2.cancel();
          t3.cancel();
          t4.cancel();
        }
      );
  }
}