import 'package:airmail_gpt_client/src/view.dart';

class AppController extends ControllerMVC {
  factory AppController() => _this ??= AppController._();
  AppController._();
  static AppController? _this;

  @override
  Future<bool> initAsync() async {
    return Future.delayed(const Duration(seconds: 1), () {
      return true;
    });
  }

  @override
  bool onAsyncError(FlutterErrorDetails details) {
    return false;
  }
}