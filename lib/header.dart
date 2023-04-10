import 'package:easydeploy/home.dart';
import 'package:easydeploy/models/user.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:easydeploy/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  GithubBloc? githubBloc;
  String? url;

  @override
  void initState() {
    super.initState();
   String  backEnd = "http://localhost:3000/home";
    url = "http://github.com/login/oauth/authorize?client_id=fa23522ab6b034935c9b&redirection_url=${backEnd}&scope=workflow,repo,user:email";
    

    
  }

  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);

    return StreamBuilder<User>(
      stream: githubBloc!.userStream,
      builder: ((context, snapshot) {
        githubBloc!.getProjects();
        if(snapshot.data == null || snapshot.data!.userName == null || snapshot.data!.profileUrl == null){
          return PreferredSize(child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Link(uri: Uri.parse(url!), builder: ((context, followLink) {
                return GestureDetector(
                  onTap: (() async{
                    await followLink!.call();
                  }),
                  child: AbsorbPointer(
                    child: ElevatedButton(onPressed: () => null, child: Text("SignIn"))),
                );
              }
              ))
            ],
          ), preferredSize: Size(double.infinity, 300));
        }
        return PreferredSize(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(snapshot.data!.userName!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green),),
              Row(
                children: [
                  ClipOval(
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Image.network(snapshot.data!.profileUrl!),
                    ),
                    
                  ),
                   PopupMenuButton(
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                itemBuilder: ((context) {
                  return [PopupMenuItem(child: Text("LogOut"), onTap: () async{
                    var prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                  },),];
                
              }))
                ],
              ),
             
              
            ],
          ), preferredSize: Size(double.infinity, 300));
      }
      ));
  }
}