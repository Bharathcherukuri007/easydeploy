import 'package:easydeploy/add_project.dart';
import 'package:easydeploy/header.dart';
import 'package:easydeploy/models/project.dart';
import 'package:easydeploy/models/user.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  String code;
  Home({super.key, required this.code});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GithubBloc? githubBloc;
  String? url;
  late SharedPreferences prefs ;
  
  
  @override
  void initState() {
    super.initState();
   
   String  backEnd = "http://localhost:3000/home";
    url = "http://github.com/login/oauth/authorize?client_id=fa23522ab6b034935c9b&redirection_url=${backEnd}&scope=workflow,repo,user:email";
    Future.delayed(Duration.zero, () async{
       prefs = await SharedPreferences.getInstance();
       githubBloc!.getProjects();
      if(prefs.getString("username") == null){
        if(widget.code.isNotEmpty){
          githubBloc!.authenticate(widget.code);

        }
      }
      else{
        githubBloc!.addUser(User(userName: prefs.getString("username"), profileUrl: prefs.getString("profileUrl"), email: prefs.getString("email")));
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Scaffold(
      
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Header(),
            SizedBox(height: 100,),
            ProjectCard()
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  const ProjectCard({super.key});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {

  GithubBloc? githubBloc;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Container(
      height: 200,
      child: StreamBuilder<List<Project>>(
        stream: githubBloc!.projectStream,
        builder: (context, snapshot) {
          if(snapshot.data == null){
            return const Text("No Projects");
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length + 1,
            itemBuilder: ((context, index) {
              if(index == snapshot.data!.length){
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                      return AddProject();
                    })));
                  },
                  child: Container(
                  width: 400,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green)
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(20),
                  child: const Center(child: Text("Add a new Project"),)),
                );
              }
              var project = snapshot.data![index];
              return Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green)
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            launchUrl(Uri.parse(project.siteName!));
                          },
                          child: Text(project.siteName!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),)),
                        Text(project.conclusion!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.green))
                      ],
                    ),
                    Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(project.repoName.toString()!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, )),
                        Text(project.frameWork!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        Text(project.version!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, ))
                      ],
                    )
                
                  ],
                ),
              );
            
          }));
        
      },),
    );
  }
}