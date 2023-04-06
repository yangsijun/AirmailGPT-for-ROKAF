import 'package:airmail_gpt_client/src/model.dart';

import 'package:airmail_gpt_client/res/setting.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MailService {
  factory MailService() => _this ??= MailService._();
  MailService._();
  static MailService? _this;

  void sendMail(MailModel model) {
    print('model.airman.name: ${model.airman.name}');
    print('model.airman: ${model.airman.toJson().toString()}');
    http.post(
      Uri.parse('http://$constantApiDomain/AirmailGPT-for-ROKAF/mails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'sender': model.sender.toJson(),
        'airman': model.airman.toJson(),
        'body': model.mailBody.toJson(),
        'password': model.password,
      }),
    );
  }

  Future<MailBodyModel> generateAiMail(AiMailGeneratorModel generatorModel) async {
    print('generateModel.senderName: ${generatorModel.senderName}');
    print('generateModel.airmanName: ${generatorModel.airmanName}');
    print('generateModel.relationship: ${generatorModel.relationship}');
    print('generateModel.keyword: ${generatorModel.keyword}');
    final response = await http.post(
      Uri.parse('http://$constantApiDomain/AirmailGPT-for-ROKAF/mails/generate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'senderName': generatorModel.senderName,
        'airmanName': generatorModel.airmanName,
        'relationship': generatorModel.relationship,
        'keyword': generatorModel.keyword,
      }),
    );

    return MailBodyModel(
      title: jsonDecode(utf8.decode(response.bodyBytes))['title'] as String,
      content: jsonDecode(utf8.decode(response.bodyBytes))['content'] as String,
    );
  }
}