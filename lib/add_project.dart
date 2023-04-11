import 'package:easydeploy/choose_framework.dart';
import 'package:easydeploy/header.dart';
import 'package:easydeploy/models/project.dart';
import 'package:easydeploy/providers/github_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {

  GithubBloc? githubBloc;



  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            StreamBuilder<Project>(
              stream: githubBloc!.newProject.stream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    Header(),
                    Row(
                      children: [
                        Expanded(child: Repo()),
                        if(snapshot.data != null)...[
                          Expanded(child: Branch()),
                            
                        ]

                      ],
                    ),
                    if(snapshot.data != null && githubBloc!.newProject.value.branch != null && githubBloc!.newProject!.value.repoName != null)...[
                      SizedBox(height: 200,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              child: Text("Continue"),
                              onPressed: (() {
                                Navigator.of(context).push(MaterialPageRoute(builder: ((context) {
                                  return ChooseFramework();
                                })));
                            }))
                          ],
                        ),
                      )

                    ]

                  ],
                );
              }
            )
          ],
        ),
      ),
    );
  }
}


class Repo extends StatefulWidget {
  const Repo({super.key});

  @override
  State<Repo> createState() => _RepoState();
}

class _RepoState extends State<Repo> {
  GithubBloc? githubBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async{
      githubBloc!.getRepos();
    });

  }

  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: githubBloc!.repos.stream,
        builder: (context, snapshot) {
          if(snapshot.data == null){
            return Center(child: Container(height: 50, width: 50, child: const CircularProgressIndicator()));
          }
          return Column(
            children: [
              Text("Choose Repo", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () {
                          var project = Project(repoName: snapshot.data![index]);
                          githubBloc!.newProject.add(project);
                          setState(() {
                            
                          });
                        },
                        leading: ClipOval(
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Image.network(githubBloc!.currentUser!.profileUrl!),
                        ),
                        
                      ),
                        title: Text(snapshot.data![index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        trailing: githubBloc!.newProject.valueOrNull == null ? null : snapshot.data![index] == githubBloc!.newProject.value.repoName ? ClipOval(child: Container(color: Colors.green, padding: EdgeInsets.all(10), child: Icon(Icons.check),)) : null,

                      ),
                    );
                })),
              ),
            ],
          );
      },)
    );
  }
}


class Branch extends StatefulWidget {
  const Branch({super.key});

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  GithubBloc? githubBloc;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async{
      githubBloc!.getBranches(githubBloc!.newProject.value.repoName!);
    });

  }

  @override
  Widget build(BuildContext context) {
    githubBloc ??= Provider.of<GithubBloc>(context);
    githubBloc!.getBranches(githubBloc!.newProject.value.repoName!);
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      padding: const EdgeInsets.all(10),
      child: StreamBuilder(
        stream: githubBloc!.branches.stream,
        builder: (context, snapshot) {
          if(snapshot.data == null){
            return SizedBox();
          }
          return Column(
            children: [
              Text("Choose Branch", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () async{
                          var res = await githubBloc!.newProject.valueOrNull;
                          if(res != null){
                            print(res);
                            res.branch = snapshot.data![index];
                            githubBloc!.newProject.add(res);
                          }
                          setState(() {
                            
                          });
                        },
                        leading: ClipOval(
                        child: Container(
                          height: 40,
                          width: 40,
                          child: Image.network(githubBloc!.currentUser!.profileUrl!),
                        ),
                        
                      ),
                        title: Text(snapshot.data![index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                        trailing: githubBloc!.newProject.valueOrNull == null ? null : snapshot.data![index] == githubBloc!.newProject.value.branch ? ClipOval(child: Container(color: Colors.green, padding: EdgeInsets.all(10), child: Icon(Icons.check),)) : null,

                      ),
                    );
                })),
              ),
            ],
          );
      },)
    );
  }
}