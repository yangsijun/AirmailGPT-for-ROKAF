import 'package:airmail_gpt_client/src/view.dart';

class MessageModel extends ModelMVC {
  factory MessageModel([StateMVC? state]) => _this ??= MessageModel._(state);
  MessageModel._([StateMVC? state]) : super(state);
  static MessageModel? _this;

  String? _airmanName;
  String? _airmanBirth;
  String? _senderName;
  String? _relationship;
  List<String>? _seedList;
  List<Chip>? _seedChipList;
  String? _seedWord;
  String? _password;

  String? get airmanName => _airmanName;
  String? get airmanBirth => _airmanBirth;
  String? get senderName => _senderName;
  String? get relationship => _relationship;
  List<String>? get seedList => _seedList;
  List<Chip>? get seedChipList => _seedChipList;
  String? get seedWord => _seedWord;
  String? get password => _password;

  set airmanName(String? value) {
    _airmanName = value;
    refresh();
  }
  set airmanBirth(String? value) {
    _airmanBirth = value;
    refresh();
  }
  set senderName(String? value) {
    _senderName = value;
    refresh();
  }
  set relationship(String? value) {
    _relationship = value;
    refresh();
  }
  set seedList(List<String>? value) {
    _seedList = value;
    refresh();
  }
  set seedChipList(List<Chip>? value) {
    _seedChipList = value;
    refresh();
  }
  set seedWord(String? value) {
    _seedWord = value;
    refresh();
  }
  set password(String? value) {
    _password = value;
    refresh();
  }
}