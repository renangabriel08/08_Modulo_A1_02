import 'dart:async';
import 'dart:ui';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/controlles/app.dart';
import 'package:moduloa1/styles/styles.dart';
import 'package:moduloa1/widgest/toast.dart';

class Genius extends StatefulWidget {
  const Genius({super.key});

  @override
  State<Genius> createState() => _GeniusState();
}

class _GeniusState extends State<Genius> {
  String linguagem = 'pt';
  Timer? timer;
  int timerJogo = 0;

  String txt = 'Start';

  @override
  void initState() {
    if (window.locale.languageCode == 'es') {
      linguagem = 'es';
    } else if (window.locale.languageCode == 'en') {
      linguagem = 'en';
    } else {
      linguagem = 'pt';
    }

    setState(() {});

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    var battery = Battery();
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (await battery.batteryLevel <= 20 && !App.bateria) {
        App.bateria = true;
        App.modalBateria(context);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Genius Play'),
      ),
      body: Container(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              DropdownButtonFormField(
                value: linguagem,
                items: [
                  DropdownMenuItem(value: 'pt', child: Text('Português')),
                  DropdownMenuItem(value: 'en', child: Text('Inglês')),
                  DropdownMenuItem(value: 'es', child: Text('Espanhol')),
                ],
                onChanged: (value) => setState(() {
                  linguagem = value.toString();
                }),
              ),
              Container(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nível: 1',
                    style: TextStyle(color: Cores.preto, fontSize: 16),
                  ),
                  Text(
                    timer == null
                        ? 'Cronometro: 00:00'
                        : 'Cronometro: ${timerJogo ~/ 60 < 10 ? '0${timerJogo ~/ 60}' : timerJogo ~/ 60}:${timerJogo % 60 < 10 ? '0${timerJogo % 60}' : timerJogo % 60}',
                    style: TextStyle(color: Cores.preto),
                  ),
                ],
              ),
              Container(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Score: 0', style: TextStyle(color: Cores.preto)),
                  ElevatedButton(
                    onPressed: () => (),
                    child: Text(
                      'Restart',
                      style: TextStyle(color: Cores.preto, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Container(height: 16),
              Container(
                width: 300,
                height: 300,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (txt == 'Start') {
                        txt = 'Stop';
                        setState(() {});
                        timer = Timer.periodic(
                          const Duration(seconds: 1),
                          (timer) => setState(() {
                            timerJogo++;
                          }),
                        );

                        MyToast.get('Jogo iniciado com sucesso', context);
                      } else {
                        timer?.cancel();
                        timer = null;
                        timerJogo = 0;
                        MyToast.get('Jogo finalizado com sucesso', context);
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                    child: Text(txt),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
