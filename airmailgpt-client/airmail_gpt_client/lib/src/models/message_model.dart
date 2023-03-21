import 'package:airmail_gpt_client/src/view.dart';

class MessageModel extends ModelMVC {
  factory MessageModel([StateMVC? state]) => _this ??= MessageModel._(state);
  MessageModel._([StateMVC? state]) : super(state);
  static MessageModel? _this;

  String? _airmanName;
  String? _airmanBirth;
  String? _senderName;
  String? _relationship;
  String? _seed;
  String? _password;

  String? get airmanName => _airmanName;
  String? get airmanBirth => _airmanBirth;
  String? get senderName => _senderName;
  String? get relationship => _relationship;
  String? get seed => _seed;
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
  set seed(String? value) {
    _seed = value;
    refresh();
  }
  set password(String? value) {
    _password = value;
    refresh();
  }
}