import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {

  final bool swap = false;

  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool swap = false;

  @override
  void initState() {
    swap = widget.swap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buttonTile = ListTile(
      title: ElevatedButton(
          child: const Text("Swap Widget"),
          onPressed: (){
            setState((){
              swap = !swap;
            });
          }
      ),
    );

    Widget swapWidget;
    if (swap) {
      swapWidget = const Text("Brandon");
    } else {
      swapWidget = const Icon(Icons.cake);
    }

    var swapTile = ListTile(
      title: swapWidget,
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text("App Bar Title"),
      ),
      body: ListView(
        children: <Widget>[
          buttonTile,
          swapTile,
        ],
      ),
    );
  }

}