import 'package:flutter/services.dart';

import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

import 'package:airmail_gpt_client/res/setting.dart';

import 'package:reorderables/reorderables.dart';

class AiWritePage extends StatefulWidget {
  const AiWritePage({Key? key, this.title = 'AirmailGPT for ROKAF'}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _AiWritePageState();
}

class _AiWritePageState extends StateMVC<AiWritePage> {
  _AiWritePageState() : super(AiWriteEditController()) {
    con = controller as AiWriteEditController;
  }

  late AiWriteEditController con;

  final FocusNode outFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  
  final keywordText = TextEditingController();

  final List<DropdownMenuEntry<String>> relationshipDropdownEntries = const [
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

    void doAddKeyword() {
      List<String>? result = con.addKeyword();

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: SetState(
                  builder: (context, dataObject) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
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
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '관계',
                                  ),
                                  validator: (value) => value!.isEmpty ? '관계를 입력해주세요' : null,
                                  initialValue: con.relationship,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) => con.relationship = value,
                                ),
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
                                        onReorder: (int oldIndex, int newIndex) => con.reorderKeyword(oldIndex, newIndex),
                                        children: con.keywordChipList,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: '키워드 추가',
                                        suffixIcon: IconButton(
                                          padding: const EdgeInsets.all(20),
                                          onPressed: doAddKeyword,
                                          icon: const Icon(Icons.add),
                                        ),
                                      ),
                                      controller: keywordText,
                                      onChanged: (value) => con.keywordInput = value,
                                      onEditingComplete: () {
                                        doAddKeyword();
                                        keywordText.clear();
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  con.airmanName = constantAirmanName;
                                  con.airmanBirth = constantAirmanBirth;
                                  if (con.keywordInput.isNotEmpty) {
                                    doAddKeyword();
                                    keywordText.clear();
                                  }
                                  con.keywordListToKeyword();
                                  
                                  con.navigateToAiEditPage(context);
                                }
                              },
                              child: const Text('인편 생성하기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}