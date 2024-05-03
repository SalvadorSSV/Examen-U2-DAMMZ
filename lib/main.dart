import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class BeeGame {
  final List<String> beeTypes = ['larva', 'obrera', 'zángano', 'reina'];
  final Random _random = Random();
  int playerHealth = 7;
  String currentBeeType = '';

  void startNewGame() {
    playerHealth = 7;
    currentBeeType = '';
  }

  String uncoverCell(int index) {
    if ([0, 4, 20, 24].contains(index)) {
      currentBeeType = 'obrera'; // Las obreras aparecerán en las esquinas
    } else {
      currentBeeType = beeTypes[_random.nextInt(beeTypes.length)];
    }
    return currentBeeType;
  }

  void updateHealth() {
    if (currentBeeType == 'larva') {
      playerHealth += 0;
    } else if (currentBeeType == 'obrera') {
      playerHealth -= 1;
    } else if (currentBeeType == 'zángano') {
      playerHealth -= 2;
    } else if (currentBeeType == 'reina') {
      // Game over if the player finds the queen bee
      playerHealth = max(playerHealth, 0); // No puntos de vida negativos
    }
  }
}

class MyApp extends StatelessWidget {
  final BeeGame beeGame = BeeGame();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La colmena ',
      home: Scaffold(
        appBar: AppBar(title: const Text('La colmena')),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellSize = constraints.maxWidth / 5; // 5 columns
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 3, // Make cells square
                ),
                itemCount: 25, // Total cells
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black), // Borde negro
                      color: Colors.yellow, // Color amarillo
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        final beeType = beeGame.uncoverCell(index);
                        beeGame.updateHealth();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Abeja encontrada: $beeType'),
                              content: Text('Puntos de vida restantes: ${beeGame.playerHealth}'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    if (beeGame.playerHealth <= 0) {
                                      beeGame.startNewGame();
                                      Navigator.pop(context); // Cerrar la alerta anterior
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('¡Perdiste!'),
                                            content: const Text('Mejor suerte la próxima vez.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Aceptar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else if (beeType == 'reina') {
                                      Navigator.pop(context); // Cerrar la alerta anterior
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('¡Ganaste!'),
                                            content: const Text('Encontraste a la abeja reina.👑🐝'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  beeGame.startNewGame();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Aceptar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.pop(context); // Cerrar la alerta anterior
                                    }
                                  },
                                  child: const Text('Continuar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(cellSize, cellSize),
                        backgroundColor: Colors.yellow,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero, // Elimina el radio
                        ),
                      ),
                      child: const Text('🐝🐝🐝'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
