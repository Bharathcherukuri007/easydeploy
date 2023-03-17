import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


class SignIn extends StatefulWidget {
  SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static String get backEnd => "https://localhost:3001/authorize";
  String url = "http://github.com/login/oauth/authorize?client_id=fa23522ab6b034935c9b&redirection_url=${backEnd}&scope=workflow,repo";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Link(uri: Uri.parse(url), builder: ((context, followLink) {
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


