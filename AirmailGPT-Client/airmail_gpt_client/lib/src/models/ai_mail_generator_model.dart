import 'package:airmail_gpt_client/src/view.dart';

class AiMailGeneratorModel extends ModelMVC {
  AiMailGeneratorModel([StateMVC? state]) : super(state);

  String? _senderName;
  String? _airmanName;
  String? _relationship;
  String? _keywordInput;
  String? _keyword;
  List<String>? _keywordList;
  List<Chip>? _keywordChipList;

  String? get senderName => _senderName;
  String? get airmanName => _airmanName;
  String? get relationship => _relationship;
  String? get keywordInput => _keywordInput;
  String? get keyword => _keyword;
  List<String>? get keywordList => _keywordList;
  List<Chip>? get keywordChipList => _keywordChipList;

  set senderName(String? value) {
    _senderName = value;
    refresh();
  }
  set airmanName(String? value) {
    _airmanName = value;
    refresh();
  }
  set relationship(String? value) {
    _relationship = value;
    refresh();
  }
  set keywordInput(String? value) {
    _keywordInput = value;
    refresh();
  }
  set keyword(String? value) {
    _keyword = value;
    refresh();
  }
  set keywordList(List<String>? value) {
    _keywordList = value;
    refresh();
  }
  set keywordChipList(List<Chip>? value) {
    _keywordChipList = value;
    refresh();
  }
}