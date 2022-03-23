import 'dart:convert';

class HomeAssistantAuth {
  Uri? url;
  String? token;
  int? expires;
  String? refreshToken;
  String? tokenType;

  HomeAssistantAuth(
      this.url, this.token, this.expires, this.refreshToken, this.tokenType);

  HomeAssistantAuth.json(Map<String, dynamic> json) {
    url = json["url"];
    token = json["token"];
    expires = json["expires"];
    refreshToken = json["refreshToken"];
    tokenType = json["tokenType"];
  }
}
