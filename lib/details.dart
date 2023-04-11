import 'package:easydeploy/header.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  GithubBloc? githubBloc;
  bool failed = true;
  bool isLoading = false;
  bool isWebhookLoading = false;
  bool webhookFailed = true;
  bool allow = false;
  
  TextEditingController _text = TextEditingController();
  TextEditingController _path = TextEditingController();
  TextEditingController _version = TextEditingController();
  TextEditingController _email = TextEditingController();
  ValueNotifier<bool> isValid = ValueNotifier(false);

  final _formKey = GlobalKey<FormState>();
  
  String get filename => githubBloc!.newProject.value.frameWork == "flutter" ? "pubspec.yaml" : "Package.json";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){


    });
  }
  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    String? errorText;
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: isValid,
        builder: (context, data, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Header(),
                  SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 350,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _text,
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.w500),
                          validator: (value) => value!.isEmpty ? "name cannot be empty" : null,
                          onChanged: (value) {
                            setState(() {
                              
                            });
                          },
                          decoration: InputDecoration(
                            enabled: !allow,
                            label: Text("Enter Site Name"),
                            labelStyle: TextStyle(color: Colors.green),
                            helperText: _text.text.isEmpty ? "https://Link.netlify.app" : "https://${_text.text}.netlify.app",
                            enabledBorder: failed ? OutlineInputBorder(borderSide: BorderSide(color: Colors.green)) : OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            ),
                          ),
                         
                        ),
                      ),
                      SizedBox(width: 50,),
                      InkWell(
                        onTap: () async{
                          _formKey.currentState!.validate();
                          if(_text.text.isEmpty){
                              return;
                          }
                          setState(() {
                            isLoading = true;
                          });
                          failed = await githubBloc!.validateSite(_text.text);
                          
                          allow = failed;
                          setState(() {
                            isLoading = false;
                          });
                          isValid.value = failed;
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: !failed ? Colors.red : Colors.green,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: isLoading ? Center(child: CircularProgressIndicator()) : Text("CHECK"),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 350,
                        child: TextFormField(
                          controller: _path,
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            label: Text("Enter path for $filename"),
                            labelStyle: TextStyle(color: Colors.green),
                            helperText: r"Note: By default the path will be '/' ",
                            helperStyle: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            ),
                          ),
                         
                        ),
                      ),
                      SizedBox(width: 120,),
                    ],
                  ),
                  SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 350,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _version,
                          onChanged: (value) {
                            setState(() {
                              
                            });
                          },
                          validator: (value) => value!.isEmpty ? "version should not be empty" : null,
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 20, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            label: Text("Enter version"),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)
                            ),
                          ),
                         
                        ),
                      ),
                      SizedBox(width: 120,)
      
                    ],
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: Container( child: Center(child: Text("Continue"))),
                          onPressed: isValid.value && _formKey.currentState!.validate() ? (() async{
                            var project = githubBloc!.newProject.value;
                            project.version = _version.text;
                            if(_path.text.endsWith("/")){
                              project.path = _path.text;
                            }
                            else{
                              project.path = _path.text +"/";
                            }
                            githubBloc!.newProject.add(project);
                            var res = await githubBloc!.addWebHook(githubBloc!.currentUser!.userName!, project.repoName!);
                            if(!res){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("WebHook Failed")));
                              return;
                            }
                            var response = await githubBloc!.deploySite(project, githubBloc!.currentUser!);
                            if(response){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success")));
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed")));
                            }
                            var p = githubBloc!.newProject.value;
                            githubBloc!.addProject(p);
                            GoRouter.of(context).push("/");

                            
                        } 
                        ): null
                        )
                      ],
                    ),
                      )
      
            ]),
          ),
          );
        }
      ));
  }
}