import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

class MyApp extends AppStatefulWidgetMVC  {
  const MyApp({Key? key}) : super(key: key);

  @override
  AppStateMVC createState() => _MyAppState();
}

class _MyAppState extends AppStateMVC<MyApp> {
  factory _MyAppState() => _this ??= _MyAppState._();

  _MyAppState._()
    : super(
      controller: AppController(),
      controllers: [
        HomeController(),
        AiWriteEditController(),
        HumanWriteController(),
        SendController(),
      ],
      object: 'Hello!',
    );
  
  static _MyAppState? _this;

  @override
  Widget buildChild(BuildContext context) => MaterialApp(
    title: "AirmailGPT for ROKAF",
    theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
    darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(key: UniqueKey()),
      '/aiWrite': (context) => AiWritePage(key: UniqueKey()),
      '/aiEdit': (context) => AiEditPage(key: UniqueKey()),
      '/humanWrite': (context) => HumanWritePage(key: UniqueKey()),
      '/sendResult':(context) => SendResultPage(key: UniqueKey()),
    },
  );
}