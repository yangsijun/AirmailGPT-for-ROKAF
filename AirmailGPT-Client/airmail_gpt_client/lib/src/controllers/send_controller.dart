import 'package:airmail_gpt_client/src/model.dart';
import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/service.dart';

import 'package:url_launcher/url_launcher.dart';

class SendController extends ControllerMVC {
  factory SendController([StateMVC? state]) => _this ??= SendController._(state);
  SendController._(StateMVC? state)
    : mailModel = MailModel(),
      _service = MailService(),
      isMailSent = false,
      super(state);
  static SendController? _this;

  late MailModel mailModel;
  late MailService _service;

  bool isMailSent;

  Future<String> sendMail() async {
    isMailSent = false;
    String result = await _service.sendMail(mailModel);
    if (result == 'success') {
      isMailSent = true;
      setState(() {});
    } else {
      isMailSent = false;
      setState(() {});
    }
    return result;
  }

  Future<void> launchMailListUrl() async {
    String urlString = await _service.getMailListUrl(mailModel.airman);
    Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}