import 'dart:convert';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:moduloa1/controlles/app.dart';
import 'package:moduloa1/styles/styles.dart';
import 'package:moduloa1/widgest/toast.dart';
import 'package:sensors_plus/sensors_plus.dart';

class QuizMyBrain extends StatefulWidget {
  const QuizMyBrain({super.key});

  @override
  State<QuizMyBrain> createState() => _QuizMyBrainState();
}

class _QuizMyBrainState extends State<QuizMyBrain> {
  List questoes = [];
  int index = 0;
  Map questao = {};
  bool clicado = false;
  bool loading = true;
  int pontuacao = 0;
  String alternativaSelecionada = '';

  startApp() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    String json = await rootBundle.loadString('assets/bancoQuestoes.json');
    Map data = jsonDecode(json);
    questoes = data['perguntas'];
    questao = questoes[0];

    var battery = Battery();
    battery.onBatteryStateChanged.listen((BatteryState state) async {
      if (await battery.batteryLevel <= 20 && !App.bateria) {
        App.bateria = true;
        App.modalBateria(context);
      }
    });

    accelerometerEvents.listen(
      (AccelerometerEvent event) {
        if (questao['tipo'] == "VF") {
          if (event.x > 2) {
            alternativaSelecionada = 'Falso';
          } else if (event.x < -2) {
            alternativaSelecionada = 'Verdadeiro';
          }

          setState(() {});
        }
      },
      onError: (error) {},
      cancelOnError: true,
    );

    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (questao['tipo'] == "REL") {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz My Brain'),
        automaticallyImplyLeading: true,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SizedBox(
              width: width,
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: questao['tipo'] == 'ME'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                questao['enunciado'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  for (var alternativa
                                      in questao['alternativas'])
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          alternativaSelecionada = alternativa;
                                        }),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color:
                                                  (clicado &&
                                                      alternativa ==
                                                          questao['alternativas'][questao['resposta']])
                                                  ? Cores.azulEscuro
                                                  : alternativaSelecionada ==
                                                        alternativa
                                                  ? Cores.azulClaro
                                                  : Cores.preto,
                                            ),
                                          ),
                                          width: width,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '$alternativa',
                                              style: TextStyle(
                                                color:
                                                    (clicado &&
                                                        alternativa ==
                                                            questao['alternativas'][questao['resposta']])
                                                    ? Cores.azulEscuro
                                                    : alternativaSelecionada ==
                                                          alternativa
                                                    ? Cores.azulClaro
                                                    : Cores.preto,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  MyToast.get(
                                    'Jogo encerrado. Seu score foi de: $pontuacao',
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Encerrar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (!clicado) {
                                    clicado = true;
                                    if (alternativaSelecionada ==
                                        questao['alternativas'][questao['resposta']]) {
                                      pontuacao += int.parse(
                                        questao['peso'].toString(),
                                      );
                                    }
                                  } else {
                                    clicado = false;
                                    alternativaSelecionada = '';

                                    index++;
                                    questao = questoes[index];
                                  }

                                  setState(() {});
                                },
                                child: Text('Próximo'),
                              ),
                            ],
                          ),
                        ],
                      )
                    : questao['tipo'] == 'VF'
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                questao['enunciado'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var alternativa
                                      in questao['alternativas'])
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          alternativaSelecionada = alternativa;
                                        }),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 2,
                                              color:
                                                  (clicado &&
                                                      alternativa ==
                                                          questao['alternativas'][questao['resposta']])
                                                  ? Cores.azulEscuro
                                                  : alternativaSelecionada ==
                                                        alternativa
                                                  ? Cores.azulClaro
                                                  : Cores.preto,
                                            ),
                                          ),
                                          width: width * .3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '$alternativa',
                                              style: TextStyle(
                                                color:
                                                    (clicado &&
                                                        alternativa ==
                                                            questao['alternativas'][questao['resposta']])
                                                    ? Cores.azulEscuro
                                                    : alternativaSelecionada ==
                                                          alternativa
                                                    ? Cores.azulClaro
                                                    : Cores.preto,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  MyToast.get(
                                    'Jogo encerrado. Seu score foi de: $pontuacao',
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Encerrar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  alternativaSelecionada = '';

                                  index++;
                                  questao = questoes[index];

                                  setState(() {});
                                },
                                child: Text('Próximo'),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                questao['enunciado'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var alternativa
                                      in questao['alternativas'][0])
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color:
                                                (clicado &&
                                                    alternativa ==
                                                        questao['alternativas'][questao['resposta']])
                                                ? Cores.azulEscuro
                                                : alternativaSelecionada ==
                                                      alternativa
                                                ? Cores.azulClaro
                                                : Cores.preto,
                                          ),
                                        ),
                                        width: width * .25,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '$alternativa',
                                            style: TextStyle(
                                              color:
                                                  (clicado &&
                                                      alternativa ==
                                                          questao['alternativas'][questao['resposta']])
                                                  ? Cores.azulEscuro
                                                  : alternativaSelecionada ==
                                                        alternativa
                                                  ? Cores.azulClaro
                                                  : Cores.preto,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Container(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  for (var alternativa
                                      in questao['alternativas'][1])
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2,
                                            color:
                                                (clicado &&
                                                    alternativa ==
                                                        questao['alternativas'][questao['resposta']])
                                                ? Cores.azulEscuro
                                                : alternativaSelecionada ==
                                                      alternativa
                                                ? Cores.azulClaro
                                                : Cores.preto,
                                          ),
                                        ),
                                        width: width * .25,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            '$alternativa',
                                            style: TextStyle(
                                              color:
                                                  (clicado &&
                                                      alternativa ==
                                                          questao['alternativas'][questao['resposta']])
                                                  ? Cores.azulEscuro
                                                  : alternativaSelecionada ==
                                                        alternativa
                                                  ? Cores.azulClaro
                                                  : Cores.preto,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  MyToast.get(
                                    'Jogo encerrado. Seu score foi de: $pontuacao',
                                    context,
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text('Encerrar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  alternativaSelecionada = '';
                                  index++;
                                  if (index < questoes.length) {
                                    questao = questoes[index];
                                  } else {
                                    MyToast.get(
                                      'Jogo encerrado. Seu score foi de: $pontuacao',
                                      context,
                                    );
                                    Navigator.pop(context);
                                  }
                                  setState(() {});
                                },
                                child: Text('Próximo'),
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
