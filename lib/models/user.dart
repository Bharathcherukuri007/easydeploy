class User{
String? userName;
String? profileUrl;
String? email;
User.fromJSON(dynamic json){
  userName = json["username"];
  profileUrl = json["profileUrl"];
  email = json["email"];

}
User({this.userName, this.profileUrl, this.email});

}