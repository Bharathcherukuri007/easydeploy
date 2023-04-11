class Project{
  String? repoName;
  String? branch;
  String? siteId;
  String? siteName;
  String? frameWork;
  String? version;
  String? conclusion;
  String? status;
  String? path;
  String? email;

  Project.fromJSON(dynamic json){
    repoName = json["repo_name"];
    branch = json["branch_name"];
    siteId = json["site_id"];
    siteName = json["site_name"];
    frameWork = json["framework"];
    version = json["version"];
    conclusion = json["conclusion"] ?? "";
    status = json["status"] ?? "";
    path = json["path"] ?? "";
    email = json["email"] ?? "";
  }
  Project({this.repoName, this.branch, this.siteId, this.siteName, this.frameWork, this.conclusion, this.status, this.version, this.path, this.email});
}