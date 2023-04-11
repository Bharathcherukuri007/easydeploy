import 'package:easydeploy/models/project.dart';
import 'package:easydeploy/models/user.dart';
import 'package:easydeploy/service/service_layer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easydeploy/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GithubBloc{
  final _project = BehaviorSubject<List<Project>?>();
  final _user = BehaviorSubject<User>();
  final ServiceLayer serviceLayer = ServiceLayer();
  final repos = BehaviorSubject<List<String>>();
  final branches = BehaviorSubject<List<String>>();
  final newProject = BehaviorSubject<Project>();
  get userStream => _user.stream;
  get projectStream => _project.stream;
  SharedPreferences? prefs;
  Future<bool> isLoggedIn() async{
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("username") != null;
  }



  void addProject(Project project){
    currentProjects!.add(project);
    _project.add(currentProjects!);
  }

  void addUser(User user){
    _user.add(user);
  }

  void authenticate(String code) async{ 
    User? user = await serviceLayer.authenticate(code);
    if(user != null){
      _user.add(user);
    }

  }

  void getProjects() async{
    try{

      var res = await serviceLayer.getProjects();
      _project.add(res);
    }
    catch(e){
      prefs = await SharedPreferences.getInstance();
      _user.add(User());
      _project.add(null);
      prefs!.clear();

    }
  }


  void getRepos() async{
    var res = await serviceLayer.getRepos();
    repos.add(res!);
  }
  void getBranches(String repo) async{
    var res = await serviceLayer.getBranches(repo);
    branches.add(res!);
  }
  Future<bool> validateSite(String name) async{
    var res = await serviceLayer.validateSite(name);
    if(res.isEmpty){
      return false;
    }
    var project = newProject.value;
    project.siteId = res["site_id"];
    project.siteName = res["site_name"];
    newProject.add(project);
    return true;
  }
  Future<bool> addWebHook(String username, String repo ) async{
    var res = await serviceLayer.addWebHook(username, repo);
    return res;
  }
  Future<bool> deploySite(Project project, User user) async{
    var res = await serviceLayer.deploySite(project, user);
    return res;
  }


  List<Project>? get currentProjects => _project.valueOrNull;
  User? get currentUser =>_user.valueOrNull;
 


}