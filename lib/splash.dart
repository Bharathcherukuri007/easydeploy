import 'package:easydeploy/providers/github_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  GithubBloc? githubBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (() async{
      


      
    }));
  }
  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Container(
      height: 40,
      width: 40,
      child: CircularProgressIndicator(),
    );
  }
}