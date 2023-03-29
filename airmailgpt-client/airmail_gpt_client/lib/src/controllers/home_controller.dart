import 'package:airmail_gpt_client/src/view.dart';

class HomeController extends ControllerMVC {
  factory HomeController() => _this ??= HomeController._();
  HomeController._();
  static HomeController? _this;

  void navigateToAiWritePage(BuildContext context) {
    Navigator.pushNamed(context, '/aiWrite');
  }

  void navigateToHumanWritePage(BuildContext context) {
    Navigator.pushNamed(context, '/humanWrite');
  }
}