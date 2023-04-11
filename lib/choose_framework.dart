import 'package:easydeploy/details.dart';
import 'package:easydeploy/header.dart';
import 'package:easydeploy/models/project.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class ChooseFramework extends StatefulWidget {
  const ChooseFramework({super.key});

  @override
  State<ChooseFramework> createState() => _ChooseFrameworkState();
}

class _ChooseFrameworkState extends State<ChooseFramework> {

  GithubBloc? githubBloc;

  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<Project>(
          stream: githubBloc!.newProject.stream,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(margin: const EdgeInsets.symmetric(horizontal: 20), child: Header(),),
                Text("Choose Framework", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.green)),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FrameworkCard(
                      toshow: githubBloc!.newProject.value.frameWork != null && githubBloc!.newProject.value.frameWork == "flutter",
                      title: "Flutter", path: "assets/flutter.png", onTap: () {
                      var res = githubBloc!.newProject.value;
                      res.frameWork = "flutter";
                      githubBloc!.newProject.add(res);
                    },),
                    FrameworkCard(
                      toshow: githubBloc!.newProject.value.frameWork != null && githubBloc!.newProject.value.frameWork == "react",
                      title: "React", path: "assets/react.png", onTap: () {
                      var res = githubBloc!.newProject.value;
                      res.frameWork = "react";
                      githubBloc!.newProject.add(res);
                    },)
        
                  ],
                  
                ),
                Expanded(child: Container()),
                if(snapshot.data != null && snapshot.data!.frameWork != null && snapshot.data!.frameWork!.isNotEmpty)...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: Container( child: Center(child: Text("Continue"))),
                          onPressed: (() {
                            Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                              return Details();
                            })));
                        }))
                      ],
                    ),
                      )
                ]
              ],
            );
          }
        ),
      ),
    );
  }
}

class FrameworkCard extends StatelessWidget {
  String title;
  String path;
  double? height;
  double? width;
  bool toshow ;
  VoidCallback? onTap;
  FrameworkCard({super.key , required this.title, required this.path, this.onTap, this.height, this.width, this.toshow = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? onTap! : null ,
      child: Stack(
        children: [
          Container(
            height: height ?? 500,
            width:  width ?? 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(path, height: 300, width: 300,),
                Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),)
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20)
            ),
            
          ),
          if(toshow)
            Positioned(top: 10, right: 10,  child: ClipOval(child: Container(padding: EdgeInsets.all(10), color: Colors.blue, child: Icon(Icons.check),))),
        ],
      ),
    );
  }
}