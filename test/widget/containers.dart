import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white10),
      debugShowCheckedModeBanner: false, // Remove the debug banner
      home: SafeArea(
          child: Scaffold(
              body: Column(children: <Widget>[
        parchisWitget(context),
      ]))),
    );
  }

  Widget parchisWitget(BuildContext context) {
    const double size01 = 20.0;
    const double size02 = 25.0;

    return Expanded(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("Parchis Colors:",
                          style: TextStyle(
                              fontSize: size01, fontWeight: FontWeight.bold)),
                    ]))), // Text Top

        Expanded(
            child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  color: Colors.red,
                  child: const Center(
                      child: Text("Red Color",
                          style: TextStyle(fontSize: size02))))),
          Expanded(
              child: Container(
                  color: Colors.yellow,
                  child: const Center(
                      child: Text("Yellow Color",
                          style: TextStyle(fontSize: size02))))),
        ])), //Row 1/2

        Expanded(
            child: Row(children: <Widget>[
          Expanded(
              child: Container(
                  color: Colors.green,
                  child: const Center(
                      child: Text("Green Color",
                          style: TextStyle(fontSize: size02))))),
          Expanded(
              child: Container(
                  color: Colors.blue,
                  child: const Center(
                      child: Text("Blue Color",
                          style: TextStyle(fontSize: size02))))),
        ])), //Row 2/2
        Expanded(
            child: Container(
                color: Colors.white,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("¿What's your favourite color?",
                          style: TextStyle(
                              fontSize: size01, fontWeight: FontWeight.bold))
                    ]))), // Text Bottom
      ],
    ));
  }
}