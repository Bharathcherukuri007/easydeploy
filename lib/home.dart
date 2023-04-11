import 'package:easydeploy/add_project.dart';
import 'package:easydeploy/choose_framework.dart';
import 'package:easydeploy/header.dart';
import 'package:easydeploy/models/project.dart';
import 'package:easydeploy/models/user.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart' as fram;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
   
   String  backEnd = "https://easydeployprod.netlify.app/";
    url = "http://github.com/login/oauth/authorize?client_id=fa23522ab6b034935c9b&redirection_url=${backEnd}&scope=workflow,repo:status,user:email";
    Future.delayed(Duration.zero, () async{
      try{
        prefs = await SharedPreferences.getInstance();
        if(prefs == null || prefs.getString("username") == null){
          if(widget.code.isNotEmpty){
            githubBloc!.authenticate(widget.code);

          }
        }
        else{
        githubBloc!.addUser(User(userName: prefs.getString("username"), profileUrl: prefs.getString("profileUrl"), email: prefs.getString("email")));
        githubBloc!.getProjects();
      }
      }
      catch(e){
        print(e);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(includeBackButton: false,),
              SizedBox(height: 100,),
              ProjectCard()
            ],
          ),
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
    return StreamBuilder<User>(
      stream: githubBloc!.userStream,
      builder: (context, data) {
        return Container(
          child: StreamBuilder<List<Project>?>(
            stream: githubBloc!.projectStream,
            builder: (context, snapshot) {
              if(data.data == null || (data.data!.userName == null)){
                return LandingPage();
              }
              
              if(snapshot.data == null){
                return const Center(child: CircularProgressIndicator(),);
              }
              return Container(
                height: 200,
                child: ListView.builder(
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
                  
                })),
              );
            
          },),
        );
      }
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: 400,
                  height: 200,
                  child: DefaultTextStyle(
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 70.0,
                      color: Colors.white,
                      fontFamily: 'Horizon',
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      pause: Duration(milliseconds: 1),
                      animatedTexts: [
                            RotateAnimatedText('BUILD',),
                            RotateAnimatedText('INTEGRATE'),
                            RotateAnimatedText('DEPLOY'),
                      ],
                      onTap: () {
                            print("Tap Event");
                      },
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.transparent, blurRadius: 5.0, offset: Offset(0,5))
                ]
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if(constraints.maxWidth < 600){
                    return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Supported Frameworks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),)
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FrameworkCard(title: "Flutter", path: "assets/flutter.png", ),
                          SizedBox(height: 100,),
                          FrameworkCard(title: "React", path: "assets/react.png",)
                        ],
                      ),
                    ],
                  );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Supported Frameworks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FrameworkCard(title: "Flutter", path: "assets/flutter.png", height: 400, width: 400,),
                          FrameworkCard(title: "React", path: "assets/react.png", height: 400, width: 400,)
                        ],
                      ),
                    ],
                  );
                }
              ),
            ),
          )
        ],
      )
    );
  }
}