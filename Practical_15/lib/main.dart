import 'package:flutter/material.dart';

const appTitle = "32-IST: Valentyn's last Flutter App";
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: appTitle,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: const CounterPage(),
  );
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(appTitle)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Кількість натискань'),
          Text(
            '$_counter',
            key: const ValueKey('count'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      key: const ValueKey('increment'),
      tooltip: 'Збільшити на 1',
      onPressed: () => setState(() => _counter += 1),
      child: const Icon(Icons.person),
    ),
  );
}
