import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/controlles/app.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  startApp() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.none)) {
      App.modalNet(context);
    }

    var battery = Battery();
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (await battery.batteryLevel <= 20 && !App.bateria) {
        App.bateria = true;
        App.modalBateria(context);
      }
    });

    if (await battery.isInBatterySaveMode) {
      App.modalEconomia(context);
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Drawer(
        child: Column(
          children: [
            Container(height: 50),
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios),
                ),
                // Image.asset('assets/perfil.png'),
              ],
            ),
            ListTile(title: Text('Home'), onTap: () => Navigator.pop(context)),
            ListTile(
              title: Text('QuizMyBrain'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/quiz');
              },
            ),
            ListTile(
              title: Text('GeniusPLay'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/genius');
              },
            ),
            ListTile(
              title: Text('MemoCheck'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/memo');
              },
            ),

            ListTile(title: Text('Sair'), onTap: () => SystemNavigator.pop()),
          ],
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 180),
              Container(height: 16),
              Text(
                'Bem-vindo ao Aprender+',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
