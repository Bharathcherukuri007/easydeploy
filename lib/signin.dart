import 'package:easydeploy/providers/github_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


class SignIn extends StatefulWidget {
  String code;
  SignIn({super.key, required this.code});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? code;
  String? url;
  String? backEnd;
  
  GithubBloc? githubBloc;
  
  
  @override
  void initState() {
    super.initState();
    code = widget.code;
   String  backEnd = "https://localhost:3000/home";
    url = "http://github.com/login/oauth/authorize?client_id=fa23522ab6b034935c9b&redirection_url=${backEnd}&scope=workflow,repo,email";
    Future.delayed(Duration.zero, (){
      if(widget.code.isNotEmpty){
        githubBloc!.authenticate(widget.code);

      }

    });
  }

  
  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Scaffold(
      appBar: PreferredSize(child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Link(uri: Uri.parse(url!), builder: ((context, followLink) {
            return GestureDetector(
              onTap: followLink,
              child: AbsorbPointer(
                child: ElevatedButton(onPressed: () => null, child: Text("SignIn"))),
            );
          }
          ))
        ],
      ), preferredSize: Size(double.infinity, 300)),
    );
    
  }
}


