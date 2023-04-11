import 'dart:convert';

import 'package:easydeploy/main.dart';
import 'package:easydeploy/models/project.dart';
import 'package:easydeploy/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ServiceLayer{
  String url = "https://backend-42m54a5jz-bharathcherukuri007.vercel.app";
  SharedPreferences? prefs;

  Future<Map<String, String>>? headers() async{
    var prefs = await SharedPreferences.getInstance();
    return {
      "Content-Type": "application/json",
      "Authorization": prefs.getString("access-token")!,
    };

  }



  Future<User?> authenticate(String code) async{
    var body = jsonEncode({
      "code": code
    });
    var res = await http.post(Uri.parse('$url/authentication'), body: body, headers: {
      "Content-Type": "application/json"
    });
    if(res.statusCode == 200){
      var body = jsonDecode(res.body);
      prefs = await SharedPreferences.getInstance();
      prefs!.setString("username", body["user"]["username"]);
      prefs!.setString("access-token", body["token"]);
      prefs!.setString("profileUrl", body["user"]["profileUrl"]);
      prefs!.setString("email", body["user"]["email"]);
      return User.fromJSON(body["user"]);

    }
    else{
      return null;
    }
  }

  Future<List<Project>> getProjects() async{
    var h = await headers();
    var p = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "username": p.getString("username")!.toString()
  });
    var res = await http.get(Uri.parse('$url/home'), headers: h,);
    if(res.statusCode == 200){
      var body = jsonDecode(res.body);
      List<Project> projects = [];
      for(var p in body){
        projects.add(Project.fromJSON(p));
      }
      return projects;
    } 
    else{
      print("hello");
      p!.clear();
      throw Exception();
    }
    return [];
  }

  Future<List<String>?> getRepos() async{
    var h = await headers();
    var p = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "username": p.getString("username")!.toString()
  });
    var res = await http.post(Uri.parse("$url/repos",), body: body, headers: h);
    List<String> repos = [];
    if(res.statusCode == 200){
      List<dynamic> body = jsonDecode(res.body);
      for(var repo in body){
        repos.add(repo["name"]);

      }
    }
    return repos;
  }

  Future<List<String>?> getBranches(String repo) async{
    var h = await headers();
    var p = await SharedPreferences.getInstance();
    var body = jsonEncode({
      "repo": repo,
      "username": p.getString("username")!.toString()
  });
    var res = await http.post(Uri.parse("$url/branches",), body: body, headers: h);
    List<String> branches = [];
    if(res.statusCode == 200){
      List<dynamic> body = jsonDecode(res.body);
      for(var branch in body){
        branches.add(branch["name"]);

      }
    }
    return branches;
  }
  Future<Map<String, String>> validateSite(String name) async{
    var h = await headers();
    var body = jsonEncode(
      {
        "name" : name
      }
    );
    var res = await http.post(Uri.parse('$url/create/site'), body: body, headers: h);
    
    if(res.statusCode == 200){
      var b = jsonDecode(res.body);
      return {
        "site_id": b["site_id"],
        "site_name": b["ssl_url"]
      };

    }
    return {};
  } 

  Future<bool> addWebHook(String username, String repo) async{
    var h = await headers();
    var body = jsonEncode(
      {
        "username" : username,
        "repo": repo
      }
    );
    var res = await http.post(Uri.parse('$url/create/webhook'), body: body, headers: h);
    
    if(res.statusCode == 200){
      return true;

    }
    return false;

  }

  Future<bool> deploySite(Project project, User user) async{
    var h = await headers();
    var body = jsonEncode({
        "message": "added",
      "repo": project.repoName,
      "branch": project.branch,
      "username": user.userName,
      "framework": project.frameWork,
      "version": project.version,
      "path": project.path,
      "site_name": project.siteName,
      "site_id": project.siteId,
      "committer": {
          "name": user.userName,
          "email": user.email
      }
    }
    );
    var res = await http.post(Uri.parse('$url/workflow'), body: body, headers: h);
    if(res.statusCode == 200){
      return true;

    }
    return false;

  }



}
