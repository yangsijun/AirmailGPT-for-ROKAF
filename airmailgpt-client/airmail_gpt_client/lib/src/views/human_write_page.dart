import 'package:flutter/services.dart';

import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

import 'package:airmail_gpt_client/res/setting.dart';

class HumanWritePage extends StatefulWidget {
  const HumanWritePage({Key? key, this.title = 'AirmailGPT for ROKAF'}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HumanWritePageState();
}

class _HumanWritePageState extends StateMVC<HumanWritePage> {
  _HumanWritePageState() : super(HumanWriteController()) {
    con = controller as HumanWriteController;
  }

  late HumanWriteController con;

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
                              initialValue: con.sender.name,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => con.sender.name = value,
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
                                  controller: TextEditingController(text: con.sender.relationship),
                                  dropdownMenuEntries: List<DropdownMenuEntry<String>>.generate(
                                    relationshipDropdownEntries.length,
                                    (index) => DropdownMenuEntry(
                                      value: relationshipDropdownEntries[index].value,
                                      label: relationshipDropdownEntries[index].label,
                                    ),
                                  ),
                                  onSelected: (value) => con.sender.relationship = value!,
                                );
                              }
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
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '제목',
                        ),
                        validator: (value) => value!.isEmpty ? '제목을 입력해주세요' : null,
                        initialValue: con.mailBody.title,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => con.mailBody.title = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '내용',
                        ),
                        minLines: 10,
                        maxLines: 30,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '내용을 입력해주세요';
                          }
                          if (value.length > 1200) {
                            return '내용은 1200자 이하로 입력해주세요';
                          }
                          return null;
                        },
                        initialValue: con.mailBody.content,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) => con.mailBody.content = value,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              con.sendMail();
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