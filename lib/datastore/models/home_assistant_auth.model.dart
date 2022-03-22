class HomeAssistantAuth {
  final String token;

  HomeAssistantAuth({
    required this.token,
    required int expires,
    required String refresh_token,
    required String token_type});
}
