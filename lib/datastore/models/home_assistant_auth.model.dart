class HomeAssistantAuth {
  String? url;
  String? token;
  int? expires;
  String? refreshToken;
  String? tokenType;

  HomeAssistantAuth(
      this.url, this.token, this.expires, this.refreshToken, this.tokenType);

  HomeAssistantAuth.fromJson(Map<String, dynamic> json) {
    url = json["url"];
    token = json["token"];
    expires = json["expires"];
    refreshToken = json["refreshToken"];
    tokenType = json["tokenType"];
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'token': token,
      'expires': expires,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
    };
  }
}
