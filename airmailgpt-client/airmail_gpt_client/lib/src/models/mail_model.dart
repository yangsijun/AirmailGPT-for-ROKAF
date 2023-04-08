import 'package:airmail_gpt_client/src/view.dart';

class MailModel extends ModelMVC {
  // factory MailModel([StateMVC? state]) => _this ??= MailModel._(state);
  // MailModel._([StateMVC? state]) : super(state);
  // static MailModel? _this;
  MailModel([StateMVC? state]) : super(state);
  
  SenderModel _sender = SenderModel();
  AirmanModel _airman = AirmanModel();
  MailBodyModel _mailBody = MailBodyModel();
  String? _password;

  SenderModel get sender => _sender;
  AirmanModel get airman => _airman;
  MailBodyModel get mailBody => _mailBody;
  String? get password => _password;

  set sender(SenderModel value) {
    _sender = value;
    refresh();
  }  
  set airman(AirmanModel value) {
    _airman = value;
    refresh();
  }
  set mailBody(MailBodyModel value) {
    _mailBody = value;
    refresh();
  }
  set password(String? value) {
    _password = value;
    refresh();
  }
}

class SenderModel extends ModelMVC {
  String? _name;
  String? _relationship;
  String? _zipCode;
  String? _address1;
  String? _address2;

  String? get name => _name;
  String? get relationship => _relationship;
  String? get zipCode => _zipCode;
  String? get address1 => _address1;
  String? get address2 => _address2;

  set name(String? value) {
    _name = value;
    refresh();
  }
  set relationship(String? value) {
    _relationship = value;
    refresh();
  }
  set zipCode(String? value) {
    _zipCode = value;
    refresh();
  }
  set address1(String? value) {
    _address1 = value;
    refresh();
  }
  set address2(String? value) {
    _address2 = value;
    refresh();
  }

  Map<String, dynamic> toJson() => {
    'name': _name,
    'relationship': _relationship,
    'zipCode': _zipCode,
    'address1': _address1,
    'address2': _address2,
  };
}

class AirmanModel extends ModelMVC {
  String? _name;
  String? _birth;

  String? get name => _name;
  String? get birth => _birth;

  set name(String? value) {
    _name = value;
    refresh();
  }
  set birth(String? value) {
    _birth = value;
    refresh();
  }

  Map<String, dynamic> toJson() => {
    'name': _name,
    'birth': _birth,
  };
}

class MailBodyModel extends ModelMVC {
  String? _title;
  String? _content;

  MailBodyModel({String? title, String? content}) {
    _title = title;
    _content = content;
  }

  String? get title => _title;
  String? get content => _content;

  set title(String? value) {
    _title = value;
    refresh();
  }
  set content(String? value) {
    _content = value;
    refresh();
  }

  Map<String, dynamic> toJson() => {
    'title': _title,
    'content': _content,
  };
}