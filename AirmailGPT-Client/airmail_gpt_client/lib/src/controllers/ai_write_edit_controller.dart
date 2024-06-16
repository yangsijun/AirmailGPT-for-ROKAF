import 'dart:async';

import 'package:airmail_gpt_client/src/controller.dart';
import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/service.dart';
import 'package:airmail_gpt_client/src/view.dart';

class AiWriteEditController extends ControllerMVC {
  factory AiWriteEditController([StateMVC? state]) => _this ??= AiWriteEditController._(state);
  AiWriteEditController._(StateMVC? state)
    : _mailModel = MailModel(),
      _generatorModel = AiMailGeneratorModel(),
      _service = MailService(),
      isMailGenerated = false,
      super(state);
  static AiWriteEditController? _this;

  final MailModel _mailModel;
  final AiMailGeneratorModel _generatorModel;
  final MailService _service;

  bool isMailGenerated;

  AiMailGeneratorModel get generatorModel => _generatorModel;

  String get airmanName => _mailModel.airman.name ??= '';
  String get airmanBirth => _mailModel.airman.birth ??= '';
  String get senderName => _mailModel.sender.name ??= '';
  String get relationship => _mailModel.sender.relationship ??= '';
  String get keywordInput => _generatorModel.keywordInput ??= '';
  String get keyword => _generatorModel.keyword ??= '';
  List<String> get keywordList => _generatorModel.keywordList ??= <String>[];
  List<Chip> get keywordChipList => _generatorModel.keywordChipList ??= <Chip>[];
  String get password => _mailModel.password ??= '';

  SenderModel get sender => _mailModel.sender;
  AirmanModel get airman => _mailModel.airman;
  MailBodyModel get mailBody => _mailModel.mailBody;
  
  set airmanName(String value) {
    _mailModel.airman.name = value;
    _generatorModel.airmanName = value;
  }
  set airmanBirth(String value) {
    _mailModel.airman.birth = value;
  }
  set senderName(String value) {
    _mailModel.sender.name = value;
    _generatorModel.senderName = value;
  }
  set relationship(String value) {
    _mailModel.sender.relationship = value;
    _generatorModel.relationship = value;
  }
  set keywordInput(String value) {
    _generatorModel.keywordInput = value;
  }
  set keyword(String value) {
    _generatorModel.keyword = value;
  }
  set keywordList(List<String> value) {
    _generatorModel.keywordList = value;
  }
  set keywordChipList(List<Chip> value) {
    _generatorModel.keywordChipList = value;
  }
  set password(String value) {
    _mailModel.password = value;
  }

  void navigateToAiWritePage(BuildContext context) {
    Navigator.pushNamed(context, '/aiWrite');
  }

  void navigateToAiEditPage(BuildContext context) {
    Navigator.pushNamed(context, '/aiEdit');
  }

  void navigateToSendResultPage(BuildContext context) {
    Navigator.pushNamed(context, '/sendResult');
  }


  Future<bool> generateAiMail() async {
    try {
      isMailGenerated = false;
      _mailModel.mailBody = await _service.generateAiMail(_generatorModel);
      if (_mailModel.mailBody.title == null || _mailModel.mailBody.content == null) {
        isMailGenerated = false;
        return false;
      }
      isMailGenerated = true;
      return true;
    } catch (e) {
      isMailGenerated = false;
      return false;
    }
  }

  List<String>? addKeyword() {
    List<String> errorMessages = <String>[];
    String word = keywordInput.trim();

    if (word.isEmpty) {
      errorMessages.add('키워드를 입력해주세요.');
      return errorMessages;
    }

    for (String element in word.split(',')) {
      element = element.trim();
      if (element.isEmpty) {
        errorMessages.add('키워드를 입력해주세요.');
        continue;
      } else if (keywordList.length >= 10) {
        errorMessages.add('키워드는 최대 10개까지만 추가할 수 있습니다.');
        return errorMessages;
      } else if (keywordList.contains(element)) {
        errorMessages.add('\'$element\'는 이미 추가된 키워드입니다.');
        continue;
      }
      keywordList.add(element);
      keywordChipList.add(
        Chip(          
          label: Text(element),
          onDeleted: () {
            removeKeyword(element);
          },
        )
      );
    }
    keywordInput = '';
    refresh();
    return (errorMessages.isEmpty) ? null : errorMessages;
  }

  void removeKeyword(String word) {
    keywordList.remove(word);
    keywordChipList.removeWhere((element) => element.label.toString() == Text(word).toString());
    refresh();
  }

  void reorderKeyword(int oldIndex, int newIndex) {
    final String keywordItem = keywordList.removeAt(oldIndex);
    keywordList.insert(newIndex, keywordItem);
    final Chip keywordChipItem = keywordChipList.removeAt(oldIndex);
    keywordChipList.insert(newIndex, keywordChipItem);
    refresh();
  }

  void clearKeyword() {
    keywordList.clear();
    keywordChipList.clear();
    refresh();
  }

  void keywordListToKeyword() {
    keyword = keywordList.join(', ');
    refresh();
  }

  void editMail(BuildContext context) {
    navigateToAiEditPage(context);
    Timer t1 = Timer(
      const Duration(seconds: 5),
      () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('ChatGPT가 인편을 생성중입니다. 잠시만 기다려주세요!'),
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
            content: const Text('Raspberry Pi 홈 서버의 발열이 심합니다. 잠시만 더 기다려주세요!'),
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
            content: Text('지금 쯤 ${airman.name} 훈련병은 어떤 생각을 하고 계실까요?'),
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
    (() => generateAiMail())
      .call()
      .then(
        (value) {
          if (value) {
            setState(() {});
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('인편 생성에 실패했습니다. 다시 시도해주세요.'),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: '확인',
                  onPressed: () {},
                )
              ),
            );
          }
          t1.cancel();
          t2.cancel();
          t3.cancel();
          t4.cancel();
        }
      );
    return;
  }

  void sendMail(BuildContext context) {
    SendController sendController = SendController();
    sendController.mailModel = _mailModel;
    navigateToSendResultPage(context);
    (() => sendController.sendMail())
      .call()
      .then(
        (value) {
          if (value == 'success') {
            setState(() {});
          } else {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('인편 전송에 실패했습니다. (DEMO 버전)'),
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