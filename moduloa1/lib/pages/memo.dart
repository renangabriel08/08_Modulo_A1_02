import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moduloa1/controlles/app.dart';
import 'package:moduloa1/styles/styles.dart';
import 'package:moduloa1/widgest/toast.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Memo extends StatefulWidget {
  const Memo({super.key});

  @override
  State<Memo> createState() => _MemoState();
}

class _MemoState extends State<Memo> {
  Timer? timer;
  int timerJogo = 0;

  String tema = 'Animais da Amazonia';
  int tempo = 3;
  int estado = 0;

  List imagens1 = [];
  List imagens2 = [];

  @override
  void initState() {
    tema = 'Animais da Amazonia';
    imagens1 = List.generate(
      4,
      (index) => {'img': 'assets/$tema/$index.jpg', 'virado': true},
    );

    imagens2 = List.generate(
      4,
      (index) => {'img': 'assets/$tema/$index.jpg', 'virado': true},
    );

    imagens1.shuffle();
    imagens2.shuffle();
    setState(() {});

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    var battery = Battery();
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (await battery.batteryLevel <= 20 && !App.bateria) {
        App.bateria = true;
        App.modalBateria(context);
      }
    });

    gyroscopeEvents.listen(
      (GyroscopeEvent event) {
        if (estado == 2) {
          if (event.z < -2 || event.z > 2) {
            imagens1.shuffle();
            imagens2.shuffle();

            setState(() {});
          }
        }
      },
      onError: (error) {},
      cancelOnError: true,
    );

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text('MemoCheck')),
      body: SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timer == null
                        ? 'Tempo: 00:00'
                        : 'Tempo: ${timerJogo ~/ 60 < 10 ? '0${timerJogo ~/ 60}' : timerJogo ~/ 60}:${timerJogo % 60 < 10 ? '0${timerJogo % 60}' : timerJogo % 60}',
                    style: TextStyle(color: Cores.preto),
                  ),
                  Text('Acertos: 00', style: TextStyle(color: Cores.preto)),
                  Text('Erros: 00', style: TextStyle(color: Cores.preto)),
                ],
              ),
              Container(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tema'),
                  SizedBox(
                    width: width * .7,
                    child: estado != 2
                        ? DropdownButtonFormField(
                            value: tema,
                            items: [
                              DropdownMenuItem(
                                value: 'Animais da Amazonia',
                                child: Text('Animais da Amazonia'),
                              ),
                              DropdownMenuItem(
                                value: 'Carros',
                                child: Text('Carros'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                tema = value.toString();
                              });
                              imagens1 = List.generate(
                                4,
                                (index) => {
                                  'img': 'assets/$tema/$index.jpg',
                                  'virado': true,
                                },
                              );
                            },
                          )
                        : DropdownButtonFormField(
                            items: [],
                            onChanged: (value) => (),
                          ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images = await picker.pickMultiImage();

                      if (images.isEmpty) {
                        MyToast.get('Nenhuma imagem selecionada.', context);
                      } else {
                        MyToast.get(
                          'Imagens selecionadas com sucesso!',
                          context,
                        );
                      }
                    },
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
              Container(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width * .4,
                    height: height * .4,
                    child: Wrap(
                      children: [
                        for (var img in imagens1)
                          GestureDetector(
                            onTap: () {
                              if (estado == 2) {
                                img['virado'] = !img['virado'];
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: height * .17,
                                width: width * .17,
                                child: img['virado']
                                    ? Image.asset(img['img'], fit: BoxFit.cover)
                                    : Container(color: Cores.azulEscuro),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (estado == 2) {
                        estado = 0;
                        for (var img in imagens1) {
                          img['virado'] = true;
                        }
                        for (var img in imagens2) {
                          img['virado'] = true;
                        }

                        timer?.cancel();
                        timer = null;
                        timerJogo = 0;
                        MyToast.get('Partida encerrada com sucesso', context);
                        setState(() {});
                      } else if (estado == 0) {
                        estado = 1;
                        tempo = 3;
                        setState(() {});
                        await Future.delayed(const Duration(seconds: 1));
                        tempo--;
                        setState(() {});
                        await Future.delayed(const Duration(seconds: 1));
                        tempo--;
                        setState(() {});
                        await Future.delayed(const Duration(seconds: 1));
                        tempo--;
                        estado = 2;
                        setState(() {});

                        for (var img in imagens1) {
                          img['virado'] = false;
                        }
                        for (var img in imagens2) {
                          img['virado'] = false;
                        }

                        MyToast.get('Partida iniciada com sucesso', context);

                        timer = Timer.periodic(
                          const Duration(seconds: 1),
                          (timer) => setState(() {
                            timerJogo++;
                          }),
                        );

                        setState(() {});
                      }
                    },
                    child: Text(
                      estado == 0
                          ? 'START'
                          : estado == 1
                          ? '00:0$tempo'
                          : 'STOP',
                    ),
                  ),
                  SizedBox(
                    width: width * .4,
                    height: height * .4,
                    child: Wrap(
                      children: [
                        for (var img in imagens2)
                          GestureDetector(
                            onTap: () {
                              if (estado == 2) {
                                img['virado'] = !img['virado'];
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: height * .17,
                                width: width * .17,
                                child: img['virado']
                                    ? Image.asset(img['img'], fit: BoxFit.cover)
                                    : Container(color: Cores.azulEscuro),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
