import 'package:easydeploy/home.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:easydeploy/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:async';
import 'dart:io';



final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return  Home(code: state.queryParams["code"] ?? "",);
      },
    ),
  ],
);

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  Router.withConfig(config: _router);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalObjectKey("Route");


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() {
      GlobalErrors().globalErrorStream.listen((event) {
        BuildContext? con = GlobalObjectKey("Route").currentContext;
        if(con != null){
        }

      });
      
    }));
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: GithubBloc())
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        key: navigatorKey,
        title: 'Flutter Demo',
        darkTheme: ThemeData(
        brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(style:  ElevatedButton.styleFrom(backgroundColor: Colors.green)),
      ),
      themeMode: ThemeMode.dark,
        theme: ThemeData(
          primaryColor: Colors.green,
          elevatedButtonTheme: ElevatedButtonThemeData(style:  ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.green)),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.green,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class GlobalErrors {

  late StreamController<Exception> globalExceptions;

  static final GlobalErrors _singleton = new GlobalErrors._internal();
  
  GlobalErrors._internal() {
    globalExceptions = StreamController<Exception>.broadcast();
  }

  void throwException(Exception e, ) {
    globalExceptions.sink.add(e);
    
  }

  Stream<Exception> get globalErrorStream => globalExceptions.stream;

  factory GlobalErrors() {
    return _singleton;
  }

}