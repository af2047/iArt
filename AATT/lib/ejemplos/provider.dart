import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Por defecto, cada widget sólo puede acceder a sus variables de estado,
y no a las variables declaradas en otros puntos de la aplicación.
Este plugin sirve para almacenar estado que sea común a todos los widgets

El estado se almacena en un "provider".
Hay que usar un provider u otro en función del tipo de variables que queramos compartir
Provider --> para variables inmutables
StateProvider --> para variables que se pueden modificar
https://riverpod.dev/docs/providers/state_provider/

Los widgets normales no pueden acceder al provider, hay que usar
estos tipos especiales:
StatelessWidget --> ConsumerWidget
StatefulWidget, State --> ConsumerStatefulWidget, ConsumerState
*/


// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
final helloWorldProvider = Provider((_) => 'Hello world');

void main() {
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Example')),
        body: Center(
          child: Text(value),
        ),
      ),
    );
  }
}