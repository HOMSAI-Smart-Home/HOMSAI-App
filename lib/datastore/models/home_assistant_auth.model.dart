class HomeAssistantAuth {
  String? token;
  int? expires;
  String? refreshToken;
  String? tokenType;

  HomeAssistantAuth(
      this.token, this.expires, this.refreshToken, this.tokenType);

  HomeAssistantAuth.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    expires = json["expires"];
    refreshToken = json["refreshToken"];
    tokenType = json["tokenType"];
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'expires': expires,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
    };
  }
}
