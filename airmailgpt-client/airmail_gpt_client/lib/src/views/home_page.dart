import 'package:flutter/services.dart';

import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

import 'package:airmail_gpt_client/res/setting.dart';

import 'package:reorderables/reorderables.dart';

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

  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuEntry<String>> relationshipDropdownEntries = [
    DropdownMenuEntry<String>(
      value: '부모',
      label: '부모',
    ),
    DropdownMenuEntry<String>(
      value: '형제',
      label: '형제',
    ),
    DropdownMenuEntry<String>(
      value: '친구',
      label: '친구',
    ),
    DropdownMenuEntry<String>(
      value: '여자친구',
      label: '여자친구',
    ),
  ];

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

    void doAddSeedWord() {
      List<String>? result = con.addSeedWord();

      if (result == null) return;
      for (String element in result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(element),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: '확인',
              onPressed: () {},
            )
          ),
        );
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(outFocusNode);
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
                child: Form(
                  key: _formKey,
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
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                ),
                                validator: (value) => value!.isEmpty ? '받는 사람 이름을 입력해주세요' : null,
                                initialValue: constantAirmanName,
                                readOnly: true,
                                textInputAction: TextInputAction.next,
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
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                ),
                                validator: (value) => value!.isEmpty ? '받는 사람 생년월일을 입력해주세요' : null,
                                initialValue: constantAirmanBirth,
                                readOnly: true,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: '보내는 사람 이름',
                              ),
                              validator: (value) => value!.isEmpty ? '보내는 사람 이름을 입력해주세요' : null,
                              initialValue: con.senderName,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => con.senderName = value,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                return DropdownMenu(
                                  width: constraints.maxWidth,
                                  label: const Text('관계'),
                                  inputDecorationTheme: const InputDecorationTheme(
                                    contentPadding: EdgeInsets.all(22),
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: TextEditingController(text: con.relationship),
                                  dropdownMenuEntries: List<DropdownMenuEntry<String>>.generate(
                                    relationshipDropdownEntries.length,
                                    (index) => DropdownMenuEntry(
                                      value: relationshipDropdownEntries[index].value,
                                      label: relationshipDropdownEntries[index].label,
                                    ),
                                  ),
                                  onSelected: (value) => con.relationship = value!,
                                );
                              },
                            )
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '비밀번호',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          if (value.length != 4) {
                            return '비밀번호는 숫자 4자리이어야 합니다';
                          }
                          return null;
                        },
                        initialValue: con.password,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => con.password = value,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '편지 키워드',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '- 편지에 들어갈 키워드를 입력해주세요.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      '- 키워드는 주제에 관련된 단어 또는 문장, 호칭, 어투 등을 입력할 수 있습니다. (최대 10개)',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      '- 키워드는 쉼표(,)로 구분하여 한 번에 여러 개를 입력할 수 있으며, 드래그해서 순서를 변경할 수 있습니다.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      '- 키워드 예시: 응원, 수고, 뭐 먹었어?, ○○ 오빠, 반말로',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 48,
                                  ),
                                  width: double.infinity,
                                  child: ReorderableWrap(
                                    buildDraggableFeedback: (context, constraints, child) => Material(
                                      color: Colors.transparent,
                                      child: child,
                                    ),
                                    spacing: 8,
                                    onReorder: (int oldIndex, int newIndex) => con.reorderSeed(oldIndex, newIndex),
                                    children: con.seedChipList,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: '키워드 추가',
                                    suffixIcon: IconButton(
                                      padding: const EdgeInsets.all(20),
                                      onPressed: doAddSeedWord,
                                      icon: const Icon(Icons.add),
                                    ),
                                  ),
                                  onChanged: (value) => con.seedWord = value,
                                  onEditingComplete: () {
                                    doAddSeedWord();
                                  },
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              con.sendMessage();
                            }
                          },
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
      ),
    );
  }
}