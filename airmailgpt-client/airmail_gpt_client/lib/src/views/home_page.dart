import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

import 'package:airmail_gpt_client/res/setting.dart';

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SetState(
              builder: (context, dataObject) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabled: false,
                                labelText: '받는 사람 이름',
                              ),
                              focusNode: FocusNode(),
                              initialValue: airmanName,
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                enabled: false,
                                labelText: '받는 사람 생년월일',
                              ),
                              focusNode: FocusNode(),
                              initialValue: airmanBirth,
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '보내는 사람 이름',
                      ),
                      focusNode: FocusNode(),
                      onChanged: (value) => con.senderName = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호',
                      ),
                      focusNode: FocusNode(),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => con.password = value,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 200,
                      ),
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '편지 키워드',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: con.seedChipList,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: '키워드 추가',
                                  suffixIcon: IconButton(
                                    padding: const EdgeInsets.all(20),
                                    onPressed: () {
                                      String? result = con.addSeedWord();
                                      if (result == null) return;
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(result),
                                          duration: const Duration(seconds: 3),
                                          action: SnackBarAction(
                                            label: '확인',
                                            onPressed: () {},
                                          )
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ),
                                focusNode: FocusNode(),
                                onChanged: (value) => con.seedWord = value,
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: con.sendMessage,
                        child: const Text('인편 보내기'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}