import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/service.dart';

class AiWriteEditController extends ControllerMVC {
  factory AiWriteEditController([StateMVC? state]) => _this ??= AiWriteEditController._(state);
  AiWriteEditController._(StateMVC? state)
    : _mailModel = MailModel(),
      _generatorModel = AiMailGeneratorModel(),
      _service = MailService(),
      _isMailGenerated = false,
      super(state);
  static AiWriteEditController? _this;

  final MailModel _mailModel;
  final AiMailGeneratorModel _generatorModel;
  final MailService _service;

  bool _isMailGenerated;

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

  bool get isMailGenerated => _isMailGenerated;
  
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

  set isMailGenerated(bool value) {
    _isMailGenerated = value;
  }

  void navigateToAiEditPage(BuildContext context) {
    Navigator.pushNamed(context, '/aiEdit');
  }

  Future<bool> generateAiMail() async {
    _mailModel.mailBody = await _service.generateAiMail(_generatorModel);
    if (_mailModel.mailBody.title == null || _mailModel.mailBody.content == null) {
      return false;
    }
    print('title: ${_mailModel.mailBody.title}');
    print('content: ${_mailModel.mailBody.content}');
    return true;
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

  void sendMail() {
    _service.sendMail(_mailModel);
  }
}