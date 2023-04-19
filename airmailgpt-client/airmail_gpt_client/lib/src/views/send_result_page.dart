import 'package:airmail_gpt_client/src/view.dart';
import 'package:airmail_gpt_client/src/controller.dart';

class SendResultPage extends StatefulWidget {
  const SendResultPage({Key? key, this.title = 'AirmailGPT for ROKAF'}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _SendResultPageState();
}

class _SendResultPageState extends StateMVC<SendResultPage> {
  _SendResultPageState() : super(SendController()) {
    con = controller as SendController;
  }

  late SendController con;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: (con.isMailSent)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  '인편 전송이 완료되었습니다.',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FilledButton(
                      onPressed: () {
                        Navigator.popUntil(context, ModalRoute.withName('/'));
                      },
                      child: const Text('메인으로 이동'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        con.launchMailListUrl();
                      },
                      child: const Text('보낸 인편 확인하기'),
                    ),
                  ],
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  '인편 전송 중입니다.',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
      ),
    );
  }
}