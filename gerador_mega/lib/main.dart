import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mega Sena',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: Colors.red[700],
        scaffoldBackgroundColor: Colors.grey[850],
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NumberCubit()),
          BlocProvider(create: (context) => SavedGameCubit()),
        ],
        child: const MyHomePage(title: 'Flutter Mega Sena'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Your Mega Sena numbers:',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              BlocBuilder<NumberCubit, List<int>>(
                builder: (context, numbers) {
                  return _buildNumberRow(numbers);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.read<NumberCubit>().generateNumbers(),
                child: const Text(
                  'Generate Numbers',
                  style: TextStyle(color: Color.fromARGB(255, 231, 20, 5)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<SavedGameCubit>().saveGame(
                        context.read<NumberCubit>().state,
                      );
                },
                child: const Text(
                  'Save Game',
                  style: TextStyle(color: Color.fromARGB(255, 231, 20, 5)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<NumberCubit>().reset();
                  context.read<SavedGameCubit>().reset();
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(color: Color.fromARGB(255, 231, 20, 5)),
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SavedGameCubit, List<List<int>>>(
                builder: (context, savedGames) {
                  return Column(
                    children: savedGames.map((game) {
                      return _buildNumberRow(game);
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberRow(List<int> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: numbers.map((number) => _buildNumberChip(number)).toList(),
    );
  }

  Widget _buildNumberChip(int number) {
    return Container(
      width: 50,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 114, 0, 0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}

class NumberCubit extends Cubit<List<int>> {
  NumberCubit() : super([]);

  void generateNumbers() {
    var rng = Random();
    var numbersSet = <int>{};
    while (numbersSet.length < 6) {
      numbersSet.add(rng.nextInt(60) + 1);
    }
    var numbersList = numbersSet.toList()..sort();
    emit(numbersList);
  }

  void reset() {
    emit([]);
  }
}

class SavedGameCubit extends Cubit<List<List<int>>> {
  SavedGameCubit() : super([]);

  void saveGame(List<int> game) {
    var newGames = [...state, game];
    if (newGames.length > 6) {
      newGames.removeAt(0);
    }
    emit(newGames);
  }

  void reset() {
    emit([]);
  }
}
