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

  String get airmanName => _model.airmanName ??= '';
  String get airmanBirth => _model.airmanBirth ??= '';
  String get senderName => _model.senderName ??= '';
  String get relationship => _model.relationship!;
  List<String> get seedList => _model.seedList ??= <String>[];
  List<Chip> get seedChipList => _model.seedChipList ??= <Chip>[];
  String get seedWord => _model.seedWord ??= '';
  String get password => _model.password ??= '';

  set airmanName(String value) {
    _model.airmanName = value;
  }
  set airmanBirth(String value) {
    _model.airmanBirth = value;
  }
  set senderName(String value) {
    _model.senderName = value;
  }
  set relationship(String value) {
    _model.relationship = value;
  }
  set seedList(List<String> value) {
    _model.seedList = value;
  }
  set seedWord(String value) {
    _model.seedWord = value;
  }
  set password(String value) {
    _model.password = value;
  }
  set seedChipList(List<Chip> value) {
    _model.seedChipList = value;
  }

  void sendMessage() {
    _service.sendMessage(_model);
  }

  List<String>? addSeedWord() {
    List<String> errorMessages = <String>[];
    String word = seedWord.trim();

    if (word.isEmpty) {
      errorMessages.add('키워드를 입력해주세요.');
      return errorMessages;
    }

    for (String element in word.split(',')) {
      element = element.trim();

      if (seedList.length >= 10) {
        errorMessages.add('키워드는 최대 10개까지만 추가할 수 있습니다.');
        return errorMessages;
      } else if (seedList.contains(element)) {
        errorMessages.add('\'$element\'는 이미 추가된 키워드입니다.');
        continue;
      }
      seedList.add(element);
      seedChipList.add(
        Chip(          
          label: Text(element),
          onDeleted: () {
            removeSeedWord(element);
          },
        )
      );
    }

    seedWord = '';
    refresh();
    return (errorMessages.isEmpty) ? null : errorMessages;
  }

  void removeSeedWord(String word) {
    seedList.remove(word);
    seedChipList.removeWhere((element) => element.label.toString() == Text(word).toString());
    refresh();
  }

  void reorderSeed(int oldIndex, int newIndex) {
    final String seedItem = seedList.removeAt(oldIndex);
    seedList.insert(newIndex, seedItem);
    final Chip seedChipItem = seedChipList.removeAt(oldIndex);
    seedChipList.insert(newIndex, seedChipItem);
    refresh();
  }
}