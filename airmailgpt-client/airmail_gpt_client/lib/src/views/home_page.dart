import 'package:airmail_gpt_client/res/setting.dart';

import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

import 'package:timer_builder/timer_builder.dart';

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

  DateTime now = DateTime.now();

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
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
                  now = DateTime.now();
                  if (now.isBefore(constantBootcampEndDate)) {
                    return Text(
                      '훈련소 수료까지 ${constantBootcampEndDate.difference(now).inDays}일 ${constantBootcampEndDate.difference(now).inHours % 24}시간 ${constantBootcampEndDate.difference(now).inMinutes % 60}분 ${constantBootcampEndDate.difference(now).inSeconds % 60}초 남음',
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  } else {
                    return Text(
                      '훈련소 수료했습니다!',
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  }
                }),
                Text(
                  '(인편 작성 기간: ${constantMailStartDate.year}년 ${constantMailStartDate.month}월 ${constantMailStartDate.day}일 ${constantMailStartDate.hour}시 ~ ${constantMailEndDate.year}년 ${constantMailEndDate.month}월 ${constantMailEndDate.day}일 ${constantMailEndDate.hour}시)',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () {
                        now = DateTime.now();
                        if (now.isBefore(constantMailStartDate) || now.isAfter(constantMailEndDate)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('인편 작성 기간이 아닙니다!'),
                              duration: const Duration(seconds: 5),
                              action: SnackBarAction(
                                label: '확인',
                                onPressed: () {},
                              )
                            ),
                          );
                        } else {
                          con.navigateToAiWritePage(context);
                        }
                      },
                      child: const Text('AI로 작성하기'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () {
                        now = DateTime.now();
                        if (now.isBefore(constantMailStartDate) || now.isAfter(constantMailEndDate)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('인편 작성 기간이 아닙니다!'),
                              duration: const Duration(seconds: 5),
                              action: SnackBarAction(
                                label: '확인',
                                onPressed: () {},
                              )
                            ),
                          );
                        } else {
                          con.navigateToHumanWritePage(context);
                        }
                      },
                      child: const Text('직접 작성하기'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                      onPressed: () {
                        now = DateTime.now();
                        if (now.isBefore(constantMailStartDate) || now.isAfter(constantMailEndDate)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('인편 작성 기간이 아닙니다!'),
                              duration: const Duration(seconds: 5),
                              action: SnackBarAction(
                                label: '확인',
                                onPressed: () {},
                              )
                            ),
                          );
                        } else {
                          SendController().launchMailListUrl();
                        }
                      },
                      child: const Text('보낸 인편 확인하기'),
                    ),
              ],
            )
          ),
        ],
      ),
    );
  }
}