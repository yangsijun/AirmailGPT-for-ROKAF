import 'package:airmail_gpt_client/res/setting.dart';

import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title = 'AirmailGPT for ROKAF'}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends StateMVC<HomePage> {
  _HomePageState() : super(HomeController()) {
    con = controller as HomeController;
  }

  late HomeController con;

  final FocusNode outFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    appState = rootState!;

    var con = appState.controller;
    con = appState.controllerByType<AppController>();
    con = appState.controllerById(con?.keyId);

  }

  late AppStateMVC appState;

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$constantAirmanName 인편 쓰기',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        con.navigateToAiWritePage(context);
                      },
                      child: const Text('AI로 작성하기'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        con.navigateToHumanWritePage(context);
                      },
                      child: const Text('직접 작성하기'),
                    ),
                  ],
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}